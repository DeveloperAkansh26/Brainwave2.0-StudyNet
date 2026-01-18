import 'package:flutter/material.dart';
import 'profile_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  int _selectedIndex = 0;

  final List<String> subjects = ["Mathematics", "AI/ML", "Web Development"];
   final Map<String, String> subjectImages = {
    "Mathematics": "asset/fonts/images/mathematics.jpg",
    "AI/ML": "asset/fonts/images/ai_ml.jpg",
    "Web Development": "asset/fonts/images/web_development.jpg",
  };
  void _onNavTapped(int index) {
  if (index == 1) {
    // Navigate to ProfilePage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  } else {
    setState(() {
      _selectedIndex = index;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              print("Notifications clicked");
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
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
            ListTile(leading: Icon(Icons.note), title: Text("Notes")),
            ListTile(leading: Icon(Icons.class_), title: Text("Classes")),
            ListTile(leading: Icon(Icons.check_circle), title: Text("Attendance")),
            ListTile(leading: Icon(Icons.quiz), title: Text("Quiz")),
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/fonts/images/home_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 120),

            const Center(
              child: Text(
                "Find your favourite course",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search courses...",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black.withOpacity(0.4),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            // ✅ Live Class Section
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      "Live Class",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black,
      ),
    ),
    const SizedBox(height: 10),

    // Live Class Box
    GestureDetector(
      onTap: () {
        print("Live Class Clicked");
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage("asset/fonts/images/joinClass.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // 🔴 Red "LIVE" Icon
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "LIVE",
                  style: TextStyle(
                    color: Colors.white,
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

            const SizedBox(height: 30),

            // Popular Courses
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: const [
    Text(
      "Popular Courses",
      style: TextStyle(
        fontSize: 22,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ),
  ],
),
const SizedBox(height: 20),

// ✅ Replace old ListView.builder with this one
// ✅ Popular Courses
SizedBox(
  height: 200,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: subjects.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          print("${subjects[index]} Clicked");
        },
        child: Container(
          width: 150,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image box
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(subjectImages[subjects[index]]!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Text under image
              Text(
                subjects[index],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),



            const SizedBox(height: 30),

            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("See all clicked");
                  },
                  child: const Text("See all", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                // Left Vertical Box
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      print("Design Clicked");
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 205, 255),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: const [
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Text("UI/UX", style: TextStyle(color: Colors.grey)),
                          ),
                          Center(
                            child: Text(
                              "Design",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Right Two Horizontal Boxes
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Category 1 Clicked");
                        },
                        child: Container(
                          height: 90,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 208, 178),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: const [
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Text("UI/UX", style: TextStyle(color: Colors.grey)),
                              ),
                              Center(
                                child: Text(
                                  "Category 1",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Category 2 Clicked");
                        },
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 211, 255, 184),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: const [
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Text("UI/UX", style: TextStyle(color: Colors.grey)),
                              ),
                              Center(
                                child: Text(
                                  "Category 2",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
