import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallScreen extends StatefulWidget {
  final String callerId;
  final String calleeId;
  final dynamic offer; // SDP offer from signaling server
  final bool isViewOnly; // true for student, false for teacher

  const CallScreen({
    super.key,
    required this.callerId,
    required this.calleeId,
    this.offer,
    this.isViewOnly = false,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;

  bool isAudioOn = true;
  bool isVideoOn = true;
  bool isFrontCamera = true;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _startCall();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _startCall() async {
    try {
      if (!widget.isViewOnly) {
        // Teacher: get camera+mic
        await _initLocalStream();
      }
      await _setupPeerConnection();
      debugPrint("✅ Call initialized");
    } catch (e) {
      debugPrint("❌ Error initializing call: $e");
    }
  }

  Future<void> _initLocalStream() async {
    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': isAudioOn,
        'video': isVideoOn
            ? {
                'facingMode': isFrontCamera ? 'user' : 'environment',
                'width': 1280,
                'height': 720,
                'frameRate': 30,
              }
            : false,
      });
      _localRenderer.srcObject = _localStream;
      setState(() {});
    } catch (e) {
      debugPrint("❌ Error getting user media: $e");
    }
  }

  Future<void> _setupPeerConnection() async {
    final config = {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"},
      ]
    };

    _peerConnection = await createPeerConnection(config);

    // Add local tracks if teacher
    if (_localStream != null && !widget.isViewOnly) {
      for (var track in _localStream!.getTracks()) {
        await _peerConnection?.addTrack(track, _localStream!);
      }
    }

    // Remote track
    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };

    // Handle offer (student joins teacher)
    if (widget.offer != null) {
      await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(widget.offer['sdp'], widget.offer['type']),
      );

      // Create answer
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      debugPrint("✅ Answer created: ${answer.sdp}");

      // TODO: Send answer back via SignallingService
      // SignallingService.instance.sendAnswer(
      //   callerId: widget.calleeId,
      //   sdp: {"sdp": answer.sdp, "type": answer.type},
      // );
    } else if (!widget.isViewOnly) {
      // Teacher: create offer
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      debugPrint("✅ Offer created: ${offer.sdp}");

      // TODO: Send offer to student via SignallingService
      // SignallingService.instance.sendOffer(
      //   calleeId: widget.calleeId,
      //   sdp: {"sdp": offer.sdp, "type": offer.type},
      // );
    }
  }

  void _toggleMic() {
    if (_localStream != null) {
      isAudioOn = !isAudioOn;
      for (var track in _localStream!.getAudioTracks()) {
        track.enabled = isAudioOn;
      }
      setState(() {});
    }
  }

  void _toggleCamera() {
    if (_localStream != null) {
      isVideoOn = !isVideoOn;
      for (var track in _localStream!.getVideoTracks()) {
        track.enabled = isVideoOn;
      }
      setState(() {});
    }
  }

  void _switchCamera() {
    if (_localStream != null) {
      isFrontCamera = !isFrontCamera;
      for (var track in _localStream!.getVideoTracks()) {
        // ignore: deprecated_member_use
        track.switchCamera();
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    _peerConnection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),

            // Local video preview only for teacher
            if (!widget.isViewOnly)
              Positioned(
                top: 20,
                right: 20,
                width: 120,
                height: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RTCVideoView(
                    _localRenderer,
                    mirror: true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),
              ),

            // Controls only for teacher
            if (!widget.isViewOnly)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: isAudioOn ? Icons.mic : Icons.mic_off,
                        color: Colors.purple,
                        onPressed: _toggleMic,
                      ),
                      _buildControlButton(
                        icon: Icons.call_end,
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                      _buildControlButton(
                        icon: Icons.cameraswitch,
                        color: Colors.purple,
                        onPressed: _switchCamera,
                      ),
                      _buildControlButton(
                        icon: isVideoOn ? Icons.videocam : Icons.videocam_off,
                        color: Colors.purple,
                        onPressed: _toggleCamera,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: color.withOpacity(0.15),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
