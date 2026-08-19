import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mymanager/core/config/supabase_config.dart';

/// Provider for accessing Supabase client across the app.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  if (SupabaseConfig.isConfigured) {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
  return null;
});

/// Current authenticated user session provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return Stream.value(null);
  return client.auth.onAuthStateChange.map((event) => event.session?.user);
});
