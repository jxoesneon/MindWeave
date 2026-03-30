import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final client = SupabaseClient('http://localhost', 'key');
  final builder = client.from('test');
  // Just checking if these methods exist
  builder.select();
  builder.insert({});
  builder.update({});
  builder.upsert({});
  builder.delete();
}
