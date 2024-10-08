import 'package:flutter/material.dart';

class SupplementKnowledgePage extends StatelessWidget {
  SupplementKnowledgePage({super.key}); // Removed 'const' here

  final List<Map<String, String>> supplements = [
    {
      'name': 'Protein Powder',
      'description':
          'A convenient way to increase protein intake, essential for muscle repair and growth.',
      'benefits':
          'Supports muscle growth, recovery, and helps maintain lean muscle mass.',
      'dosage': '20-30 grams post-workout or as needed.',
      'sideEffects': 'May cause digestive issues in some individuals.',
      'sources': 'Whey, casein, soy, pea, and egg protein powders.',
      'tips': 'Mix with water or milk, or add to smoothies for better taste.'
    },
    {
      'name': 'Creatine',
      'description':
          'Helps produce energy during high-intensity exercise, enhancing performance.',
      'benefits': 'Increases strength, muscle mass, and aids in recovery.',
      'dosage': '5 grams daily, ideally after workout.',
      'sideEffects': 'May cause water retention or digestive discomfort.',
      'sources': 'Red meat and fish; also produced by the body.',
      'tips': 'Stay hydrated; consider a loading phase for faster results.'
    },
    {
      'name': 'BCAAs',
      'description':
          'Essential amino acids that may help reduce muscle soreness and stimulate muscle growth.',
      'benefits':
          'Improves exercise performance and reduces fatigue during workouts.',
      'dosage': '5-10 grams before or after workouts.',
      'sideEffects': 'Generally safe; may cause fatigue in rare cases.',
      'sources': 'Meat, eggs, and dairy products.',
      'tips': 'Take during workouts for enhanced endurance.'
    },
    {
      'name': 'Omega-3 Fatty Acids',
      'description':
          'Essential fats important for heart health, brain function, and reducing inflammation.',
      'benefits':
          'Supports joint health, improves mood, and enhances cognitive function.',
      'dosage':
          '1-3 grams per day, ideally from fish oil or algae supplements.',
      'sideEffects':
          'May cause fishy aftertaste or gastrointestinal discomfort.',
      'sources': 'Fatty fish (salmon, mackerel), flaxseeds, and walnuts.',
      'tips': 'Take with meals to reduce digestive issues.'
    },
    {
      'name': 'Multivitamins',
      'description':
          'Daily supplements that provide various vitamins and minerals to fill nutritional gaps.',
      'benefits':
          'Supports overall health, immune function, and energy levels.',
      'dosage': 'One tablet per day, or as directed on the label.',
      'sideEffects':
          'Excessive intake can lead to toxicity; consult a healthcare provider if unsure.',
      'sources':
          'Varies; includes vitamins from fruits, vegetables, and whole grains.',
      'tips': 'Take with food for better absorption of fat-soluble vitamins.'
    },
    {
      'name': 'Vitamin D',
      'description':
          'Essential for bone health, immune function, and mood regulation.',
      'benefits': 'Promotes calcium absorption, supporting bone health.',
      'dosage': '600-800 IU per day, higher for deficiency.',
      'sideEffects': 'Excess can lead to toxicity; nausea and vomiting.',
      'sources': 'Sunlight, fatty fish, fortified foods, and supplements.',
      'tips': 'Get sunlight exposure; consider testing levels if concerned.'
    },
    {
      'name': 'Magnesium',
      'description':
          'Mineral important for muscle function, energy production, and bone health.',
      'benefits':
          'May reduce muscle cramps, support heart health, and improve sleep quality.',
      'dosage': '310-420 mg per day, depending on age and gender.',
      'sideEffects': 'High doses may cause diarrhea and abdominal discomfort.',
      'sources': 'Nuts, seeds, whole grains, and green leafy vegetables.',
      'tips': 'Consider magnesium citrate for better absorption.'
    },
    {
      'name': 'Zinc',
      'description':
          'Mineral essential for immune function, protein synthesis, and wound healing.',
      'benefits': 'Supports immune health, may improve athletic performance.',
      'dosage': '8-11 mg per day, higher for athletes.',
      'sideEffects': 'Excess can lead to nausea and gastrointestinal issues.',
      'sources': 'Meat, shellfish, legumes, seeds, and nuts.',
      'tips': 'Take zinc with food to minimize stomach upset.'
    },
    {
      'name': 'Probiotics',
      'description':
          'Live beneficial bacteria that support gut health and digestion.',
      'benefits':
          'May improve digestive health, enhance immune function, and reduce inflammation.',
      'dosage': 'Varies by strain; typically 1-10 billion CFUs per day.',
      'sideEffects': 'Generally safe; may cause bloating in some individuals.',
      'sources': 'Yogurt, kefir, sauerkraut, and fermented foods.',
      'tips': 'Choose a probiotic with multiple strains for broader benefits.'
    },
  ];

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
              'Supplement Knowledge',
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
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/icon/supplement_knowledge_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          ListView.builder(
            itemCount: supplements.length,
            itemBuilder: (context, index) {
              final supplement = supplements[index];
              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.white.withOpacity(0.8),
                // Slight transparency for better blending
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplement['name']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        supplement['description']!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Benefits: ${supplement['benefits']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Recommended Dosage: ${supplement['dosage']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Potential Side Effects: ${supplement['sideEffects']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Dietary Sources: ${supplement['sources']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Tips: ${supplement['tips']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
