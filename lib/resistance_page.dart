import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'record.dart'; // Make sure to import the Record page

class ResistancePage extends StatefulWidget {
  const ResistancePage({super.key});

  @override
  _ResistancePageState createState() => _ResistancePageState();
}

class _ResistancePageState extends State<ResistancePage> {
  String? _exerciseName;
  int? _sets;
  List<String> _selectedMuscleGroups = [];
  bool _isLoading = false; // Loading state variable

  // Grouped exercise lists
  final Map<String, List<String>> _exerciseGroups = {
    'Upper Body': [
      'Bench Press',
      'Chest Fly',
      'Push-ups',
      'Deadlifts',
      'Pull-ups/Chin-ups',
      'Lat Pulldown',
      'Barbell/Dumbbell Rows',
      'Overhead Shoulder Press',
      'Lateral Raises',
      'Front Raises',
      'Bicep Curls',
      'Tricep Dips',
      'Tricep Pushdown',
      'Hammer Curls',
    ],
    'Lower Body': [
      'Squats',
      'Leg Press',
      'Lunges',
      'Romanian Deadlifts',
      'Hamstring Curls',
      'Glute Ham Raise',
      'Hip Thrusts',
      'Step-ups',
      'Bulgarian Split Squats',
      'Standing Calf Raise',
      'Seated Calf Raise',
    ],
    'Core': [
      'Planks',
      'Russian Twists',
      'Hanging Leg Raise',
      'Cable Crunch',
    ],
  };

  List<String> _selectedExercises = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _exerciseController = TextEditingController();
  List<TextEditingController> _repsControllers = [];
  List<TextEditingController> _weightsControllers = [];

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      String formattedDate =
          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      String currentDay = DateFormat('EEEE').format(DateTime.now());

      try {
        // Prepare data to save
        List<int> reps = _repsControllers
            .map((controller) => int.parse(controller.text))
            .toList();
        List<double> weights = _weightsControllers
            .map((controller) => double.parse(controller.text))
            .toList();

        // Using batch writes for better performance
        WriteBatch batch = FirebaseFirestore.instance.batch();
        DocumentReference docRef =
            FirebaseFirestore.instance.collection('resistanceRecords').doc();

        // Create the document
        batch.set(docRef, {
          'exerciseName': _exerciseName,
          'sets': _sets,
          'reps': reps,
          'weights': weights,
          'date': formattedDate,
          'day': currentDay,
          'muscleGroups': _selectedMuscleGroups,
          'userId': FirebaseAuth.instance.currentUser?.uid,
        });

        // Commit the batch
        await batch.commit();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Saved: $_exerciseName, $_sets sets on $formattedDate')),
        );

        _clearForm();
      } catch (e) {
        print("Error saving data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: Please try again later')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  void _clearForm() {
    _exerciseController.clear();
    _setsController.clear();
    setState(() {
      _selectedMuscleGroups.clear();
      _exerciseName = null;
      _sets = null;
      _repsControllers.forEach((controller) => controller.dispose());
      _weightsControllers.forEach((controller) => controller.dispose());
      _repsControllers.clear();
      _weightsControllers.clear();
      _selectedExercises.clear(); // Clear selected exercises
    });
  }

  void _updateSets(int? value) {
    if (value != null) {
      setState(() {
        _sets = value;
        _repsControllers.forEach((controller) => controller.dispose());
        _weightsControllers.forEach((controller) => controller.dispose());

        _repsControllers = List.generate(value, (_) => TextEditingController());
        _weightsControllers =
            List.generate(value, (_) => TextEditingController());
      });
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
          'weights': doc['weights'],
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

  void _openRecordPage() async {
    List<Map<String, dynamic>> resistanceRecords =
        await _fetchResistanceRecords();
    List<Map<String, dynamic>> cardioRecords = await _fetchCardioRecords();

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
          'distance': doc['distance'],
          'date': doc['date'],
          'day': doc['day'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching cardio records: $e");
      return [];
    }
  }

  @override
  void dispose() {
    _setsController.dispose();
    _exerciseController.dispose();
    _repsControllers.forEach((controller) => controller.dispose());
    _weightsControllers.forEach((controller) => controller.dispose());
    super.dispose();
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
              ' Resistance Tracker',
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icon/resistance_bg.png'),
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
        child: _isLoading // Show loading indicator while saving
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the exercise groups as buttons with improved visibility
                        ..._exerciseGroups.keys.map((category) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              MultiSelectChip(
                                _exerciseGroups[category]!,
                                selectedChoices: _selectedExercises,
                                onSelectionChanged: (selectedList) {
                                  setState(() {
                                    _selectedExercises = selectedList;

                                    // Update the exercise name based on selection or manual entry
                                    _exerciseName = selectedList.isNotEmpty
                                        ? selectedList
                                            .join(', ') // Concatenating names
                                        : _exerciseController.text;

                                    // Update the text box with selected exercises
                                    _exerciseController.text =
                                        _exerciseName ?? '';
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),
                        // Exercise text input
                        TextFormField(
                          controller: _exerciseController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Exercise Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an exercise name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _exerciseName =
                                  value; // Update based on manual input
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _setsController,
                          decoration: const InputDecoration(
                            labelText: 'Sets',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the number of sets';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _updateSets(int.tryParse(value));
                          },
                        ),
                        const SizedBox(height: 16),
                        // Dynamically build input fields for reps and weights based on sets
                        ...List.generate(
                          _sets ?? 0,
                          (index) => Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _repsControllers[index],
                                  decoration: const InputDecoration(
                                    labelText: 'Reps',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number of reps';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _weightsControllers[index],
                                  decoration: const InputDecoration(
                                    labelText: 'Weight (lbs)',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the weight';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _saveData,
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> choices;
  final List<String> selectedChoices;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectChip(this.choices,
      {Key? key,
      required this.selectedChoices,
      required this.onSelectionChanged})
      : super(key: key);

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: widget.choices.map((choice) {
        return ChoiceChip(
          label: Text(choice),
          selected: widget.selectedChoices.contains(choice),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                widget.selectedChoices.add(choice);
              } else {
                widget.selectedChoices.remove(choice);
              }
              widget.onSelectionChanged(widget.selectedChoices);
            });
          },
        );
      }).toList(),
    );
  }
}
