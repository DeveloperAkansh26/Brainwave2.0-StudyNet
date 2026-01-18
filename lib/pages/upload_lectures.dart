import 'package:flutter/material.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadLecturePage extends StatefulWidget {
  const UploadLecturePage({super.key});

  @override
  State<UploadLecturePage> createState() => _UploadLecturePageState();
}

class _UploadLecturePageState extends State<UploadLecturePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _lectureNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _videoFile; // ⚠️ Placeholder, since we removed file_picker

  // Mock previous lectures
  List<Map<String, String>> _uploadedLectures = [
    {"course": "AI/ML", "lecture": "AI/ML Lecture 1"},
    {"course": "AI/ML", "lecture": "AI/ML Lecture 2"},
    {"course": "AI/ML", "lecture": "AI/ML Lecture 3"},
  ];

  // Dummy function since file_picker is removed
  Future<void> _pickVideo() async {
    // For now, we’ll just simulate selecting a file
    // Replace this later with file_picker or image_picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Video picker disabled temporarily.")),
    );
  }

  // Upload lecture
  Future<void> _uploadLecture() async {
    if (_formKey.currentState!.validate() && _videoFile != null) {
      final course = _courseNameController.text.trim();
      final lecture = _lectureNameController.text.trim();
      final description = _descriptionController.text.trim();
      final fileName = _videoFile!.path.split('/').last;

      try {
        // Upload video to Supabase Storage
        await Supabase.instance.client.storage
            .from('course-videos')
            .uploadBinary('$course/$fileName', _videoFile!.readAsBytesSync());

        // Save metadata in database
        await Supabase.instance.client.from('videos').insert({
          'course': course,
          'lecture': lecture,
          'description': description,
          'video_path': '$course/$fileName',
          'uploaded_at': DateTime.now().toIso8601String(),
        });

        setState(() {
          _uploadedLectures.add({
            "course": course,
            "lecture": lecture,
          });
          _courseNameController.clear();
          _lectureNameController.clear();
          _descriptionController.clear();
          _videoFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lecture uploaded successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields (video disabled for now)")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Lectures",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Course Name
                    TextFormField(
                      controller: _courseNameController,
                      decoration: const InputDecoration(
                        labelText: "Course Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter course name" : null,
                    ),
                    const SizedBox(height: 16),

                    // Lecture Name
                    TextFormField(
                      controller: _lectureNameController,
                      decoration: const InputDecoration(
                        labelText: "Lecture Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter lecture name" : null,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Lecture Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Upload Video Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 191, 126, 197),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          _videoFile == null
                              ? "Upload Video File"
                              : _videoFile!.path.split('/').last,
                          style: const TextStyle(fontSize: 16),
                        ),
                        onPressed: _pickVideo,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit Upload Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "Upload Lecture",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: _uploadLecture,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                "Previously Uploaded Lectures",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Uploaded Lectures List
              if (_uploadedLectures.isEmpty)
                const Text("No lectures uploaded yet.")
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _uploadedLectures.length,
                  itemBuilder: (context, index) {
                    final lecture = _uploadedLectures[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.video_library, color: Colors.purple),
                        title: Text(lecture["lecture"]!),
                        subtitle: Text(lecture["course"]!),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _uploadedLectures.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
