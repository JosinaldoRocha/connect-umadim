import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInit {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://rnqqtimmqyvncsfrniyb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJucXF0aW1tcXl2bmNzZnJu'
          'aXliIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgyNTE4MDYsImV4cCI6MjA1MzgyNzgwNn0.OnVBeSLum0oYVQy2UwetzX_yxX4mRdGpZFCjQ5eQlkg',
    );
  }
}
