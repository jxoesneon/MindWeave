import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../atoms/atoms.dart';
import '../../tokens/component_types.dart';

/// Session Card Molecule
///
/// Card displaying a past listening session with date, duration,
/// preset used, and optional notes.
///
/// Usage:
/// ```dart
/// SessionCard(
///   date: DateTime.now(),
///   duration: Duration(minutes: 30),
///   presetName: 'Deep Focus',
///   notes: 'Felt very relaxed',
///   onTap: () {},
/// )
/// ```text
class SessionCard extends StatelessWidget {
  final DateTime date;
  final Duration duration;
  final String presetName;
  final String? notes;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SessionCard({
    super.key,
    required this.date,
    required this.duration,
    required this.presetName,
    this.notes,
    this.onTap,
    this.onDelete,
  });

  String get _formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return 'Today, ${_formatTime(date)}';
    } else if (sessionDate == yesterday) {
      return 'Yesterday, ${_formatTime(date)}';
    } else {
      return '${_formatDate(date)}, ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  String get _formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return MwTonalContainer(
      tonalLevel: TonalLevel.surfaceContainer,
      borderRadius: BorderRadiusTokens.card,
      child: ClipRRect(
        borderRadius: BorderRadiusTokens.card,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadiusTokens.card,
            child: Padding(
              padding: SpacingTokens.cardPadding,
              child: Row(
                children: [
                  // Date indicator
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withAlpha(51),
                      borderRadius: BorderRadiusTokens.mdCircular,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.day.toString(),
                          style: TypographyTokens.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _getMonthAbbrev(date.month),
                          style: TypographyTokens.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.md),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          presetName,
                          style: TypographyTokens.titleSmall.copyWith(
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: SpacingTokens.xxs),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: SpacingTokens.xxs),
                            Text(
                              _formattedDuration,
                              style: TypographyTokens.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: SpacingTokens.sm),
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: SpacingTokens.xxs),
                            Text(
                              _formattedDate,
                              style: TypographyTokens.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        if (notes != null && notes!.isNotEmpty) ...[
                          const SizedBox(height: SpacingTokens.xs),
                          Text(
                            notes!,
                            style: TypographyTokens.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Delete action
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthAbbrev(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }
}
