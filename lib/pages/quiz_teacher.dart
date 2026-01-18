import 'package:flutter/material.dart';

class QuizPageTeacher extends StatefulWidget {
  const QuizPageTeacher({super.key});

  @override
  State<QuizPageTeacher> createState() => _QuizPageTeacherState();
}

class _QuizPageTeacherState extends State<QuizPageTeacher> {
  String? _selectedLecture;

  // Mock lecture list
  final List<String> _lectures = ["Lecture 1", "Lecture 2", "Lecture 3"];

  // Mock quiz questions
  final List<Map<String, dynamic>> _quizQuestions = [
    {
      "question": "What is Machine Learning?",
      "options": [
        "A programming language",
        "A type of computer virus",
        "A subset of AI that learns from data",
        "A hardware component"
      ],
      "answer": "A subset of AI that learns from data"
    },
    {
      "question": "Which of the following is a supervised learning algorithm?",
      "options": ["K-Means", "Linear Regression", "PCA", "DBSCAN"],
      "answer": "Linear Regression"
    },
    {
      "question": "What is Overfitting?",
      "options": [
        "When the model performs poorly on training data",
        "When the model performs well on both training and test data",
        "When the model performs well on training data but poorly on test data",
        "When the model performs poorly on all data"
      ],
      "answer": "When the model performs well on training data but poorly on test data"
    },
    {
      "question": "Which of these is an activation function?",
      "options": ["Sigmoid", "ReLU", "Tanh", "All of the above"],
      "answer": "All of the above"
    }
  ];

  bool _showQuiz = false;

  void _uploadQuiz() {
    if (_selectedLecture != null) {
      // Here you can add your logic to upload quiz to backend/database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Quiz for $_selectedLecture uploaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a lecture first."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Quiz"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to choose lecture
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Choose the Lecture",
                border: OutlineInputBorder(),
              ),
              value: _selectedLecture,
              items: _lectures.map((lecture) {
                return DropdownMenuItem<String>(
                  value: lecture,
                  child: Text(lecture),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLecture = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Generate quiz button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedLecture != null) {
                    setState(() {
                      _showQuiz = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Generate Quiz",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Show quiz questions if generated
            if (_showQuiz)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _quizQuestions.length,
                        itemBuilder: (context, index) {
                          final q = _quizQuestions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Q${index + 1}. ${q['question']}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  ...List.generate(
                                    (q["options"] as List).length,
                                    (i) => Text("• ${q["options"][i]}"),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "✅ Correct Answer: ${q['answer']}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Upload Quiz button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _uploadQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Upload Quiz",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
