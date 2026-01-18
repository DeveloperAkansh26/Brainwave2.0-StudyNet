import 'package:flutter/material.dart';
import 'call_screen.dart';
import '../services/signaling_service.dart';

class JoinScreen extends StatefulWidget {
  final String selfCallerId;

  const JoinScreen({super.key, required this.selfCallerId});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final remoteCallerIdController = TextEditingController();
  dynamic incomingSDPOffer;

  @override
  void initState() {
    super.initState();

    // Listen for incoming video call (from teacher)
    SignallingService.instance.socket!.on("newCall", (data) {
      if (mounted) {
        setState(() => incomingSDPOffer = data);
      }
    });

    // Listen for teacher sending answer back (optional if needed)
    SignallingService.instance.socket!.on("callAccepted", (data) {
      // Could be used to update call status
    });
  }

  void _joinCall({
    required String teacherId,
    required String studentId,
    dynamic offer,
  }) {
    // Navigate to CallScreen with student view mode
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          callerId: studentId,
          calleeId: teacherId,
          offer: offer, // SDP offer from teacher
          isViewOnly: true, // Student sees only teacher
        ),
      ),
    );
  }

  void _inviteTeacher() {
    final teacherId = remoteCallerIdController.text.trim();
    if (teacherId.isEmpty) return;

    // Emit event to teacher for calling
    SignallingService.instance.socket!.emit("callUser", {
      "from": widget.selfCallerId, // student ID
      "to": teacherId,              // teacher ID
    });

    // Listen for teacher SDP offer
    SignallingService.instance.socket!.once("sdpOffer", (data) {
      _joinCall(
        teacherId: teacherId,
        studentId: widget.selfCallerId,
        offer: data,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 116, 76, 180),
        title: const Text("Join Live Class"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Self Caller ID
                    TextField(
                      controller: TextEditingController(
                        text: widget.selfCallerId,
                      ),
                      readOnly: true,
                      textAlign: TextAlign.center,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                        labelText: "Your Caller ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Teacher ID
                    TextField(
                      controller: remoteCallerIdController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Teacher ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Invite Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 165, 89, 178),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Invite Teacher",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: _inviteTeacher,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Incoming call overlay (if teacher calls student)
            if (incomingSDPOffer != null)
              Positioned(
                top: 24,
                left: 16,
                right: 16,
                child: Card(
                  color: Colors.purple.shade50,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Incoming Call from ${incomingSDPOffer["callerId"]}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Reject
                            IconButton(
                              icon: const Icon(Icons.call_end),
                              color: Colors.redAccent,
                              onPressed: () {
                                setState(() => incomingSDPOffer = null);
                              },
                            ),
                            // Accept
                            IconButton(
                              icon: const Icon(Icons.call),
                              color: Colors.green,
                              onPressed: () {
                                _joinCall(
                                  teacherId: incomingSDPOffer["callerId"],
                                  studentId: widget.selfCallerId,
                                  offer: incomingSDPOffer["sdpOffer"],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
