import 'dart:developer' as developer;
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_environment.dart';

/// Provider for GoogleSignInService
final googleSignInServiceProvider = Provider<GoogleSignInService>((ref) {
  return GoogleSignInService();
});

/// Service for handling Google Sign-In authentication with Supabase
class GoogleSignInService {
  final _log = developer.log;
  final AppEnvironment _env;

  late final GoogleSignIn _googleSignIn;

  GoogleSignInService({AppEnvironment? env}) : _env = env ?? AppEnvironment() {
    // Full logging for debugging
    _log('[GSI INIT] Platform: $defaultTargetPlatform');
    _log('[GSI INIT] isIOS: ${defaultTargetPlatform == TargetPlatform.iOS}');
    _log(
      '[GSI INIT] isMacOS: ${defaultTargetPlatform == TargetPlatform.macOS}',
    );
    _log('[GSI INIT] Platform.isMacOS (dart:io): ${io.Platform.isMacOS}');

    // Read from env for comparison
    final envClientId = _env.googleIosClientId;
    _log('[GSI INIT] Env clientId: $envClientId');

    // Configure GoogleSignIn with platform-specific client IDs
    // HARDCODED: macOS/iOS client ID for Google Sign-In
    const hardcodedClientId =
        '900217975842-ef0cr4mmaf4omtrr1jo6f49mu12re1tt.apps.googleusercontent.com';
    _log('[GSI INIT] Hardcoded clientId: $hardcodedClientId');

    final isApplePlatform =
        (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS);
    _log('[GSI INIT] isApplePlatform: $isApplePlatform');

    final clientId = isApplePlatform ? hardcodedClientId : null;
    _log('[GSI INIT] Selected clientId: $clientId');

    final finalClientId = clientId?.isNotEmpty == true ? clientId : null;
    _log('[GSI INIT] Final clientId passed to GoogleSignIn: $finalClientId');

    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'openid', 'profile'],
      clientId: finalClientId,
    );

    _log('[GSI INIT] GoogleSignIn instance created');
  }

  /// Sign in with Google and authenticate with Supabase
  Future<AuthResponse> signInWithGoogle() async {
    try {
      _log('Starting Google Sign-In flow');

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled by user');
      }

      // Log all available Google profile data
      _log('Google Sign-In successful');
      _log('  Email: ${googleUser.email}');
      _log('  Display Name: ${googleUser.displayName}');
      _log('  Photo URL: ${googleUser.photoUrl}');
      _log('  User ID: ${googleUser.id}');
      _log(
        '  Server Auth Code: ${googleUser.serverAuthCode != null ? 'present' : 'none'}',
      );

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('Failed to get ID token from Google');
      }

      _log('Got Google ID token and access token');
      _log(
        '  Access Token: ${googleAuth.accessToken != null ? 'present' : 'none'}',
      );
      _log('  ID Token length: ${googleAuth.idToken!.length}');

      // Sign in to Supabase with Google credential
      // Supabase automatically extracts: email, name, picture, email_verified
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.user != null) {
        _log('Supabase auth successful');
        _log('  Supabase User ID: ${response.user!.id}');
        _log('  Email: ${response.user!.email}');
        _log('  Created At: ${response.user!.createdAt}');
        _log('  User Metadata: ${response.user!.userMetadata}');

        // Update user metadata with additional Google profile data if needed
        await _updateUserProfileIfNeeded(response.user!, googleUser);
      }

      return response;
    } on Exception catch (e) {
      _log('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Update user profile in Supabase with additional Google data if not already set
  Future<void> _updateUserProfileIfNeeded(
    User user,
    GoogleSignInAccount googleUser,
  ) async {
    try {
      final currentMetadata = user.userMetadata ?? {};

      // Check if we need to update profile data
      final needsUpdate =
          currentMetadata['full_name'] == null ||
          currentMetadata['avatar_url'] == null;

      if (needsUpdate) {
        final updates = <String, dynamic>{};

        if (currentMetadata['full_name'] == null &&
            googleUser.displayName != null) {
          updates['full_name'] = googleUser.displayName;
        }

        if (currentMetadata['avatar_url'] == null &&
            googleUser.photoUrl != null) {
          updates['avatar_url'] = googleUser.photoUrl;
        }

        if (updates.isNotEmpty) {
          await Supabase.instance.client.auth.updateUser(
            UserAttributes(data: updates),
          );
          _log('Updated user profile metadata: $updates');
        }
      }
    } catch (e) {
      _log('Failed to update user profile: $e');
      // Non-fatal, don't throw
    }
  }

  /// Sign out from Google and Supabase
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await Supabase.instance.client.auth.signOut();
      _log('Signed out from Google and Supabase');
    } on Exception catch (e) {
      _log('Sign out error: $e');
      rethrow;
    }
  }

  /// Check if user is currently signed in to Google
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current signed in user
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
