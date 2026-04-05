import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:logging/logging.dart';

/// Drawer widget for hCaptcha verification using WebView.
///
/// Slides up from the bottom with a glassmorphic design
/// matching MindWeave's aesthetic.
class HCaptchaDrawer extends StatefulWidget {
  final String siteKey;
  final Function(String token) onVerified;
  final VoidCallback? onCancelled;
  final bool isDarkMode;

  const HCaptchaDrawer({
    super.key,
    required this.siteKey,
    required this.onVerified,
    this.onCancelled,
    this.isDarkMode = true,
  });

  /// Show the drawer as a modal bottom sheet
  static Future<String?> show(
    BuildContext context, {
    required String siteKey,
    bool isDarkMode = true,
  }) async {
    final log = Logger('HCaptchaDrawer');

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) => HCaptchaDrawer(
        siteKey: siteKey,
        isDarkMode: isDarkMode,
        onVerified: (token) {
          log.info('✅ CAPTCHA verified successfully');
          Navigator.of(context).pop(token);
        },
        onCancelled: () {
          log.info('❌ CAPTCHA cancelled by user');
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  State<HCaptchaDrawer> createState() => _HCaptchaDrawerState();
}

class _HCaptchaDrawerState extends State<HCaptchaDrawer> {
  final _log = Logger('HCaptchaDrawer');
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initWebView();
    // Set background color after controller is initialized
    // Use a small delay to ensure the controller is ready on macOS
    Future.microtask(() {
      if (mounted) {
        final bgColor = _getBackgroundColor();
        _controller.setBackgroundColor(bgColor);
      }
    });
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            _log.info('hCaptcha WebView loaded');
          },
          onWebResourceError: (error) {
            _log.severe('WebView error: ${error.description}');
            setState(() {
              _error = 'Failed to load verification. Please try again.';
              _isLoading = false;
            });
          },
        ),
      )
      ..addJavaScriptChannel(
        'Captcha',
        onMessageReceived: (JavaScriptMessage message) {
          final token = message.message;
          _log.info('hCaptcha token received: ${token.substring(0, 10)}...');
          if (token.isNotEmpty) {
            widget.onVerified(token);
          }
        },
      )
      ..loadHtmlString(_generateHtml(), baseUrl: 'https://app.mindweave.com');
  }

  Color _getBackgroundColor() {
    // macOS doesn't support transparent WebView backgrounds
    if (Theme.of(context).platform == TargetPlatform.macOS) {
      return widget.isDarkMode
          ? const Color(0xFF1a1a2e)
          : const Color(0xFFF8F9FA);
    }
    return Colors.transparent;
  }

  String _generateHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>hCaptcha</title>
</head>
<body style="background-color: aqua;">
  <div style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">
    <form method="POST">
      <div class="h-captcha" 
           data-sitekey="${widget.siteKey}"
           data-callback="captchaCallback"></div>
      <script src="https://js.hcaptcha.com/1/api.js" async defer></script>
    </form>
  </div>

  <script>
    function captchaCallback(response) {
      if (typeof Captcha !== "undefined") {
        Captcha.postMessage(response);
      }
    }
  </script>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;

    return Container(
      height: 450,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.isDarkMode
              ? [
                  const Color(0xFF1a1a2e).withValues(alpha: 0.95),
                  const Color(0xFF16213e).withValues(alpha: 0.98),
                ]
              : [
                  const Color(0xFFF8F9FA).withValues(alpha: 0.98),
                  const Color(0xFFE9ECEF).withValues(alpha: 1.0),
                ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: widget.isDarkMode
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Text(
              'Verify Humanity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // Subtitle
            Text(
              'Complete the verification to begin your journey',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: widget.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            // Error display
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // WebView Container
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 400 : double.infinity,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      WebViewWidget(controller: _controller),
                      if (_isLoading)
                        Container(
                          color: widget.isDarkMode
                              ? const Color(0xFF1a1a2e)
                              : const Color(0xFFF8F9FA),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Cancel button
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: widget.onCancelled,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white60 : Colors.black45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
