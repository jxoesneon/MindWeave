import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/repository/journal_repository.dart';
import '../navigation/app_routes.dart';

/// Celestial Journal Screen — matches Stitch design: 38_celestial_journal.png
///
/// Features:
/// - Ethereal minimalist design with celestial aesthetic
/// - Large text input area for consciousness documentation
/// - Save Entry button with gradient styling
/// - Starfield background effect
class CelestialJournalScreen extends ConsumerStatefulWidget {
  const CelestialJournalScreen({super.key});

  @override
  ConsumerState<CelestialJournalScreen> createState() =>
      _CelestialJournalScreenState();
}

class _CelestialJournalScreenState
    extends ConsumerState<CelestialJournalScreen> {
  final TextEditingController _journalController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  // ignore: unused_field
  String? _currentEntryId;
  bool _isSaved = false;
  bool _isSaving = false;
  // ignore: unused_field
  String _searchQuery = '';

  @override
  void dispose() {
    _journalController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showHistoryDrawer(BuildContext context, {String searchQuery = ''}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _HistoryDrawer(searchQuery: searchQuery),
    );
  }

  Future<void> _saveEntry() async {
    final content = _journalController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSaving = true);

    final repository = ref.read(journalRepositoryProvider);
    final entry = await repository.saveEntry(
      content: content,
      sonicStates: ['Theta Flow', 'Astral', 'Quiet Mind'],
    );

    if (mounted) {
      setState(() {
        _isSaving = false;
        _isSaved = entry != null;
        if (entry != null) {
          _currentEntryId = entry.id;
        }
      });

      if (entry != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Journal entry saved to the cosmos'),
            backgroundColor: AppColors.primary,
          ),
        );
        // Refresh entries provider
        ref.invalidate(journalEntriesProvider);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save entry. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isSaved = false);
      });
    }
  }

  void _loadEntry(JournalEntry entry) {
    setState(() {
      _currentEntryId = entry.id;
      _journalController.text = entry.content;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded: ${entry.displayTitle}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;
    final statusColor = AppColors.onSurfaceVariant.withAlpha(128);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable content
            CustomScrollView(
              slivers: [
                // Header with search bar and action buttons inline
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      SpacingTokens.lg,
                      hPad,
                      SpacingTokens.lg,
                    ),
                    child: Row(
                      children: [
                        // Back button with fixed width container
                        SizedBox(
                          width: 140,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Search bar
                        Flexible(
                          flex: 2,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadiusTokens.fullCircular,
                              border: Border.all(
                                color: AppColors.outlineVariant.withAlpha(51),
                              ),
                            ),
                            child: TextField(
                              style: TypographyTokens.bodyMedium.copyWith(
                                color: AppColors.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search previous entries...',
                                hintStyle: TypographyTokens.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.onSurfaceVariant,
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: SpacingTokens.md,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                                if (value.isNotEmpty) {
                                  _showHistoryDrawer(
                                    context,
                                    searchQuery: value,
                                  );
                                } else {
                                  _showHistoryDrawer(context);
                                }
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Action buttons
                        SizedBox(
                          width: 140,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.notifications,
                                ),
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.supportUs,
                                ),
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.profile,
                                ),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.secondary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Title section with history icon
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      SpacingTokens.lg,
                      hPad,
                      SpacingTokens.lg,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Celestial Journal',
                                style: TypographyTokens.displaySmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: SpacingTokens.sm),
                              Text(
                                'Document your consciousness journeys.\nEach entry becomes a star in your personal constellation.',
                                style: TypographyTokens.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // History icon button
                        IconButton(
                          onPressed: () => _showHistoryDrawer(context),
                          icon: const Icon(
                            Icons.history,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Journal entry area - flexible height
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      0,
                      hPad,
                      200, // Space for bottom bar
                    ),
                    child: Stack(
                      children: [
                        // Particle field decoration
                        const Positioned.fill(child: _ParticleField()),
                        // Text input
                        Padding(
                          padding: const EdgeInsets.all(SpacingTokens.lg),
                          child: TextField(
                            controller: _journalController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: TypographyTokens.bodyLarge.copyWith(
                              color: AppColors.onSurface,
                              height: 1.6,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Begin your entry...\n\nWhat frequencies did you explore?\nWhat sensations arose?\nWhat insights emerged?',
                              hintStyle: TypographyTokens.bodyLarge.copyWith(
                                color: AppColors.onSurfaceVariant.withAlpha(
                                  128,
                                ),
                                height: 1.6,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              filled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Pinned bottom bar - everything inline
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  SpacingTokens.lg,
                  hPad,
                  SpacingTokens.xl,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withAlpha(0),
                      AppColors.background,
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left: SONIC STATES
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SONIC STATES',
                          style: TypographyTokens.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: SpacingTokens.sm),
                        Wrap(
                          spacing: SpacingTokens.sm,
                          runSpacing: SpacingTokens.sm,
                          children: [
                            _buildStateChip('Theta Flow'),
                            _buildStateChip('Astral'),
                            _buildStateChip('Quiet Mind'),
                            _buildAddChip(),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Center: Status row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_outlined,
                          size: 14,
                          color: statusColor,
                        ),
                        const SizedBox(width: SpacingTokens.xs),
                        Text(
                          'SYNCED TO NEBULA',
                          style: TypographyTokens.labelSmall.copyWith(
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: SpacingTokens.lg),
                        Icon(
                          Icons.waves_outlined,
                          size: 14,
                          color: statusColor,
                        ),
                        const SizedBox(width: SpacingTokens.xs),
                        Text(
                          'FREQUENCY: 4.5HZ',
                          style: TypographyTokens.labelSmall.copyWith(
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: SpacingTokens.lg),
                        Icon(
                          Icons.format_list_bulleted,
                          size: 14,
                          color: statusColor,
                        ),
                        const SizedBox(width: SpacingTokens.xs),
                        Text(
                          '${_journalController.text.split(" ").where((s) => s.isNotEmpty).length} WORDS',
                          style: TypographyTokens.labelSmall.copyWith(
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Right: ENHANCE and Save Entry
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ENHANCE button
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_fix_high,
                              size: 16,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: SpacingTokens.xs),
                            Text(
                              'ENHANCE',
                              style: TypographyTokens.labelMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: SpacingTokens.lg),
                        // Save Entry pill button
                        GestureDetector(
                          onTap: _isSaving
                              ? null
                              : () async {
                                  final content = _journalController.text
                                      .trim();
                                  if (content.isEmpty) return;
                                  await _saveEntry();
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingTokens.xl,
                              vertical: SpacingTokens.md,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _journalController.text.isNotEmpty
                                    ? [
                                        AppColors.primary,
                                        AppColors.primaryContainer,
                                      ]
                                    : [
                                        AppColors.primary.withAlpha(128),
                                        AppColors.primaryContainer.withAlpha(
                                          128,
                                        ),
                                      ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadiusTokens.fullCircular,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isSaved ? 'Saved to Cosmos' : 'Save Entry',
                                  style: TypographyTokens.labelLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: SpacingTokens.sm),
                                _isSaving
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.onPrimary,
                                        ),
                                      )
                                    : Icon(
                                        _isSaved ? Icons.check : Icons.edit,
                                        size: 18,
                                        color: AppColors.onPrimary,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadiusTokens.fullCircular,
      ),
      child: Text(
        label,
        style: TypographyTokens.labelMedium.copyWith(
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _buildAddChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadiusTokens.fullCircular,
      ),
      child: const Icon(Icons.add, size: 16, color: AppColors.onSurface),
    );
  }
}

/// Particle system with bouncing physics
class _ParticleField extends StatefulWidget {
  const _ParticleField();

  @override
  State<_ParticleField> createState() => _ParticleFieldState();
}

class _Particle {
  double x, y;
  double vx, vy;
  double radius;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
  });
}

class _ParticleFieldState extends State<_ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_Particle> _particles = [];
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_update);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initParticles(Size size) {
    _size = size;
    final random = DateTime.now().millisecondsSinceEpoch;
    _particles = [];

    const baseSpeed = 1.0;
    const speedMultiplier = 0.05;

    // Create 15 particles with 20x size (radius 20-60)
    for (var i = 0; i < 15; i++) {
      final radius = 20.0 + (i % 3) * 20;
      _particles.add(
        _Particle(
          x: (random + i * 137) % (size.width - radius * 2) + radius,
          y: (random + i * 211) % (size.height - radius * 2) + radius,
          vx:
              (i % 2 == 0 ? baseSpeed : -baseSpeed) *
              speedMultiplier *
              (0.5 + (i % 3) * 0.2),
          vy:
              (i % 3 == 0 ? baseSpeed : -baseSpeed) *
              speedMultiplier *
              (0.5 + (i % 2) * 0.2),
          radius: radius,
          color: AppColors.primary.withAlpha(20 + (i % 20)),
        ),
      );
    }
  }

  void _update() {
    if (_size == Size.zero || _particles.isEmpty) return;

    for (var i = 0; i < _particles.length; i++) {
      final p = _particles[i];

      // Update position
      p.x += p.vx;
      p.y += p.vy;

      // Bounce off walls
      if (p.x - p.radius < 0) {
        p.x = p.radius;
        p.vx = p.vx.abs();
      } else if (p.x + p.radius > _size.width) {
        p.x = _size.width - p.radius;
        p.vx = -p.vx.abs();
      }

      if (p.y - p.radius < 0) {
        p.y = p.radius;
        p.vy = p.vy.abs();
      } else if (p.y + p.radius > _size.height) {
        p.y = _size.height - p.radius;
        p.vy = -p.vy.abs();
      }
    }

    // Resolve collisions between particles (prevent overlap)
    for (var i = 0; i < _particles.length; i++) {
      for (var j = i + 1; j < _particles.length; j++) {
        final p1 = _particles[i];
        final p2 = _particles[j];

        final dx = p2.x - p1.x;
        final dy = p2.y - p1.y;
        final dist = sqrt(dx * dx + dy * dy);
        final minDist = p1.radius + p2.radius;

        if (dist < minDist && dist > 0) {
          // Calculate overlap
          final overlap = minDist - dist;
          final nx = dx / dist;
          final ny = dy / dist;

          // Separate particles
          p1.x -= nx * overlap * 0.5;
          p1.y -= ny * overlap * 0.5;
          p2.x += nx * overlap * 0.5;
          p2.y += ny * overlap * 0.5;

          // Swap velocities (elastic collision)
          final v1n = p1.vx * nx + p1.vy * ny;
          final v2n = p2.vx * nx + p2.vy * ny;

          p1.vx = p1.vx - v1n * nx + v2n * nx;
          p1.vy = p1.vy - v1n * ny + v2n * ny;
          p2.vx = p2.vx - v2n * nx + v1n * nx;
          p2.vy = p2.vy - v2n * ny + v1n * ny;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_particles.isEmpty || _size != constraints.biggest) {
          _initParticles(constraints.biggest);
        }

        return CustomPaint(
          size: constraints.biggest,
          painter: _ParticlePainter(_particles),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Create radial gradient for soft glowing particle effect
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          AppColors.primary.withAlpha(60),
          AppColors.primary.withAlpha(20),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      final rect = Rect.fromCircle(center: Offset(p.x, p.y), radius: p.radius);

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Frosted glass drawer for previous journal entries
class _HistoryDrawer extends ConsumerWidget {
  final String searchQuery;

  const _HistoryDrawer({this.searchQuery = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(230),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: _FrostedGlassContent(
          searchQuery: searchQuery,
          entriesAsync: entriesAsync,
        ),
      ),
    );
  }
}

/// Platform-aware frosted glass content
class _FrostedGlassContent extends StatelessWidget {
  final String searchQuery;
  final AsyncValue<List<JournalEntry>> entriesAsync;

  const _FrostedGlassContent({
    required this.searchQuery,
    required this.entriesAsync,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    // Use BackdropFilter on mobile, fallback on desktop
    if (Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.android) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: content,
      );
    }

    // Desktop fallback - use a translucent background without blur
    return Container(color: AppColors.surface.withAlpha(240), child: content);
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle bar
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.onSurfaceVariant.withAlpha(128),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: SpacingTokens.lg),
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
          child: Row(
            children: [
              Text(
                'Journal History',
                style: TypographyTokens.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const SizedBox(height: SpacingTokens.md),
        // Entries list
        Expanded(
          child: entriesAsync.when(
            data: (entries) {
              // Filter entries based on search query
              final filteredEntries = searchQuery.isEmpty
                  ? entries
                  : entries.where((entry) {
                      final query = searchQuery.toLowerCase();
                      return entry.displayTitle.toLowerCase().contains(query) ||
                          entry.content.toLowerCase().contains(query) ||
                          entry.preview.toLowerCase().contains(query);
                    }).toList();

              if (filteredEntries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        searchQuery.isEmpty
                            ? Icons.book_outlined
                            : Icons.search_off,
                        size: 48,
                        color: AppColors.onSurfaceVariant.withAlpha(128),
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      Text(
                        searchQuery.isEmpty
                            ? 'No entries yet'
                            : 'No matches found',
                        style: TypographyTokens.bodyLarge.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      Text(
                        searchQuery.isEmpty
                            ? 'Start writing to create your first journal entry'
                            : 'Try a different search term',
                        style: TypographyTokens.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.lg,
                ),
                itemCount: filteredEntries.length,
                itemBuilder: (context, index) {
                  final entry = filteredEntries[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // Find the parent state and load the entry
                      final state = context
                          .findAncestorStateOfType<
                            _CelestialJournalScreenState
                          >();
                      if (state != null) {
                        state._loadEntry(entry);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: SpacingTokens.md),
                      padding: const EdgeInsets.all(SpacingTokens.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer.withAlpha(180),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.outlineVariant.withAlpha(51),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.displayTitle,
                                  style: TypographyTokens.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: SpacingTokens.sm),
                              Text(
                                entry.formattedDate,
                                style: TypographyTokens.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SpacingTokens.xs),
                          if (entry.preview.isNotEmpty)
                            Text(
                              entry.preview,
                              style: TypographyTokens.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: SpacingTokens.xs),
                          Row(
                            children: [
                              Icon(
                                Icons.format_list_bulleted,
                                size: 14,
                                color: AppColors.onSurfaceVariant.withAlpha(
                                  128,
                                ),
                              ),
                              const SizedBox(width: SpacingTokens.xs),
                              Text(
                                '${entry.wordCount} words',
                                style: TypographyTokens.labelSmall.copyWith(
                                  color: AppColors.onSurfaceVariant.withAlpha(
                                    128,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.withAlpha(128),
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  Text(
                    'Failed to load entries',
                    style: TypographyTokens.bodyLarge.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: SpacingTokens.lg),
      ],
    );
  }
}
