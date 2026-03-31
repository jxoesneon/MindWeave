import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service for handling deep links to load shared presets.
///
/// Supports URL scheme: `mindweave://share?c=<carrier>&b=<beat>&n=<noise>`
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  static const _channel = MethodChannel('mindweave/deep_links');

  /// Callback invoked when a shared preset link is received.
  void Function(SharedPresetLink link)? onPresetReceived;

  Future<void> initialize() async {
    // Listen for incoming links while the app is running
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLink') {
        final uri = Uri.tryParse(call.arguments as String? ?? '');
        if (uri != null) {
          _handleUri(uri);
        }
      }
    });

    // Check if app was launched via deep link
    try {
      final initialLink = await _channel.invokeMethod<String>('getInitialLink');
      if (initialLink != null) {
        final uri = Uri.tryParse(initialLink);
        if (uri != null) {
          _handleUri(uri);
        }
      }
    } catch (e) {
      debugPrint('No initial deep link: $e');
    }
  }

  void _handleUri(Uri uri) {
    if (uri.scheme != 'mindweave') return;
    if (uri.host != 'share') return;

    final carrier = double.tryParse(uri.queryParameters['c'] ?? '');
    final beat = double.tryParse(uri.queryParameters['b'] ?? '');
    final noise = uri.queryParameters['n'];

    if (carrier != null && beat != null) {
      final link = SharedPresetLink(
        carrierFrequency: carrier,
        beatFrequency: beat,
        noiseType: noise,
      );
      debugPrint('Deep link received: $link');
      onPresetReceived?.call(link);
    }
  }

  /// Parse a deep link URI without the full service flow (for testing).
  static SharedPresetLink? parseUri(String uriString) {
    final uri = Uri.tryParse(uriString);
    if (uri == null || uri.scheme != 'mindweave' || uri.host != 'share') {
      return null;
    }

    final carrier = double.tryParse(uri.queryParameters['c'] ?? '');
    final beat = double.tryParse(uri.queryParameters['b'] ?? '');
    final noise = uri.queryParameters['n'];

    if (carrier == null || beat == null) return null;

    return SharedPresetLink(
      carrierFrequency: carrier,
      beatFrequency: beat,
      noiseType: noise,
    );
  }
}

/// Parsed deep link data for a shared preset.
class SharedPresetLink {
  final double carrierFrequency;
  final double beatFrequency;
  final String? noiseType;

  const SharedPresetLink({
    required this.carrierFrequency,
    required this.beatFrequency,
    this.noiseType,
  });

  @override
  String toString() =>
      'SharedPresetLink(carrier: $carrierFrequency, beat: $beatFrequency, noise: $noiseType)';
}
