import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'guest_auth_service.dart';

/// User profile data model containing all user information from Supabase/Google
class UserProfile {
  final String id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final bool isAnonymous;
  final DateTime? createdAt;
  final Map<String, dynamic> metadata;

  const UserProfile({
    required this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.isAnonymous = false,
    this.createdAt,
    this.metadata = const {},
  });

  /// Create from Supabase User
  factory UserProfile.fromUser(User? user) {
    if (user == null) {
      return const UserProfile(id: '');
    }

    final metadata = user.userMetadata ?? {};

    return UserProfile(
      id: user.id,
      email: user.email,
      displayName:
          metadata['full_name'] as String? ?? metadata['name'] as String?,
      avatarUrl:
          metadata['avatar_url'] as String? ?? metadata['picture'] as String?,
      isAnonymous: user.appMetadata['is_anonymous'] == true,
      metadata: metadata,
    );
  }

  /// Get initials for avatar fallback
  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.split(' ');
      if (parts.length > 1) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }
    return '?';
  }

  /// Get display name or fallback
  String get displayNameOrFallback {
    return displayName ?? email ?? 'Guest User';
  }

  /// Check if user has avatar
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, displayName: $displayName, isAnonymous: $isAnonymous)';
  }
}

/// Provider for user profile that reacts to auth state changes
final userProfileProvider = Provider<UserProfile>((ref) {
  final user = ref.watch(currentUserProvider);
  return UserProfile.fromUser(user);
});

/// Stream provider for real-time user profile updates
final userProfileStreamProvider = StreamProvider<UserProfile>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (state) => Stream.value(UserProfile.fromUser(state.session?.user)),
    loading: () => Stream.value(const UserProfile(id: '')),
    error: (_, _) => Stream.value(const UserProfile(id: '')),
  );
});
