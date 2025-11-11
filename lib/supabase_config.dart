import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: const String.fromEnvironment('db.xdenlzphtecnjuqrmgvz.supabase.co'),
      anonKey: const String.fromEnvironment('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhkZW5senBodGVjbmp1cXJtZ3Z6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4OTg5MzgsImV4cCI6MjA3ODQ3NDkzOH0.q7pMBAI7tji5zarydMPHCzOClJccHbO1WG6G7nwk6Dk'),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}