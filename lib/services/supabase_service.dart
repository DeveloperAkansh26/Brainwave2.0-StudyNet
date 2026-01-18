import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class SupabaseService {
  final supabase = Supabase.instance.client;

  final String deviceId = Random().nextInt(100000).toString();

  Future<void> registerPeer() async {
    await supabase.from('peers').insert({
      'device_id': deviceId,
      'is_helper': false,
    });
  }

  Stream<List<Map<String, dynamic>>> peersStream() {
    return supabase.from('peers').stream(primaryKey: ['id']);
  }

  Future<void> electHelperByDeviceId(String deviceId) async {
  // Safety: reset helper flag for all rows (must include WHERE)
  await supabase
      .from('peers')
      .update({'is_helper': false})
      .neq('device_id', deviceId);

  // Set THIS device as helper
  await supabase
      .from('peers')
      .update({'is_helper': true})
      .eq('device_id', deviceId);
}

}
