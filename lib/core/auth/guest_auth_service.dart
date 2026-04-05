import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_client_provider.dart';

/// Guest/Anonymous auth service
final guestAuthServiceProvider = Provider<GuestAuthService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GuestAuthService(supabase: supabase);
});

/// Stream of current auth state (null = not authenticated, User = guest or permanent)
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.currentUser;
});

/// Handles anonymous/guest authentication
class GuestAuthService {
  final SupabaseClient _supabase;

  GuestAuthService({required SupabaseClient supabase}) : _supabase = supabase;

  /// Ensure user is authenticated (sign in anonymously if needed)
  Future<User?> ensureAuthenticated() async {
    // Check if already authenticated
    var user = _supabase.auth.currentUser;
    if (user != null) return user;

    // Check if we have a stored session
    try {
      final session = _supabase.auth.currentSession;
      if (session != null) {
        return session.user;
      }
    } catch (e) {
      debugPrint('Session check failed: $e');
    }

    // Sign in anonymously
    try {
      final response = await _supabase.auth.signInAnonymously();
      user = response.user;
      debugPrint('Anonymous sign-in successful: ${user?.id}');
      return user;
    } catch (e) {
      debugPrint('Anonymous sign-in failed: $e');
      return null;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Get current user ID (null if not authenticated)
  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Check if current user is anonymous
  bool get isAnonymous {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    // Anonymous users have is_anonymous claim in their app metadata
    return user.appMetadata['is_anonymous'] == true;
  }

  /// Check if user can upgrade to permanent account
  bool get canUpgrade => isAnonymous;

  /// Link email to anonymous account (upgrade to permanent)
  Future<void> linkEmail(String email) async {
    if (!isAnonymous) {
      throw Exception('User is not anonymous');
    }
    await _supabase.auth.updateUser(UserAttributes(email: email));
  }
}
