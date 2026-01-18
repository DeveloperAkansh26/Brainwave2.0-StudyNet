import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>?> electHelper(List<Map<String, dynamic>> peers) async {
  if (peers.isEmpty) return null;

  peers.sort((a, b) => (b['bandwidth'] as int).compareTo(a['bandwidth'] as int));
  final helper = peers.first;

  // Reset all helpers first
  await Supabase.instance.client
      .from('network_stats')
      .update({'is_helper': false});

  // Mark the chosen helper
  await Supabase.instance.client
      .from('network_stats')
      .update({'is_helper': true})
      .eq('id', helper['id']);

  return helper;
}
