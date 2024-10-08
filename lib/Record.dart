import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Record extends StatefulWidget {
  final VoidCallback onRecordPressed;
  final List<Map<String, dynamic>> resistanceRecords;
  final List<Map<String, dynamic>> cardioRecords;

  const Record({
    Key? key,
    required this.onRecordPressed,
    required this.resistanceRecords,
    required this.cardioRecords,
  }) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> filteredCardioRecords = [];
  List<Map<String, dynamic>> filteredResistanceRecords = [];
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchRecords(
        selectedDate); // Fetch records for the current date at startup
  }

  Future<void> _fetchRecords(DateTime date) async {
    setState(() {
      isLoading = true;
    });

    try {
      final cardioSnapshot =
          await FirebaseFirestore.instance.collection('cardioRecords').get();
      final resistanceSnapshot = await FirebaseFirestore.instance
          .collection('resistanceRecords')
          .get();

      List<Map<String, dynamic>> cardioRecords = cardioSnapshot.docs.map((doc) {
        return {'docId': doc.id, ...doc.data()};
      }).toList();

      List<Map<String, dynamic>> resistanceRecords =
          resistanceSnapshot.docs.map((doc) {
        return {'docId': doc.id, ...doc.data()};
      }).toList();

      _filterRecordsByDate(cardioRecords, resistanceRecords, date);
    } catch (e) {
      print('Error fetching records: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterRecordsByDate(List<Map<String, dynamic>> cardioRecords,
      List<Map<String, dynamic>> resistanceRecords, DateTime date) {
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    setState(() {
      filteredCardioRecords = cardioRecords
          .where((record) => record['date'].startsWith(formattedDate))
          .toList();
      filteredResistanceRecords = resistanceRecords
          .where((record) => record['date'].startsWith(formattedDate))
          .toList();
    });
  }

  Future<void> _deleteRecord(String docId, bool isCardio) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection(isCardio ? 'cardioRecords' : 'resistanceRecords')
          .doc(docId)
          .delete();

      setState(() {
        if (isCardio) {
          filteredCardioRecords
              .removeWhere((record) => record['docId'] == docId);
        } else {
          filteredResistanceRecords
              .removeWhere((record) => record['docId'] == docId);
        }
      });
    } catch (e) {
      print('Error deleting record: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              'Record',
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
        iconTheme: const IconThemeData(
          color: Colors.white, // This sets the icon color to white
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    focusedDay: selectedDate,
                    firstDay:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now(),
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        selectedDate = selectedDay;
                        _fetchRecords(selectedDate);
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Cardio Records'),
                      Tab(text: 'Resistance Records'),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        400, // Adjust the height as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildRecordList(filteredCardioRecords, true),
                        _buildRecordList(filteredResistanceRecords, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRecordList(List<Map<String, dynamic>> records, bool isCardio) {
    return records.isEmpty
        ? const Center(child: Text('No records for this date.'))
        : ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return _buildRecordTile(context, record, isCardio);
            },
          );
  }

  Widget _buildRecordTile(
      BuildContext context, Map<String, dynamic> record, bool isCardio) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise: ${record['exerciseName'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 18),
            ),
            if (isCardio)
              Text(
                  'Distances: ${record['distances']?.toString() ?? 'N/A'} km/miles'),
            if (!isCardio) ...[
              Text('Reps: ${record['reps'] ?? 'N/A'}'),
              Text('Weights: ${record['weights']?.toString() ?? 'N/A'} kg/lbs'),
            ],
            Text('Date: ${record['date']}'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _deleteRecord(record['docId'], isCardio);
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
