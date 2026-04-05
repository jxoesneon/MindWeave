import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/guest_auth_service.dart';
import '../supabase/supabase_client_provider.dart';

// Manual provider since build_runner is not available
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final guestAuth = ref.watch(guestAuthServiceProvider);
  return JournalRepository(supabase: supabaseClient, guestAuth: guestAuth);
});

// Provider for entries stream
final journalEntriesProvider = StreamProvider<List<JournalEntry>>((ref) {
  final repository = ref.watch(journalRepositoryProvider);
  return Stream.fromFuture(repository.getEntries());
});

/// Journal entry model
class JournalEntry {
  final String id;
  final String userId;
  final String? title;
  final String content;
  final int wordCount;
  final double frequencyHz;
  final List<String> sonicStates;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    required this.id,
    required this.userId,
    this.title,
    required this.content,
    required this.wordCount,
    this.frequencyHz = 4.5,
    this.sonicStates = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String?,
      content: map['content'] as String,
      wordCount: map['word_count'] as int? ?? 0,
      frequencyHz: (map['frequency_hz'] as num?)?.toDouble() ?? 4.5,
      sonicStates: List<String>.from(map['sonic_states'] ?? []),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'word_count': wordCount,
      'frequency_hz': frequencyHz,
      'sonic_states': sonicStates,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayTitle {
    if (title != null && title!.isNotEmpty) return title!;
    // Extract first line or first 30 chars
    final firstLine = content.split('\n').first.trim();
    if (firstLine.isEmpty) return 'Untitled Entry';
    if (firstLine.length > 30) return '${firstLine.substring(0, 30)}...';
    return firstLine;
  }

  String get preview {
    final lines = content
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    if (lines.length > 1) {
      final secondLine = lines[1].trim();
      if (secondLine.length > 50) return '${secondLine.substring(0, 50)}...';
      return secondLine;
    }
    return '';
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }

    return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
  }
}

/// Repository for journal entries
class JournalRepository {
  final SupabaseClient _supabase;
  final GuestAuthService _guestAuth;
  static const String _tableName = 'journal_entries';

  JournalRepository({
    required SupabaseClient supabase,
    required GuestAuthService guestAuth,
  }) : _supabase = supabase,
       _guestAuth = guestAuth;

  /// Check if Supabase is properly configured
  bool get _isConfigured {
    final supabaseUrl = _supabase.rest.url;
    return !supabaseUrl.contains('your_supabase') && supabaseUrl.isNotEmpty;
  }

  /// Get current user ID (ensures auth first)
  Future<String?> _getUserId() async {
    final user = await _guestAuth.ensureAuthenticated();
    return user?.id;
  }

  /// Fetch all entries for current user
  Future<List<JournalEntry>> getEntries() async {
    if (!_isConfigured) {
      debugPrint('⚠️ Supabase not configured, returning empty entries');
      return [];
    }

    final userId = await _getUserId();
    if (userId == null) {
      debugPrint('⚠️ No user logged in');
      return [];
    }

    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((e) => JournalEntry.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching journal entries: $e');
      return [];
    }
  }

  /// Save a new entry
  Future<JournalEntry?> saveEntry({
    required String content,
    String? title,
    double frequencyHz = 4.5,
    List<String> sonicStates = const [],
  }) async {
    if (!_isConfigured) {
      debugPrint('⚠️ Supabase not configured, entry not saved');
      return null;
    }

    final userId = await _getUserId();
    if (userId == null) {
      debugPrint('⚠️ No user logged in, entry not saved');
      return null;
    }

    final wordCount = content.split(' ').where((s) => s.isNotEmpty).length;

    try {
      final response = await _supabase
          .from(_tableName)
          .insert({
            'user_id': userId,
            'title': title,
            'content': content,
            'word_count': wordCount,
            'frequency_hz': frequencyHz,
            'sonic_states': sonicStates,
          })
          .select()
          .single();

      return JournalEntry.fromMap(response);
    } catch (e) {
      debugPrint('❌ Error saving journal entry: $e');
      return null;
    }
  }

  /// Update an existing entry
  Future<JournalEntry?> updateEntry({
    required String id,
    required String content,
    String? title,
    double frequencyHz = 4.5,
    List<String> sonicStates = const [],
  }) async {
    if (!_isConfigured) return null;

    final userId = await _getUserId();
    if (userId == null) return null;

    final wordCount = content.split(' ').where((s) => s.isNotEmpty).length;

    try {
      final response = await _supabase
          .from(_tableName)
          .update({
            'title': title,
            'content': content,
            'word_count': wordCount,
            'frequency_hz': frequencyHz,
            'sonic_states': sonicStates,
          })
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();

      return JournalEntry.fromMap(response);
    } catch (e) {
      debugPrint('❌ Error updating journal entry: $e');
      return null;
    }
  }

  /// Delete an entry
  Future<bool> deleteEntry(String id) async {
    if (!_isConfigured) return false;

    final userId = await _getUserId();
    if (userId == null) return false;

    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting journal entry: $e');
      return false;
    }
  }
}
