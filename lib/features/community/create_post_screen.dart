import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/user_profile_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/atoms/atoms.dart';

/// Screen for creating a new post in the community sanctuary.
/// Features category selection, title/content inputs, and attachment options.
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  String _selectedCategory = 'Meditation Technique';
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _wordCount = 0;

  final List<String> _categories = [
    'Neuroscience',
    'Meditation Technique',
    'New Frequency Suggestion',
    'Deep Sleep',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateWordCount() {
    final text = _contentController.text.trim();
    final count = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    setState(() => _wordCount = count);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with user info and action buttons
            Padding(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User info
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                          image: userProfile.hasAvatar
                              ? DecorationImage(
                                  image: NetworkImage(userProfile.avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: userProfile.hasAvatar
                            ? null
                            : Center(
                                child: Text(
                                  userProfile.initials,
                                  style: TypographyTokens.labelMedium.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfile.displayNameOrFallback,
                            style: TypographyTokens.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'PUBLISHING TO SANCTUARY',
                            style: TypographyTokens.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Action buttons
                  Row(
                    children: [
                      MwSecondaryButton(
                        onPressed: () => Navigator.pop(context),
                        label: 'Save Draft',
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                      MwPrimaryButton(
                        onPressed: () {
                          // TODO: Publish post
                          Navigator.pop(context);
                        },
                        label: 'Publish',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Category selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECT RESONANCE',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = category == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: SpacingTokens.sm,
                          ),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (_) =>
                                setState(() => _selectedCategory = category),
                            backgroundColor: AppColors.surfaceContainer,
                            selectedColor: AppColors.primaryContainer,
                            labelStyle: TypographyTokens.labelMedium.copyWith(
                              color: isSelected
                                  ? AppColors.onPrimaryContainer
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingTokens.lg),

            // Title input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
              child: TextField(
                controller: _titleController,
                style: TypographyTokens.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'The title of your echo...',
                  hintStyle: TypographyTokens.headlineMedium.copyWith(
                    color: AppColors.onSurfaceVariant.withAlpha(128),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            const SizedBox(height: SpacingTokens.md),

            // Attachment toolbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
              child: Row(
                children: [
                  _AttachmentButton(
                    icon: Icons.music_note,
                    label: 'ATTACH SOUNDSCAPE NODE',
                    onPressed: () {
                      // TODO: Attach soundscape
                    },
                  ),
                  const SizedBox(width: SpacingTokens.md),
                  _AttachmentButton(
                    icon: Icons.image,
                    label: 'ADD IMAGE',
                    onPressed: () {
                      // TODO: Add image
                    },
                  ),
                  const SizedBox(width: SpacingTokens.md),
                  _AttachmentButton(
                    icon: Icons.link,
                    label: 'INSERT LINK',
                    onPressed: () {
                      // TODO: Insert link
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingTokens.md),

            // Content text area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.lg,
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TypographyTokens.bodyLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Let your frequencies flow here. Share insights, research, or techniques for the collective...',
                    hintStyle: TypographyTokens.bodyLarge.copyWith(
                      color: AppColors.onSurfaceVariant.withAlpha(128),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (_) => _updateWordCount(),
                ),
              ),
            ),

            // Bottom status bar
            Container(
              margin: const EdgeInsets.all(SpacingTokens.lg),
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.md,
                vertical: SpacingTokens.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadiusTokens.card,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_fix_high,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: SpacingTokens.xs),
                      Text(
                        'ENHANCED FLOW MODE ACTIVE',
                        style: TypographyTokens.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                      Text(
                        'WORD ENERGY: $_wordCount',
                        style: TypographyTokens.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Attachment button for the toolbar
class _AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _AttachmentButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
      label: Text(
        label,
        style: TypographyTokens.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.sm),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
