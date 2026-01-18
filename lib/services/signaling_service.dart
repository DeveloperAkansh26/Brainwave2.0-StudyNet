import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart';

class SignallingService {
  Socket? socket;
  SignallingService._();
  static final instance = SignallingService._();

  String? selfCallerId;

  // ✅ Make init asynchronous so it can be awaited
  Future<void> init({required String websocketUrl, required String selfCallerID}) async {
    selfCallerId = selfCallerID;

    socket = io(websocketUrl, {
      "transports": ['websocket'],
      "query": {"callerId": selfCallerID}
    });

    socket!.onConnect((_) {
      log("✅ Socket connected!");
    });

    socket!.onConnectError((data) {
      log("❌ Connect Error: $data");
    });

    socket!.connect();

    // Optional: wait a short moment to ensure connection attempt is triggered
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Send SDP Offer (Teacher → Student)
  void sendOffer({required String calleeId, required dynamic sdp}) {
    socket?.emit("newCall", {
      "callerId": selfCallerId,
      "calleeId": calleeId,
      "sdpOffer": sdp,
    });
  }

  // Listen for incoming call (Student → Teacher)
  void onIncomingCall(Function(dynamic) callback) {
    socket?.on("newCall", (data) {
      callback(data);
    });
  }

  // Send SDP Answer (Student → Teacher)
  void sendAnswer({required String callerId, required dynamic sdp}) {
    socket?.emit("callAnswered", {
      "callerId": callerId,
      "answer": sdp,
    });
  }

  // Listen for Answer (Teacher → Teacher)
  void onAnswer(Function(dynamic) callback) {
    socket?.on("callAnswered", (data) {
      callback(data);
    });
  }

  // ICE candidates can be added similarly if needed
}
