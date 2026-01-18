import 'package:flutter/material.dart';
import 'forum.dart';
import 'upload_lectures.dart';
import 'quiz_teacher.dart';
import 'call_screen.dart';
import 'dart:math';
import '../services/signaling_service.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // allow background image under appbar
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              print("Notification Clicked");
            },
          ),
        ],
      ),
      drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.deepPurple),
        child: Text(
          "Menu",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.upload_file),
        title: const Text("Upload Lesson"),
        onTap: () {
          Navigator.pop(context);
          // your existing upload logic
        },
      ),
     ListTile(
  leading: const Icon(Icons.live_tv),
  title: const Text("Live Class"),
  onTap: () async {
    // Generate teacher ID
    final String teacherId = Random().nextInt(999999).toString().padLeft(6, '0');
    print("Teacher ID: $teacherId"); // ✅ This will now reliably print

    Navigator.pop(context);

    // Initialize signalling (await works now)
    await SignallingService.instance.init(
      websocketUrl: "YOUR_WS_SERVER_URL",
      selfCallerID: teacherId,
    );

    final String studentId = "student123";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          callerId: teacherId,
          calleeId: studentId,
          offer: null,
        ),
      ),
    );
  },
),




      ListTile(
        leading: const Icon(Icons.quiz),
        title: const Text("Quiz"),
        onTap: () {
          Navigator.pop(context);
          // your existing quiz logic
        },
      ),
    ],
  ),
),

      body: Stack(
        children: [
          // 🔹 Background image
          Positioned.fill(
            child: Image.asset(
              "asset/fonts/images/home_page.png", // replace with your asset path
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 Page content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80), // space for transparent appbar

                // Heading
                const Text(
                  "Connect with learners across India",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 20),

                // Welcome Back Box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 222, 215, 244), // 🔹 removed opacity
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Text part (left)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 26, // 🔹 bigger font
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Your students completed ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 74, 74, 74),
                                      fontSize: 12,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  TextSpan(
                                    text: "80%",
                                    style: TextStyle(
                                      color: Colors.deepPurple[900],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " of the tasks",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 74, 74, 74),
                                      fontSize: 12,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Progress is ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 74, 74, 74),
                                      fontSize: 12,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  TextSpan(
                                    text: "very good!",
                                    style: TextStyle(
                                      color: Colors.deepPurple[900],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Image on right side
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          "asset/fonts/images/teacher_page.png", // replace with your teacher/student image
                          height: 160,
                          width: 160,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Upcoming Lessons Box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading + Calendar Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Upcoming Lessons",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Poppins",
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Timeline Items
                      Column(
                        children: [
                          _timelineItem("9:00 AM"),
                          _timelineItemWithBox("10:00 AM", "AI/ML Lecture"),
                          _timelineItem("11:00 AM"),
                          _timelineItem("12:00 PM"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20), // 🔹 reduced spacing

               // 🔹 Upload Section with 4 Buttons
const Text(
  "Quick Actions",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins",
    color: Colors.black,
  ),
),

// reduce gap here
const SizedBox(height: 10), 

GridView.count(
  crossAxisCount: 2,
  shrinkWrap: true,
  crossAxisSpacing: 12, // 🔹 less spacing
  mainAxisSpacing: 8,   // 🔹 reduced vertical spacing
  physics: const NeverScrollableScrollPhysics(),
  padding: EdgeInsets.zero, // 🔹 remove extra padding
  children: [
    _uploadButton("Upload Lecture", Icons.upload_file),
    _uploadButton("Upload Quiz", Icons.quiz),
    _uploadButton("Upload Assignment", Icons.assignment),
    _uploadButton("View Forum", Icons.forum),
  ],
),

              ],
            ),
          ),
        ],
      ),
    );
  }

  // Timeline normal item
  static Widget _timelineItem(String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: "Poppins",
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  // Timeline item with blue box + red dot
  static Widget _timelineItemWithBox(String time, String lecture) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: "Poppins",
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 28, 182, 49),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.red, // 🔹 red dot
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        lecture,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// 🔹 Upload Buttons
static Widget _uploadButton(String label, IconData icon) {
  return Builder(
    builder: (ctx) {
      return ElevatedButton(
        onPressed: () {
          if (label == "View Forum") {
            Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (context) => const ForumPage(role: "teacher"),
              ),
            );
          } else if (label == "Upload Lecture") {
            Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (context) => const UploadLecturePage(),
              ),
            );
          } else if (label == "Upload Quiz") {
            Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (context) => const QuizPageTeacher(), // ✅ correct page
              ),
            );
          } else {
            print("$label Clicked");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          elevation: 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    },
  );
}



}