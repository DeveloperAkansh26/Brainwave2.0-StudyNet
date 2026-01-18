import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  final String role; // "teacher" or "student"

  const ForumPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // 🔹 Doubts List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _doubtCard("What is overfitting in ML?", "Posted by Student123", role),
                _doubtCard("Explain the difference between supervised and unsupervised learning.", "Posted by Student456", role),
                _doubtCard("How does backpropagation work in neural networks?", "Posted by Student789", role),
                _doubtCard("What are CNNs mainly used for?", "Posted by Student101", role),
                _doubtCard("Why do we use activation functions like ReLU?", "Posted by Student202", role),
              ],
            ),
          ),

          // 🔹 Action box at bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 12), // moves it slightly up
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[100],
              child: role == "student"
                  // 🔹 Student can post doubts
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Post your doubt...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            print("✅ Student posted a doubt");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text("Post", style: TextStyle(color: Colors.white)),
                        )
                      ],
                    )
                  // 🔹 Teacher can answer doubts
                  : Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Write an answer or share material...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            print("✅ Teacher answered with material/lecture link");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text(
                            "Answer",
                            style: TextStyle(color: Colors.black), // black text
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable doubt card
  static Widget _doubtCard(String question, String subtitle, String role) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(question),
        subtitle: Text(subtitle),
        trailing: role == "teacher"
            ? IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {
                  print("📌 Teacher links a lecture here");
                },
              )
            : null,
      ),
    );
  }
}
