import 'package:flutter/material.dart';
import '../tokens/spacing_tokens.dart';

/// Player Layout Template - Mobile
///
/// Template for mobile player screen with fixed structure:
/// - Visualizer area (top, flexible)
/// - Preset info (middle)
/// - Controls (bottom, fixed)
///
/// Usage:
/// ```dart
/// PlayerMobileTemplate(
///   visualizer: PlayerVisualizer(...),
///   presetInfo: PresetInfoCard(...),
///   controls: PlayerControlBar(...),
/// )
/// ```text
class PlayerMobileTemplate extends StatelessWidget {
  final Widget visualizer;
  final Widget presetInfo;
  final Widget controls;
  final List<Widget>? additionalContent;

  const PlayerMobileTemplate({
    super.key,
    required this.visualizer,
    required this.presetInfo,
    required this.controls,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Visualizer area (flexible)
            Expanded(flex: 3, child: Center(child: visualizer)),
            // Preset info
            Padding(
              padding: SpacingTokens.screenPaddingMobile,
              child: presetInfo,
            ),
            // Additional content (optional)
            if (additionalContent != null)
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: SpacingTokens.screenPaddingMobile,
                  child: Column(children: additionalContent!),
                ),
              ),
            // Controls (fixed at bottom)
            Padding(
              padding: SpacingTokens.screenPaddingMobile,
              child: controls,
            ),
          ],
        ),
      ),
    );
  }
}

/// Player Layout Template - Desktop
///
/// Template for desktop player screen with sidebar layout:
/// - Left: Visualizer and main controls
/// - Right: Mixer, presets list, additional info
///
/// Usage:
/// ```dart
/// PlayerDesktopTemplate(
///   visualizer: PlayerVisualizer(...),
///   mainControls: PlayerControlBar(...),
///   sidePanel: MixerPanel(...),
/// )
/// ```text
class PlayerDesktopTemplate extends StatelessWidget {
  final Widget visualizer;
  final Widget mainControls;
  final Widget sidePanel;
  final double sidePanelWidth;

  const PlayerDesktopTemplate({
    super.key,
    required this.visualizer,
    required this.mainControls,
    required this.sidePanel,
    this.sidePanelWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Main player area
          Expanded(
            child: Padding(
              padding: SpacingTokens.screenPaddingDesktop,
              child: Column(
                children: [
                  // Visualizer takes most space
                  Expanded(flex: 4, child: Center(child: visualizer)),
                  // Compact controls at bottom
                  SizedBox(height: 160, child: mainControls),
                ],
              ),
            ),
          ),
          // Side panel - fixed width with glass effect
          Container(
            width: sidePanelWidth,
            padding: SpacingTokens.screenPaddingDesktop,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(20),
              border: Border(
                left: BorderSide(color: Colors.white.withAlpha(10), width: 1),
              ),
            ),
            child: sidePanel,
          ),
        ],
      ),
    );
  }
}
