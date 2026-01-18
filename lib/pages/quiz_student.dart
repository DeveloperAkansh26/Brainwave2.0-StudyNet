import 'package:flutter/material.dart';

class QuizPageStudent extends StatefulWidget {
  const QuizPageStudent({super.key});

  @override
  State<QuizPageStudent> createState() => _QuizPageStudentState();
}

class _QuizPageStudentState extends State<QuizPageStudent> {
  // Same questions as teacher
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

  final Map<int, String> _selectedAnswers = {};

  void _submitQuiz() {
    int correct = 0;
    for (int i = 0; i < _quizQuestions.length; i++) {
      if (_selectedAnswers[i] == _quizQuestions[i]["answer"]) {
        correct++;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Result"),
        content: Text("You answered $correct out of ${_quizQuestions.length} correctly!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attempt Quiz for Lecture 1"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(
                            (q["options"] as List).length,
                            (i) => RadioListTile<String>(
                              value: q["options"][i],
                              groupValue: _selectedAnswers[index],
                              onChanged: (value) {
                                setState(() {
                                  _selectedAnswers[index] = value!;
                                });
                              },
                              title: Text(q["options"][i]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit Quiz",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
