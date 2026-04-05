import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/deep_link_service.dart';
import '../../core/organisms/organisms.dart';
import '../home/player_screen.dart';
import '../favorites/library_screen.dart';
import '../frequencies/frequencies_screen.dart';
import '../journal/celestial_journal_screen.dart';
import '../community/community_hub_screen.dart';

/// Main navigation shell for MindWeave app.
///
/// Provides responsive navigation:
/// - Bottom navigation bar for mobile (< 1024px)
/// - Sidebar navigation for desktop (>= 1024px)
/// - Maintains state across tab switches using IndexedStack
/// - Uses atomic design system components
class MainNavigation extends ConsumerStatefulWidget {
  final DeepLinkService? deepLinkService;

  const MainNavigation({super.key, this.deepLinkService});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0; // Start on Sanctuary (now first in list)
  bool _isSidebarCollapsed = false;

  // Navigation items using the new NavItem class
  List<NavItem> get _navItems => const [
    NavItem(icon: Icons.spa_outlined, label: 'Sanctuary'),
    NavItem(icon: Icons.library_music_outlined, label: 'Library'),
    NavItem(icon: Icons.waves_outlined, label: 'Frequencies'),
    NavItem(icon: Icons.book_outlined, label: 'Journals'),
    NavItem(icon: Icons.people_outlined, label: 'Community'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    if (isDesktop) {
      return _buildDesktopLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  /// Desktop layout with multi-panel design per Stitch specs
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          SidebarNavigation(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            isCollapsed: _isSidebarCollapsed,
            items: _navItems,
            onToggleCollapse: () =>
                setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
          ),
          // Main content area - show different layouts based on current screen
          Expanded(child: _buildDesktopContent()),
        ],
      ),
    );
  }

  /// Build desktop content with multi-panel layouts per Stitch specs
  Widget _buildDesktopContent() {
    switch (_currentIndex) {
      case 0: // Sanctuary/Player - Multi-panel layout
        return _buildPlayerDesktopLayout();
      case 1: // Library
        return const LibraryScreen();
      case 2: // Frequencies
        return const FrequenciesScreen();
      case 3: // Journals
        return const CelestialJournalScreen();
      case 4: // Community
        return const CommunityHubScreen();
      default:
        return _buildPlayerDesktopLayout();
    }
  }

  /// Stitch desktop player layout with persistent mixer panel
  Widget _buildPlayerDesktopLayout() {
    return PlayerScreen(deepLinkService: widget.deepLinkService);
  }

  /// Mobile layout with bottom navigation bar
  Widget _buildMobileLayout() {
    // Screens for IndexedStack - maintain state across tab switches
    final screens = [
      PlayerScreen(deepLinkService: widget.deepLinkService), // Sanctuary
      const LibraryScreen(),
      const FrequenciesScreen(),
      const CelestialJournalScreen(),
      const CommunityHubScreen(), // Community
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}
