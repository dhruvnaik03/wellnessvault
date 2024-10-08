import 'package:flutter/material.dart';

class CommonMistakePage extends StatelessWidget {
  const CommonMistakePage({super.key});

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
              'Common Mistakes',
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
              'assets/icon/common_mistake_bg.png',
              // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6), // Dark overlay
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Select an Exercise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildExerciseTile(context, 'Bench Press'),
                      _buildExerciseTile(context, 'Deadlift'),
                      _buildExerciseTile(context, 'Squat'),
                      _buildExerciseTile(context, 'Overhead Press'),
                      _buildExerciseTile(context, 'Pull-Up'),
                      _buildExerciseTile(context, 'Lat Pulldown'),
                      _buildExerciseTile(context, 'Leg Press'),
                      _buildExerciseTile(context, 'Dumbbell Curl'),
                      _buildExerciseTile(context, 'Tricep Dip'),
                      _buildExerciseTile(context, 'Lunges'),
                      _buildExerciseTile(context, 'Chest Fly'),
                      _buildExerciseTile(context, 'Push-ups'),
                      _buildExerciseTile(context, 'Barbell/Dumbbell Rows'),
                      _buildExerciseTile(context, 'Lateral Raises'),
                      _buildExerciseTile(context, 'Front Raises'),
                      _buildExerciseTile(context, 'Tricep Pushdown'),
                      _buildExerciseTile(context, 'Hammer Curls'),
                      _buildExerciseTile(context, 'Romanian Deadlifts'),
                      _buildExerciseTile(context, 'Hamstring Curls'),
                      _buildExerciseTile(context, 'Glute Ham Raise'),
                      _buildExerciseTile(context, 'Hip Thrusts'),
                      _buildExerciseTile(context, 'Step-ups'),
                      _buildExerciseTile(context, 'Bulgarian Split Squats'),
                      _buildExerciseTile(context, 'Standing Calf Raise'),
                      _buildExerciseTile(context, 'Seated Calf Raise'),
                      _buildExerciseTile(context, 'Planks'),
                      _buildExerciseTile(context, 'Russian Twists'),
                      _buildExerciseTile(context, 'Hanging Leg Raise'),
                      _buildExerciseTile(context, 'Cable Crunch'),
                      // Add more exercises here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTile(BuildContext context, String exerciseName) {
    return ListTile(
      title: Text(
        exerciseName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: () {
        // Navigate to details page for the selected exercise
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ExerciseDetailPage(exerciseName: exerciseName),
          ),
        );
      },
    );
  }
}

class ExerciseDetailPage extends StatelessWidget {
  final String exerciseName;

  const ExerciseDetailPage({required this.exerciseName, super.key});

  @override
  Widget build(BuildContext context) {
    final mistakes = _getExerciseMistakes(exerciseName);

    return Scaffold(
      appBar: AppBar(
        title: Text('$exerciseName Mistakes'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white, // This sets the icon color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: mistakes.length,
          itemBuilder: (context, index) {
            final mistake = mistakes[index];
            return _buildMistakeCard(
                mistake['mistake']!, mistake['description']!);
          },
        ),
      ),
    );
  }

  List<Map<String, String>> _getExerciseMistakes(String exerciseName) {
    switch (exerciseName) {
      case 'Bench Press':
        return [
          {
            'mistake': 'Incorrect grip width',
            'description':
                'Using a grip that’s too wide or too narrow can cause shoulder strain or ineffective muscle targeting.'
          },
          {
            'mistake': 'Bouncing bar off chest',
            'description':
                'Bouncing the bar off the chest reduces muscle activation and can cause injury.'
          },
          {
            'mistake': 'Elbows flaring out',
            'description':
                'Flaring your elbows increases strain on your shoulders and reduces the effectiveness of the chest workout.'
          },
        ];
      case 'Deadlift':
        return [
          {
            'mistake': 'Rounded back',
            'description':
                'Lifting with a rounded back can lead to lower back injury. Keep a neutral spine.'
          },
          {
            'mistake': 'Bar too far from shins',
            'description':
                'Keeping the bar close to your body helps avoid unnecessary stress on your lower back.'
          },
          {
            'mistake': 'Locking knees too early',
            'description':
                'Locking the knees before extending the hips puts you in a weaker position and increases injury risk.'
          },
        ];
      case 'Squat':
        return [
          {
            'mistake': 'Knees caving inwards',
            'description':
                'Letting your knees collapse inward puts stress on your knees and can lead to injury.'
          },
          {
            'mistake': 'Not going low enough',
            'description':
                'Failing to go deep enough limits range of motion and muscle activation.'
          },
          {
            'mistake': 'Heels lifting off the ground',
            'description':
                'Your heels should remain flat on the floor to maintain balance and avoid injury.'
          },
        ];
      case 'Overhead Press':
        return [
          {
            'mistake': 'Arching the back',
            'description':
                'Overarching puts excess strain on your lower back, risking injury. Engage your core.'
          },
          {
            'mistake': 'Not locking out elbows',
            'description':
                'Failing to lock out the elbows reduces the full range of motion.'
          },
          {
            'mistake': 'Wrists bent too far back',
            'description':
                'Bending wrists backward increases strain on joints. Keep them straight for proper alignment.'
          },
        ];
      case 'Pull-Up':
        return [
          {
            'mistake': 'Using momentum',
            'description':
                'Swinging or using momentum decreases muscle engagement. Aim for controlled movements.'
          },
          {
            'mistake': 'Incomplete range of motion',
            'description':
                'Failing to lower yourself fully or getting your chin over the bar limits exercise effectiveness.'
          },
          {
            'mistake': 'Flared elbows',
            'description':
                'Flared elbows decrease back muscle engagement. Keep elbows close to the body.'
          },
        ];
      case 'Lat Pulldown':
        return [
          {
            'mistake': 'Pulling the bar behind the neck',
            'description':
                'Pulling behind the neck increases risk of shoulder injuries. Pull to your chest instead.'
          },
          {
            'mistake': 'Using momentum',
            'description':
                'Swinging or jerking the bar reduces muscle engagement and can lead to injury.'
          },
          {
            'mistake': 'Not engaging the lats',
            'description':
                'Failing to squeeze your lats at the bottom reduces the effectiveness of the exercise.'
          },
        ];
      case 'Leg Press':
        return [
          {
            'mistake': 'Pushing with your toes',
            'description':
                'Pushing through your toes instead of your heels can cause knee strain. Focus on driving through your heels.'
          },
          {
            'mistake': 'Knees caving inwards',
            'description':
                'Letting the knees collapse inward puts pressure on the knee joints and increases injury risk.'
          },
          {
            'mistake': 'Lowering too far',
            'description':
                'Lowering too deeply on the leg press can strain your lower back and knees.'
          },
        ];
      case 'Dumbbell Curl':
        return [
          {
            'mistake': 'Swinging the weights',
            'description':
                'Swinging the weights reduces bicep activation. Perform slow and controlled curls for maximum effectiveness.'
          },
          {
            'mistake': 'Partial range of motion',
            'description':
                'Not extending your arms fully reduces the effectiveness of the curl.'
          },
          {
            'mistake': 'Bending wrists',
            'description':
                'Bending your wrists during the curl shifts tension away from the biceps and increases strain on the forearms.'
          },
        ];
      case 'Tricep Dip':
        return [
          {
            'mistake': 'Shoulders rolling forward',
            'description':
                'Letting the shoulders roll forward during dips can lead to shoulder injuries. Keep your chest up and shoulders back.'
          },
          {
            'mistake': 'Not going low enough',
            'description':
                'Failing to lower yourself deep enough minimizes tricep engagement.'
          },
          {
            'mistake': 'Flaring elbows',
            'description':
                'Flared elbows reduce tricep activation. Keep your elbows close to your body for maximum effect.'
          },
        ];
      case 'Lunges':
        return [
          {
            'mistake': 'Knee going past toes',
            'description':
                'Letting your knee move past your toes puts undue pressure on the knee joint.'
          },
          {
            'mistake': 'Not maintaining balance',
            'description':
                'Wobbly lunges decrease effectiveness and increase injury risk. Engage your core to stay stable.'
          },
          {
            'mistake': 'Short strides',
            'description':
                'Taking too short of a stride limits range of motion and reduces the workout’s effectiveness.'
          },
        ];
      case 'Chest Fly':
        return [
          {
            'mistake': 'Arms too straight',
            'description':
                'Keeping the arms too straight puts unnecessary pressure on the shoulder joints.'
          },
          {
            'mistake': 'Excessive range of motion',
            'description':
                'Going too deep overstretches the shoulder and can lead to injury.'
          },
          {
            'mistake': 'Using momentum',
            'description':
                'Swinging the weights uses momentum and reduces chest muscle engagement.'
          },
        ];
      case 'Push-ups':
        return [
          {
            'mistake': 'Sagging hips',
            'description':
                'Letting your hips drop decreases core engagement and can lead to lower back strain.'
          },
          {
            'mistake': 'Flaring elbows',
            'description':
                'Flaring your elbows puts unnecessary strain on your shoulders and decreases tricep activation.'
          },
          {
            'mistake': 'Not going low enough',
            'description':
                'Failing to lower your chest close to the ground limits the range of motion and reduces effectiveness.'
          },
        ];
      case 'Barbell/Dumbbell Rows':
        return [
          {
            'mistake': 'Rounded back',
            'description':
                'A rounded back puts unnecessary strain on your lower back. Keep your spine neutral.'
          },
          {
            'mistake': 'Using momentum',
            'description':
                'Jerking the weight up reduces muscle engagement in the lats and traps.'
          },
          {
            'mistake': 'Not pulling to the hips',
            'description':
                'Pulling to the chest instead of the hips reduces back muscle activation.'
          },
        ];
      case 'Lateral Raises':
        return [
          {
            'mistake': 'Lifting too high',
            'description':
                'Raising your arms above shoulder height increases the risk of shoulder impingement.'
          },
          {
            'mistake': 'Using momentum',
            'description':
                'Swinging the weights decreases the effectiveness of the shoulder muscles.'
          },
          {
            'mistake': 'Bent arms',
            'description':
                'Bending your elbows too much turns the exercise into more of a press than a raise.'
          },
        ];
      case 'Front Raises':
        return [
          {
            'mistake': 'Using too much weight',
            'description':
                'Using too much weight leads to swinging and decreases effectiveness.'
          },
          {
            'mistake': 'Not controlling the descent',
            'description':
                'Lowering the weight too quickly reduces muscle engagement in the shoulders.'
          },
          {
            'mistake': 'Leaning backward',
            'description':
                'Leaning back puts strain on your lower back. Keep a neutral posture.'
          },
        ];
      case 'Tricep Pushdown':
        return [
          {
            'mistake': 'Elbows flaring out',
            'description':
                'Keep your elbows tucked in to maximize tricep activation and reduce strain on the elbows.'
          },
          {
            'mistake': 'Using too much weight',
            'description':
                'Too much weight leads to poor form and reduced tricep activation.'
          },
          {
            'mistake': 'Not locking out elbows',
            'description':
                'Failing to fully extend your arms reduces the range of motion and limits tricep engagement.'
          },
        ];
      case 'Hammer Curls':
        return [
          {
            'mistake': 'Swinging the weights',
            'description':
                'Swinging reduces bicep activation. Use controlled movement for best results.'
          },
          {
            'mistake': 'Not lowering fully',
            'description':
                'Not extending your arms fully reduces the range of motion and effectiveness of the exercise.'
          },
          {
            'mistake': 'Incorrect wrist position',
            'description':
                'Bending wrists reduces bicep engagement and increases strain on the forearms.'
          },
        ];
      case 'Romanian Deadlifts':
        return [
          {
            'mistake': 'Rounding the lower back',
            'description': 'Keep a neutral spine to avoid lower back injury.'
          },
          {
            'mistake': 'Locking out knees',
            'description':
                'Locking out the knees can reduce hamstring activation and increase injury risk.'
          },
          {
            'mistake': 'Not pushing hips back',
            'description':
                'Failing to hinge at the hips limits hamstring and glute activation.'
          },
        ];
      case 'Hamstring Curls':
        return [
          {
            'mistake': 'Not controlling the weight',
            'description':
                'Using momentum to lift reduces hamstring activation.'
          },
          {
            'mistake': 'Arching the lower back',
            'description':
                'Arching the back during seated curls increases injury risk. Keep your back neutral.'
          },
          {
            'mistake': 'Not fully extending legs',
            'description':
                'Failing to extend fully reduces the range of motion and limits hamstring engagement.'
          },
        ];
      case 'Glute Ham Raise':
        return [
          {
            'mistake': 'Not engaging the core',
            'description':
                'Failing to engage the core increases strain on the lower back.'
          },
          {
            'mistake': 'Too much momentum',
            'description':
                'Using momentum reduces hamstring activation. Focus on slow, controlled movements.'
          },
          {
            'mistake': 'Bending at the hips',
            'description':
                'Avoid bending at the hips to maintain focus on the hamstrings and glutes.'
          },
        ];
      case 'Hip Thrusts':
        return [
          {
            'mistake': 'Not going through full range of motion',
            'description':
                'Failing to lift hips fully reduces glute activation.'
          },
          {
            'mistake': 'Hyperextending the back',
            'description':
                'Hyperextending the lower back puts stress on the spine. Focus on engaging the glutes.'
          },
          {
            'mistake': 'Feet too far forward',
            'description':
                'Feet too far forward decreases glute activation and increases hamstring involvement.'
          },
        ];
      case 'Step-ups':
        return [
          {
            'mistake': 'Pushing off with the back leg',
            'description':
                'Using the back leg reduces activation in the leg on the step.'
          },
          {
            'mistake': 'Not stepping high enough',
            'description':
                'A step that’s too low decreases range of motion and reduces effectiveness.'
          },
          {
            'mistake': 'Leaning forward',
            'description':
                'Leaning forward reduces engagement in the quads and glutes.'
          },
        ];
      case 'Bulgarian Split Squats':
        return [
          {
            'mistake': 'Knee going past toes',
            'description':
                'Allowing the knee to pass over the toes increases strain on the knee joint.'
          },
          {
            'mistake': 'Leaning forward',
            'description':
                'Leaning forward reduces quad activation and increases strain on the lower back.'
          },
          {
            'mistake': 'Unstable stance',
            'description':
                'An unstable stance reduces balance and can lead to injury. Engage your core for stability.'
          },
        ];
      case 'Standing Calf Raise':
        return [
          {
            'mistake': 'Bouncing at the bottom',
            'description':
                'Bouncing reduces tension on the calf muscles and increases injury risk.'
          },
          {
            'mistake': 'Not using full range of motion',
            'description':
                'Failing to lower fully or raise up on your toes limits calf activation.'
          },
          {
            'mistake': 'Leaning forward',
            'description':
                'Leaning forward reduces calf muscle engagement and increases strain on the lower back.'
          },
        ];
      case 'Seated Calf Raise':
        return [
          {
            'mistake': 'Not controlling the weight',
            'description':
                'Using momentum to lift reduces calf activation. Perform the movement slowly.'
          },
          {
            'mistake': 'Not using full range of motion',
            'description':
                'Failing to lower and raise fully reduces the effectiveness of the exercise.'
          },
          {
            'mistake': 'Leaning forward',
            'description':
                'Leaning forward reduces calf engagement and increases strain on the lower back.'
          },
        ];
      case 'Planks':
        return [
          {
            'mistake': 'Sagging hips',
            'description':
                'Letting your hips drop decreases core engagement and can lead to lower back pain.'
          },
          {
            'mistake': 'Raising hips too high',
            'description':
                'Raising your hips too high reduces core activation and shifts the focus to your shoulders.'
          },
          {
            'mistake': 'Looking up or down',
            'description':
                'Keeping your neck neutral avoids unnecessary strain on your neck.'
          },
        ];
      case 'Russian Twists':
        return [
          {
            'mistake': 'Not twisting far enough',
            'description': 'Failing to rotate fully limits oblique engagement.'
          },
          {
            'mistake': 'Using momentum',
            'description':
                'Swinging the weight uses momentum instead of working the core muscles.'
          },
          {
            'mistake': 'Not keeping the back straight',
            'description':
                'Rounding the back during twists can lead to back strain. Keep your spine neutral.'
          },
        ];
      case 'Hanging Leg Raise':
        return [
          {
            'mistake': 'Swinging the legs',
            'description':
                'Using momentum to swing the legs reduces core activation.'
          },
          {
            'mistake': 'Not raising legs high enough',
            'description':
                'Failing to raise your legs high enough limits lower abdominal engagement.'
          },
          {
            'mistake': 'Arching the back',
            'description':
                'Keep your back pressed against the backrest to avoid lower back strain.'
          },
        ];
      case 'Cable Crunch':
        return [
          {
            'mistake': 'Pulling with the arms',
            'description':
                'Pulling with your arms instead of engaging the core decreases ab activation.'
          },
          {
            'mistake': 'Not curling the spine',
            'description':
                'Keep your spine curved to maximize abdominal contraction.'
          },
          {
            'mistake': 'Using too much weight',
            'description':
                'Using too much weight can lead to poor form and reduced ab engagement.'
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildMistakeCard(String mistake, String description) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mistake,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
