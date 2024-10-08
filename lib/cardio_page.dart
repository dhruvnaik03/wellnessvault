import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'record.dart';

class CardioPage extends StatefulWidget {
  const CardioPage({super.key});

  @override
  _CardioPageState createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  String? _exerciseName;
  int? _sets;
  List<double?> _distances = []; // To store distances for each set
  List<String> _selectedMuscleGroups = []; // Initialize as an empty list

  final List<String> _cardioExercises = [
    'Treadmill Running/Walking',
    'Stationary Cycling',
    'Rowing Machine',
    'Elliptical Trainer',
    'Stair Climber',
    'Arc Trainer',
    'Battle Ropes',
    'Box Jumps',
    'Jumping Jacks',
    'Cardio Kickboxing',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _exerciseController = TextEditingController();
  bool _isLoading = false; // Track loading state

  // Save data to Firestore
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      String formattedDate =
          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      String currentDay = DateFormat('EEEE').format(DateTime.now());

      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        await FirebaseFirestore.instance.collection('cardioRecords').add({
          'exerciseName': _exerciseName,
          'sets': _sets,
          'distances': _distances, // Store list of distances
          'date': formattedDate,
          'day': currentDay,
          'muscleGroups': _selectedMuscleGroups,
          'userId': FirebaseAuth.instance.currentUser?.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Saved: $_exerciseName, $_sets sets, distances $_distances on $formattedDate'),
          ),
        );

        _clearForm();
      } catch (e) {
        print("Error saving data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  void _openRecordPage() async {
    // Fetch cardio records
    List<Map<String, dynamic>> cardioRecords = await _fetchCardioRecords();

    // Fetch resistance records
    List<Map<String, dynamic>> resistanceRecords =
        await _fetchResistanceRecords();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Record(
          cardioRecords: cardioRecords,
          resistanceRecords: resistanceRecords,
          onRecordPressed: () {},
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCardioRecords() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User is not authenticated.");
      return [];
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('cardioRecords')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'docId': doc.id,
          'exerciseName': doc['exerciseName'],
          'sets': doc['sets'],
          'distances': doc['distances'], // Fetch stored distances
          'date': doc['date'],
          'day': doc['day'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching cardio records: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchResistanceRecords() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User is not authenticated.");
      return [];
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('resistanceRecords')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'docId': doc.id,
          'exerciseName': doc['exerciseName'],
          'sets': doc['sets'],
          'reps': doc['reps'],
          'date': doc['date'],
          'day': doc['day'],
          'muscleGroups': doc['muscleGroups'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching resistance records: $e");
      return [];
    }
  }

  void _clearForm() {
    _exerciseController.clear();
    _setsController.clear();
    setState(() {
      _selectedMuscleGroups = [];
      _exerciseName = null;
      _sets = null;
      _distances = [];
    });
  }

  @override
  void dispose() {
    _setsController.dispose();
    _exerciseController.dispose();
    super.dispose();
  }

  // Dynamically create distance fields based on sets entered
  List<Widget> _buildDistanceFields() {
    List<Widget> fields = [];
    for (int i = 0; i < (_sets ?? 0); i++) {
      fields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter Distance for Set ${i + 1} (km or miles)',
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              setState(() {
                // Ensure the list has the correct size
                if (i >= _distances.length) {
                  _distances.add(null);
                }
                _distances[i] = double.tryParse(value);
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the distance for set ${i + 1}';
              }
              final distance = double.tryParse(value);
              if (distance == null) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),
        ),
      );
    }
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icon/bar_icon.png', // Path to your app icon
              height: 40.0, // Adjust the height as needed
            ),
            const SizedBox(width: 8.0), // Space between the icon and text
            const Text(
              'Cardio Tracker',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _openRecordPage,
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white, // This sets the icon color to white
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/icon/cardio_bg.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5), // Darken background
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Day: ${DateFormat('EEEE').format(DateTime.now())}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _exerciseController,
                            decoration: InputDecoration(
                              labelText: 'Enter Cardio Exercise',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _exerciseName = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          if (_exerciseController.text.isNotEmpty)
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: _cardioExercises
                                  .where((exercise) => exercise
                                      .toLowerCase()
                                      .contains(_exerciseController.text
                                          .toLowerCase()))
                                  .map((exercise) => ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _exerciseController.text = exercise;
                                            _exerciseName = exercise;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: Text(exercise),
                                      ))
                                  .toList(),
                            ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _setsController,
                            decoration: InputDecoration(
                              labelText: 'Enter Sets',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _sets = int.tryParse(value) ?? 0;
                                _distances = List<double?>.filled(_sets!, null);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the number of sets';
                              }
                              _sets = int.tryParse(value);
                              if (_sets == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          ..._buildDistanceFields(),
                          // Dynamically add distance fields
                          const SizedBox(height: 32.0),
                          Center(
                            child: _isLoading // Show loading indicator
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _saveData,
                                    child: const Text('Record'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
