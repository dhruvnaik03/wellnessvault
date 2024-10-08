import 'package:flutter/material.dart';

class TrainerPage extends StatefulWidget {
  const TrainerPage({super.key});

  @override
  _TrainerPageState createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  final List<String> _clients = []; // List to hold clients
  final TextEditingController _clientController =
      TextEditingController(); // Controller for client input
  final TextEditingController _workoutPlanController =
      TextEditingController(); // Controller for workout plan input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icon/bar_icon.png',
              height: 40.0,
            ),
            const SizedBox(width: 8.0),
            const Text(
              'Trainer',
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/icon/trainer_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Trainer Profile Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/icon/trainer_avatar.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trainer Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Expertise: Fitness Coach',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Client Entry Section
                TextField(
                  controller: _clientController,
                  decoration: const InputDecoration(
                    labelText: 'Add Client Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_clientController.text.isNotEmpty) {
                      setState(() {
                        _clients.add(
                            _clientController.text); // Add client to the list
                        _clientController.clear(); // Clear input field
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Add Client'),
                ),
                const SizedBox(height: 20),

                // Clients List
                Expanded(
                  child: ListView.builder(
                    itemCount: _clients.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(_clients[index]), // Display client name
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              // Navigate to client details
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Workout Plan Entry Section
                TextField(
                  controller: _workoutPlanController,
                  decoration: const InputDecoration(
                    labelText: 'Create Workout Plan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Action to handle the workout plan
                    if (_workoutPlanController.text.isNotEmpty) {
                      // Here you can handle the workout plan (e.g., save to a list, show a dialog, etc.)
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Workout Plan Created'),
                          content: Text('Plan: ${_workoutPlanController.text}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      _workoutPlanController.clear(); // Clear input field
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Save Workout Plan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
