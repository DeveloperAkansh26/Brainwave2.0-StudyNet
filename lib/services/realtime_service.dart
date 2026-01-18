import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeService {
  final supabase = Supabase.instance.client;

  /// Push my stats to Supabase
  Future<void> sendStats(String ssid, String ip, int bandwidth) async {
  try {
    final res = await supabase.from('network_stata').insert({
      'ssid': ssid,
      'ip': ip,
      'bandwidth': bandwidth,
      'is_helper': false,
    });
    print('Insert result: $res');
  } catch (e) {
    print('Error inserting stats: $e');
  }
}

  /// Listen to realtime updates of peers
  Stream<List<Map<String, dynamic>>> listenToPeers() {
    return supabase
        .from('network_stata')
        .stream(primaryKey: ['id']); // ✅ must match your table PK
  }
}

/// Elect helper outside the class
Future<Map<String, dynamic>?> electHelper(List<Map<String, dynamic>> peers) async {
  if (peers.isEmpty) return null;

  // Sort peers by bandwidth (highest first)
  peers.sort((a, b) => (b['bandwidth'] as int).compareTo(a['bandwidth'] as int));

  // Pick the best
  final helper = peers.first;

  // Mark in Supabase that this peer is the helper
  await Supabase.instance.client
      .from('network_stata') // ✅ fixed table name
      .update({'is_helper': true})
      .eq('id', helper['id']);

  return helper;
}
