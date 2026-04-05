import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/community_post.dart';

/// Provider for CommunityHubController
final communityHubControllerProvider = FutureProvider<List<CommunityPost>>((
  ref,
) async {
  final controller = CommunityHubController();
  return controller.fetchPosts();
});

/// Controller for fetching community hub data from Supabase
class CommunityHubController {
  final SupabaseClient _supabase;

  CommunityHubController({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Fetch all community posts ordered by creation date
  Future<List<CommunityPost>> fetchPosts() async {
    try {
      final response = await _supabase
          .from('community_posts')
          .select()
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => CommunityPost.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch community posts: $e');
    }
  }

  /// Fetch posts by type (featured, discussion, soundscape, small_card)
  Future<List<CommunityPost>> fetchPostsByType(String postType) async {
    try {
      final response = await _supabase
          .from('community_posts')
          .select()
          .eq('post_type', postType)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => CommunityPost.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch $postType posts: $e');
    }
  }

  /// Get featured post (most recent featured)
  Future<CommunityPost?> getFeaturedPost() async {
    try {
      final response = await _supabase
          .from('community_posts')
          .select()
          .eq('post_type', 'featured')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return CommunityPost.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch featured post: $e');
    }
  }

  /// Get discussion posts (medium cards)
  Future<List<CommunityPost>> getDiscussionPosts() async {
    return fetchPostsByType('discussion');
  }

  /// Get small cards
  Future<List<CommunityPost>> getSmallCards() async {
    return fetchPostsByType('small_card');
  }

  /// Get soundscape posts
  Future<List<CommunityPost>> getSoundscapePosts() async {
    return fetchPostsByType('soundscape');
  }
}
