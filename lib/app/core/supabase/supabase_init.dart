import 'package:supabase_flutter/supabase_flutter.dart';

/// URLs do Supabase antigo (projeto pausado) - ignorar ao carregar imagens
const _oldSupabaseHosts = ['rnqqtimmqyvncsfrniyb.supabase.co'];

/// Retorna true se a URL é válida para carregar (não é do projeto antigo)
bool isSupabaseImageUrlValid(String? url) {
  if (url == null || url.isEmpty) return false;
  return !_oldSupabaseHosts.any((host) => url.contains(host));
}

class SupabaseInit {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://uqtsfigeijkapiidlqfe.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVxdHNmaWdlaWprYXBpaWRscW'
          'ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2MzkwODMsImV4cCI6MjA4OTIxNTA4M30.a73RaveBzicSBZAVnFZgDoZClEB7MpDyY53ryfrWNmE',
    );
  }
}
