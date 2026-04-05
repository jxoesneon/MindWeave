import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/community_post.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/tokens/shadow_tokens.dart';
import '../../core/atoms/atoms.dart';
import 'community_hub_controller.dart';
import 'create_post_screen.dart';

/// Community Hub Screen
///
/// Matches Stitch design: 32_Comunity_Hub.png
///
/// Single scrollable page with:
/// - Header: COLLECTIVE CONSCIOUSNESS subtitle + Community Hub title + Create New Post
/// - Topic filter chips: All Frequencies, Meditation, Neuroscience, Deep Sleep, Focus Loops
/// - Featured article card (large, with image)
/// - Two medium discussion cards side by side
/// - Soundscape shared banner (purple gradient)
/// - Three smaller discussion cards at bottom
class CommunityHubScreen extends ConsumerStatefulWidget {
  const CommunityHubScreen({super.key});

  @override
  ConsumerState<CommunityHubScreen> createState() => _CommunityHubScreenState();
}

class _CommunityHubScreenState extends ConsumerState<CommunityHubScreen> {
  String _selectedFilter = 'All Frequencies';

  final List<String> _filters = [
    'All Frequencies',
    'Meditation',
    'Neuroscience',
    'Deep Sleep',
    'Focus Loops',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;
    final postsAsync = ref.watch(communityHubControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: postsAsync.when(
          data: (posts) => _buildContent(context, posts, isDesktop, hPad),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 64,
                  color: AppColors.onSurfaceVariant.withAlpha(128),
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to load community posts',
                  style: TypographyTokens.bodyLarge.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(communityHubControllerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<CommunityPost> posts,
    bool isDesktop,
    double hPad,
  ) {
    final featuredPost = posts
        .where((p) => p.postType == 'featured')
        .firstOrNull;
    final discussionPosts = posts
        .where((p) => p.postType == 'discussion')
        .toList();
    final smallCards = posts.where((p) => p.postType == 'small_card').toList();
    final soundscapePost = posts
        .where((p) => p.postType == 'soundscape')
        .firstOrNull;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(hPad)),
        SliverToBoxAdapter(child: _buildFilterChips(hPad)),
        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: featuredPost != null
                ? _buildFeaturedCard(isDesktop, featuredPost)
                : const SizedBox.shrink(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: _buildMediumCardsRow(isDesktop, discussionPosts),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: soundscapePost != null
                ? _buildSoundscapeBanner(soundscapePost)
                : const SizedBox.shrink(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: _buildSmallCardsRow(isDesktop, smallCards),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xxl)),
      ],
    );
  }

  // ─────────────────────────────────────────────
  Widget _buildHeader(double hPad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        hPad,
        SpacingTokens.lg,
        hPad,
        SpacingTokens.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COLLECTIVE CONSCIOUSNESS',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(
                  'Community Hub',
                  style: TypographyTokens.headlineMedium.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Create New Post button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreatePostScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.lg,
                vertical: SpacingTokens.sm,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadiusTokens.fullCircular,
                boxShadow: ShadowTokens.buttonGlow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: AppColors.onPrimary, size: 18),
                  const SizedBox(width: SpacingTokens.xs),
                  Text(
                    'Create New Post',
                    style: TypographyTokens.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Filter chips row
  // ─────────────────────────────────────────────
  Widget _buildFilterChips(double hPad) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: hPad),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: SpacingTokens.sm),
            child: MwChip(
              label: filter,
              isSelected: isSelected,
              onTap: () => setState(() => _selectedFilter = filter),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Featured article card (large)
  // ─────────────────────────────────────────────
  Widget _buildFeaturedCard(bool isDesktop, CommunityPost post) {
    return Container(
      height: isDesktop ? 220 : null,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: isDesktop
          ? Row(
              children: [
                // Image area
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(BorderRadiusTokens.lg),
                  ),
                  child: Container(
                    width: 280,
                    color: AppColors.surfaceContainerHigh,
                    child: Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: 64,
                        color: AppColors.primary.withAlpha(128),
                      ),
                    ),
                  ),
                ),
                // Text content
                Expanded(child: _buildFeaturedContent(post)),
              ],
            )
          : Column(
              children: [
                // Image area
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(BorderRadiusTokens.lg),
                  ),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: AppColors.surfaceContainerHigh,
                    child: Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: 64,
                        color: AppColors.primary.withAlpha(128),
                      ),
                    ),
                  ),
                ),
                _buildFeaturedContent(post),
              ],
            ),
    );
  }

  Widget _buildFeaturedContent(CommunityPost post) {
    return Padding(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // User row
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.surfaceContainerHigh,
                child: Icon(
                  Icons.person,
                  size: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: SpacingTokens.xs),
              Text(
                post.authorName,
                style: TypographyTokens.labelMedium.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: SpacingTokens.sm),
              Text(
                '• ${post.tag ?? 'recently'}',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.md),
          Text(
            post.title,
            style: TypographyTokens.titleLarge.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            post.body,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: SpacingTokens.md),
          // Engagement
          Row(
            children: [
              Icon(
                Icons.favorite,
                size: 16,
                color: AppColors.primary.withAlpha(179),
              ),
              const SizedBox(width: 4),
              Text(
                '${post.likesCount > 1000 ? '${(post.likesCount / 1000).toStringAsFixed(1)}k' : post.likesCount}',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: SpacingTokens.md),
              const Icon(
                Icons.chat_bubble_outline,
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.commentsCount}',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Two medium discussion cards
  // ─────────────────────────────────────────────
  Widget _buildMediumCardsRow(bool isDesktop, List<CommunityPost> posts) {
    if (posts.isEmpty) return const SizedBox.shrink();

    // Take first 2 posts for medium cards
    final displayPosts = posts.take(2).toList();

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: displayPosts
            .map(
              (post) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: post == displayPosts.last ? 0 : SpacingTokens.md,
                  ),
                  child: _buildDiscussionCard(post),
                ),
              ),
            )
            .toList(),
      );
    }
    return Column(
      children: displayPosts
          .map(
            (post) => Padding(
              padding: EdgeInsets.only(
                bottom: post == displayPosts.last ? 0 : SpacingTokens.md,
              ),
              child: _buildDiscussionCard(post),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDiscussionCard(CommunityPost post) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User row
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.surfaceContainerHigh,
                child: Icon(
                  Icons.person,
                  size: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: SpacingTokens.xs),
              Text(
                post.authorName,
                style: TypographyTokens.labelMedium.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.md),
          Text(
            post.title,
            style: TypographyTokens.titleSmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            post.body,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: SpacingTokens.md),
          // Metrics row
          Row(
            children: [
              Icon(
                _getIconData(post.metric1Icon ?? 'visibility_outlined'),
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                post.metric1Value ?? '0',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: SpacingTokens.md),
              Icon(
                _getIconData(post.metric2Icon ?? 'chat_bubble_outline'),
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                post.metric2Value ?? '0',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                post.tag ?? '',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant.withAlpha(128),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to convert icon string to IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'visibility_outlined':
        return Icons.visibility_outlined;
      case 'chat_bubble_outline':
        return Icons.chat_bubble_outline;
      case 'event':
        return Icons.event;
      case 'people_outline':
        return Icons.people_outline;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.circle;
    }
  }

  // ─────────────────────────────────────────────
  // Soundscape shared banner
  // ─────────────────────────────────────────────
  Widget _buildSoundscapeBanner(CommunityPost post) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(51),
            AppColors.primaryContainer.withAlpha(38),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.primary.withAlpha(64)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.tag ?? 'NEW SOUNDSCAPE SHARED',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  post.title,
                  style: TypographyTokens.titleMedium.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(
                  '"${post.body}"',
                  style: TypographyTokens.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: SpacingTokens.md),
          // Play button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadiusTokens.fullCircular,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: AppColors.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: SpacingTokens.sm),
          // Download button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.download_outlined,
              color: AppColors.onSurfaceVariant,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Three smaller discussion cards
  // ─────────────────────────────────────────────
  Widget _buildSmallCardsRow(bool isDesktop, List<CommunityPost> posts) {
    if (posts.isEmpty) return const SizedBox.shrink();

    // Take up to 3 posts for small cards
    final displayPosts = posts.take(3).toList();

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: displayPosts
            .map(
              (post) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: post == displayPosts.last ? 0 : SpacingTokens.md,
                  ),
                  child: _buildSmallCard(post),
                ),
              ),
            )
            .toList(),
      );
    }
    return Column(
      children: displayPosts
          .map(
            (post) => Padding(
              padding: EdgeInsets.only(
                bottom: post == displayPosts.last ? 0 : SpacingTokens.md,
              ),
              child: _buildSmallCard(post),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSmallCard(CommunityPost post) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: TypographyTokens.titleSmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            post.body,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: SpacingTokens.md),
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.commentsCount}',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: SpacingTokens.md),
              const Icon(
                Icons.share_outlined,
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.sharesCount}',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadiusTokens.smCircular,
                ),
                child: const Icon(
                  Icons.bookmark_outline,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
