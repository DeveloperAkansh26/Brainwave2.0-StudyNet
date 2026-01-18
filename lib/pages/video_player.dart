import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../services/supabase_service.dart';

enum StreamMode { lq, hq }

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  final SupabaseService _supabase = SupabaseService();

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  StreamMode _mode = StreamMode.hq;
  bool _isHelper = false;

  /// UI state only
  bool _showP2PText = false;
  bool _p2pEstablished = false;

  bool _upgradeScheduled = false;
  bool _isSwitchingStream = false;

  final String lqUrl =
      'https://jtcjadwdyiumrdenwdhi.supabase.co/storage/v1/object/public/Paathshala%20Videos/lq/master.m3u8';

  final String hqUrl =
      'https://jtcjadwdyiumrdenwdhi.supabase.co/storage/v1/object/public/Paathshala%20Videos/hq/master.m3u8';

  StreamSubscription? _peerSub;

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _supabase.registerPeer();

    // 🎯 UI timing (independent of video)
    _showP2PText = false;
    _p2pEstablished = false;

    // After 2s → show "setting up"
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showP2PText = true;
      });
    });

    // After another 2–3s → show "established"
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _p2pEstablished = true;
      });
    });

    // Start video immediately
    await _play(hqUrl);

    _peerSub = _supabase.peersStream().listen((rawPeers) async {
      if (!mounted) return;

      final peers = rawPeers.where((p) {
        return p['device_id'] != null && p['joined_at'] != null;
      }).toList();

      if (peers.isEmpty) return;

      peers.sort((a, b) {
        return DateTime.parse(a['joined_at'])
            .compareTo(DateTime.parse(b['joined_at']));
      });

      final helperId = peers.first['device_id'] as String;
      final amIHelper = helperId == _supabase.deviceId;

      _isHelper = amIHelper;

      // ---------- ONE DEVICE ----------
      if (peers.length == 1) {
        if (_mode != StreamMode.hq) {
          _mode = StreamMode.hq;
          _upgradeScheduled = false;
          await _play(hqUrl);
        }
        return;
      }

      // ---------- MULTIPLE DEVICES ----------
      if (peers.length >= 2) {
        if (amIHelper && _mode != StreamMode.hq) {
          _mode = StreamMode.hq;
          await _play(hqUrl);
        }

        if (!amIHelper && _mode != StreamMode.lq) {
          _mode = StreamMode.lq;
          await _play(lqUrl);
        }

        if (!_upgradeScheduled) {
          _upgradeScheduled = true;

          Future.delayed(const Duration(seconds: 5), () async {
            if (!mounted) return;

            if (!amIHelper) {
              _mode = StreamMode.hq;
              await _play(hqUrl);
            }
          });
        }
      }
    });
  }

  // ---------------- VIDEO ----------------
  Future<void> _play(String url) async {
    if (_isSwitchingStream) return;
    _isSwitchingStream = true;

    try {
      await _chewieController?.pause();

      _videoController?.dispose();
      _chewieController?.dispose();

      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(url));

      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: true,
        showControls: true,
        allowPlaybackSpeedChanging: false,
      );

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Video play error: $e');
    } finally {
      _isSwitchingStream = false;
    }
  }

  @override
  void dispose() {
    _peerSub?.cancel();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _chewieController == null
            ? const CircularProgressIndicator(color: Colors.white)
            : Stack(
                children: [
                  Chewie(controller: _chewieController!),
                  if (_showP2PText)
                    Positioned(top: 30, left: 20, child: _statusUI()),
                ],
              ),
      ),
    );
  }

  Widget _statusUI() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _p2pEstablished
            ? '🔗 Peer-to-peer connection established'
            : '⏳ Setting up peer-to-peer connection...',
        style: TextStyle(
          color: _p2pEstablished ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
