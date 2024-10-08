import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cardio_page.dart';
import 'resistance_page.dart';
import 'diet_page.dart';
import 'trainer_page.dart';
import 'common_mistake_page.dart';
import 'supplement_knowledge_page.dart';
import 'record.dart'; // Import the Record page

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  // Navigate to the Record page
  void _openRecordPage(BuildContext context) {
    List<Map<String, dynamic>> cardioRecords = []; // Initialize if needed
    List<Map<String, dynamic>> resistanceRecords = []; // Initialize if needed

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Record(
          cardioRecords: cardioRecords,
          resistanceRecords: resistanceRecords,
          onRecordPressed: () {}, // Pass empty list
        ),
      ),
    );
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
              'WellnessVault',
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
            onPressed: () => _openRecordPage(context),
            tooltip: 'Record',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white, // This sets the icon color to white
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/icon/bg.png', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Modules Grid
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                children: [
                  _buildModule(
                      context, Icons.directions_run, 'Cardio', CardioPage()),
                  _buildModule(context, Icons.fitness_center, 'Resistance',
                      ResistancePage()),
                  _buildModule(context, Icons.fastfood, 'Diet', DietPage()),
                  _buildModule(context, Icons.person, 'Trainer', TrainerPage()),
                  _buildModule(context, Icons.error, 'Common Mistake',
                      CommonMistakePage()),
                  _buildModule(context, Icons.library_books,
                      'Supplement Knowledge', SupplementKnowledgePage()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModule(
      BuildContext context, IconData icon, String title, Widget page) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 50.0, color: Colors.black),
              const SizedBox(height: 10.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
