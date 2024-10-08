import 'package:flutter/material.dart';
import 'trainer_page.dart'; // Import the trainer page
import 'package:url_launcher/url_launcher.dart'; // Required to launch URLs

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  // Function to open URL
  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
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
              'Diet Plan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        elevation: 4, // Slight shadow for the header
        iconTheme: const IconThemeData(
          color: Colors.white, // This sets the icon color to white
        ),
      ),
      body: Stack(
        children: [
          // Existing Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/icon/diet_bg.png',
              // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlay with reduced opacity for readability
          Positioned.fill(
            child: Container(
              color: Colors.black
                  .withOpacity(0.5), // Semi-transparent black overlay
            ),
          ),
          // Main Content
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title Text
                  const Text(
                    'Your Fitness Journey Starts Here',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Generate Diet Plan Button
                  _buildButton(
                    context,
                    'Generate Diet Plan with Trainer',
                    const Icon(Icons.fitness_center, color: Colors.white),
                    Colors.grey[850]!, // Dark grey button
                    TrainerPage(),
                  ),
                  const SizedBox(height: 20),
                  // Track Your Meal Button
                  _buildButton(
                    context,
                    'Track Your Meal',
                    const Icon(Icons.restaurant_menu, color: Colors.white),
                    Colors.grey[700]!, // Medium grey button
                    null, // No page, we launch a URL instead
                    url: 'https://www.eatthismuch.com/', // URL to track meals
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable button builder for creating attractive buttons
  Widget _buildButton(
      BuildContext context, String label, Icon icon, Color color, Widget? page,
      {String? url}) {
    return ElevatedButton.icon(
      onPressed: () {
        if (url != null) {
          _launchURL(url);
        } else if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center, // Ensure text is centered
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(25), // Rounded corners for buttons
        ),
        shadowColor: Colors.black45,
        elevation: 12,
        // Raised effect for buttons
        alignment:
            Alignment.center, // Center the text and icon inside the button
      ),
    );
  }
}
