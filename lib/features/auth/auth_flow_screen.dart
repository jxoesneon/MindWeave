import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/google_sign_in_service.dart';
import '../../core/security/captcha_anonymous_auth.dart';
import 'celestial_login_screen.dart';
import '../home/player_screen.dart';

/// Authentication flow wrapper
/// Shows login screen first, then handles Google Sign-In and hCaptcha for guest entry
class AuthFlowScreen extends ConsumerStatefulWidget {
  const AuthFlowScreen({super.key});

  @override
  ConsumerState<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends ConsumerState<AuthFlowScreen> {
  bool _isLoading = false;

  Future<void> _handleGuestEntry() async {
    setState(() => _isLoading = true);

    try {
      final authService = CaptchaAnonymousAuth();
      final response = await authService.signInAnonymously(
        context,
        forceCaptcha: true,
      );

      if (response.user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PlayerScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Authentication failed: $e')));
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final googleSignInService = ref.read(googleSignInServiceProvider);
      final response = await googleSignInService.signInWithGoogle();

      if (response.user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PlayerScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CelestialLoginScreen(
            onGuestEntry: _handleGuestEntry,
            onGoogleSignIn: _handleGoogleSignIn,
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
