import 'package:flutter/material.dart';
import 'CourseDetails.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // ✅ Center the title
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: "Poppins",
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // Profile Picture Placeholder
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 15),

            // Greeting
            const Text(
              "Student!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 20),

            // Tasks Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side (tasks text)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Today",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "2/10 tasks",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side (student sketch / placeholder image)
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      "asset/fonts/images/profile.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // My Badges
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Badges",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                badgeTile("Achiever", "asset/fonts/images/asset1.png"),
                badgeTile("Fast Learner", "asset/fonts/images/asset2.png"),
                badgeTile("Top Scorer", "asset/fonts/images/asset3.png"),
                badgeTile("Team Player", "asset/fonts/images/asset4.png"),
                badgeTile("Innovator", "asset/fonts/images/asset5.png"),
                badgeTile("Problem Solver", "asset/fonts/images/asset6.png"),
              ],
            ),

            const SizedBox(height: 20),

            // My Courses
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Courses",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Courses
            GestureDetector(
              onTap: () => print("AIML Clicked"),
              child: courseTile("Quantum Computing", "5 hours", 0.5),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CourseDetailsPage()),
                );
              },
              child: courseTile("AIML", "5 hours", 0.5),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => print("Cyber Security Clicked"),
              child: courseTile("Cyber Security", "3 hours", 0.75),
            ),
          ],
        ),
      ),
    );
  }

  // Badge widget (✅ bigger size)
  static Widget badgeTile(String title, String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 80, width: 80), // 🔹 bigger badge
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Course widget
  static Widget courseTile(String title, String hours, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course title and hours
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hours,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          // Progress indicator
          SizedBox(
            height: 50, // 🔹 slightly bigger
            width: 50,
            child: CircularProgressIndicator(
              value: progress,
              color: Colors.green,
              backgroundColor: Colors.grey[300],
              strokeWidth: 6,
            ),
          ),
        ],
      ),
    );
  }
}
