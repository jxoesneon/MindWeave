import 'dart:async';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/brainwave_preset.dart';
import '../models/session_record.dart';

class SessionHistoryService {
  static final SessionHistoryService _instance =
      SessionHistoryService._internal();
  factory SessionHistoryService() => _instance;
  SessionHistoryService._internal();

  SupabaseClient? _supabaseClient;
  SupabaseClient get _supabase => _supabaseClient ?? Supabase.instance.client;
  final Logger _logger = Logger('SessionHistoryService');
  final Uuid _uuid = const Uuid();

  // Local cache for offline support
  List<SessionRecord> _localSessions = [];
  final StreamController<List<SessionRecord>> _sessionsController =
      StreamController<List<SessionRecord>>.broadcast();

  Stream<List<SessionRecord>> get sessionsStream => _sessionsController.stream;
  List<SessionRecord> get cachedSessions => List.unmodifiable(_localSessions);

  Future<void> initialize() async {
    try {
      await _loadLocalSessions();
      await _syncWithServer();
      _logger.info('Session history service initialized');
    } catch (e) {
      _logger.severe('Failed to initialize session history service: $e');
    }
  }

  Future<String> startSession({
    required BrainwavePreset preset,
    required double beatFrequency,
    required double carrierFrequency,
    required double volume,
    required Duration targetDuration,
  }) async {
    try {
      final sessionId = _uuid.v4();
      final session = SessionRecord(
        id: sessionId,
        userId: _supabase.auth.currentSession?.user.id ?? 'anonymous',
        presetId: preset.id,
        presetName: preset.name,
        brainwaveBand: preset.band,
        beatFrequency: beatFrequency,
        carrierFrequency: carrierFrequency,
        volume: volume,
        startedAt: DateTime.now(),
        targetDuration: targetDuration,
        status: SessionStatus.active,
      );

      // Save locally first for immediate UI updates
      _localSessions.insert(0, session);
      _sessionsController.add(List.from(_localSessions));
      await _saveLocalSessions();

      // Try to save to server
      try {
        await _saveSessionToServer(session);
      } catch (e) {
        _logger.warning(
          'Failed to save session to server, will sync later: $e',
        );
        // Mark for sync
        await _markSessionForSync(sessionId);
      }

      return sessionId;
    } catch (e) {
      _logger.severe('Failed to start session: $e');
      rethrow;
    }
  }

  Future<void> updateSession({
    required String sessionId,
    Duration? currentDuration,
    double? currentVolume,
    SessionStatus? status,
    bool? completed,
  }) async {
    try {
      final sessionIndex = _localSessions.indexWhere((s) => s.id == sessionId);
      if (sessionIndex == -1) {
        _logger.warning('Session not found: $sessionId');
        return;
      }

      var updatedSession = _localSessions[sessionIndex].copyWith(
        currentDuration: currentDuration,
        currentVolume: currentVolume,
        completed: completed,
        lastUpdatedAt: DateTime.now(),
      );
      if (status != null) {
        updatedSession = updatedSession.copyWith(status: status);
      }

      _localSessions[sessionIndex] = updatedSession;
      _sessionsController.add(List.from(_localSessions));
      await _saveLocalSessions();

      // Update on server
      try {
        await _updateSessionOnServer(updatedSession);
      } catch (e) {
        _logger.warning(
          'Failed to update session on server, will sync later: $e',
        );
        await _markSessionForSync(sessionId);
      }
    } catch (e) {
      _logger.severe('Failed to update session: $e');
    }
  }

  Future<void> completeSession({
    required String sessionId,
    required Duration actualDuration,
    bool completed = true,
    String? notes,
  }) async {
    try {
      final sessionIndex = _localSessions.indexWhere((s) => s.id == sessionId);
      if (sessionIndex == -1) {
        _logger.warning('Session not found: $sessionId');
        return;
      }

      final completedSession = _localSessions[sessionIndex].copyWith(
        currentDuration: actualDuration,
        actualDuration: actualDuration,
        status: SessionStatus.completed,
        completed: completed,
        endedAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
        notes: notes,
      );

      _localSessions[sessionIndex] = completedSession;
      _sessionsController.add(List.from(_localSessions));
      await _saveLocalSessions();

      // Update on server
      try {
        await _updateSessionOnServer(completedSession);
      } catch (e) {
        _logger.warning(
          'Failed to complete session on server, will sync later: $e',
        );
        await _markSessionForSync(sessionId);
      }
    } catch (e) {
      _logger.severe('Failed to complete session: $e');
    }
  }

  Future<void> cancelSession({
    required String sessionId,
    String? reason,
  }) async {
    try {
      final sessionIndex = _localSessions.indexWhere((s) => s.id == sessionId);
      if (sessionIndex == -1) {
        _logger.warning('Session not found: $sessionId');
        return;
      }

      final cancelledSession = _localSessions[sessionIndex].copyWith(
        status: SessionStatus.cancelled,
        endedAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
        notes: reason,
      );

      _localSessions[sessionIndex] = cancelledSession;
      _sessionsController.add(List.from(_localSessions));
      await _saveLocalSessions();

      // Update on server
      try {
        await _updateSessionOnServer(cancelledSession);
      } catch (e) {
        _logger.warning(
          'Failed to cancel session on server, will sync later: $e',
        );
        await _markSessionForSync(sessionId);
      }
    } catch (e) {
      _logger.severe('Failed to cancel session: $e');
    }
  }

  Future<List<SessionRecord>> getSessions({
    int limit = 50,
    int offset = 0,
    DateTime? startDate,
    DateTime? endDate,
    BrainwaveBand? brainwaveBand,
    SessionStatus? status,
  }) async {
    try {
      // Filter local sessions first
      var filteredSessions = List<SessionRecord>.from(_localSessions);

      if (startDate != null) {
        filteredSessions = filteredSessions
            .where((s) => s.startedAt.isAfter(startDate))
            .toList();
      }
      if (endDate != null) {
        filteredSessions = filteredSessions
            .where((s) => s.startedAt.isBefore(endDate))
            .toList();
      }
      if (brainwaveBand != null) {
        filteredSessions = filteredSessions
            .where((s) => s.brainwaveBand == brainwaveBand)
            .toList();
      }
      if (status != null) {
        filteredSessions = filteredSessions
            .where((s) => s.status == status)
            .toList();
      }

      // Sort by start date (newest first)
      filteredSessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));

      // Apply pagination
      final startIndex = offset;
      final endIndex = (startIndex + limit).clamp(0, filteredSessions.length);

      return filteredSessions.sublist(startIndex, endIndex);
    } catch (e) {
      _logger.severe('Failed to get sessions: $e');
      return [];
    }
  }

  Future<SessionRecord?> getSession(String sessionId) async {
    try {
      return _localSessions.where((s) => s.id == sessionId).firstOrNull;
    } catch (e) {
      _logger.severe('Failed to get session: $e');
      return null;
    }
  }

  Future<SessionStats> getSessionStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final sessions = await getSessions(
        startDate:
            startDate ?? DateTime.now().subtract(const Duration(days: 30)),
        endDate: endDate ?? DateTime.now(),
      );

      final completedSessions = sessions
          .where((s) => s.completed == true)
          .toList();

      final totalDuration = completedSessions.fold<Duration>(
        Duration.zero,
        (sum, session) => sum + (session.actualDuration ?? Duration.zero),
      );

      final sessionsByBand = <BrainwaveBand, int>{};
      for (final band in BrainwaveBand.values) {
        sessionsByBand[band] = completedSessions
            .where((s) => s.brainwaveBand == band)
            .length;
      }

      final averageSessionLength = completedSessions.isEmpty
          ? Duration.zero
          : Duration(
              seconds: totalDuration.inSeconds ~/ completedSessions.length,
            );

      return SessionStats(
        totalSessions: completedSessions.length,
        totalDuration: totalDuration,
        averageSessionLength: averageSessionLength,
        sessionsByBrainwaveBand: sessionsByBand,
        currentStreak: await _calculateCurrentStreak(),
        longestStreak: await _calculateLongestStreak(),
      );
    } catch (e) {
      _logger.severe('Failed to get session stats: $e');
      return SessionStats.empty();
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      // Remove from local cache
      _localSessions.removeWhere((s) => s.id == sessionId);
      _sessionsController.add(List.from(_localSessions));
      await _saveLocalSessions();

      // Delete from server
      try {
        await _supabase.from('sessions').delete().eq('id', sessionId);
      } catch (e) {
        _logger.warning('Failed to delete session from server: $e');
      }
    } catch (e) {
      _logger.severe('Failed to delete session: $e');
    }
  }

  Future<void> syncWithServer() async {
    try {
      await _syncWithServer();
    } catch (e) {
      _logger.severe('Failed to sync with server: $e');
    }
  }

  Future<void> _saveSessionToServer(SessionRecord session) async {
    await _supabase.from('sessions').insert(session.toMap());
  }

  Future<void> _updateSessionOnServer(SessionRecord session) async {
    await _supabase
        .from('sessions')
        .update(session.toMap())
        .eq('id', session.id);
  }

  Future<void> _syncWithServer() async {
    try {
      final userId = _supabase.auth.currentSession?.user.id;
      if (userId == null) return;

      // Fetch sessions from server
      final response = await _supabase
          .from('sessions')
          .select()
          .eq('user_id', userId)
          .order('started_at', ascending: false)
          .limit(100);

      final serverSessions = (response as List)
          .map((json) => SessionRecord.fromMap(json))
          .toList();

      // Merge with local sessions
      _mergeServerSessions(serverSessions);

      // Upload pending sessions
      await _uploadPendingSessions();
    } catch (e) {
      _logger.warning('Failed to sync with server: $e');
    }
  }

  void _mergeServerSessions(List<SessionRecord> serverSessions) {
    // Create a map of server sessions by ID
    final serverSessionMap = {
      for (var session in serverSessions) session.id: session,
    };

    // Update or add server sessions
    for (int i = 0; i < _localSessions.length; i++) {
      final localSession = _localSessions[i];
      final serverSession = serverSessionMap[localSession.id];

      if (serverSession != null &&
          serverSession.lastUpdatedAt != null &&
          localSession.lastUpdatedAt != null &&
          serverSession.lastUpdatedAt!.isAfter(localSession.lastUpdatedAt!)) {
        _localSessions[i] = serverSession;
      }
    }

    // Add new sessions from server that don't exist locally
    for (final serverSession in serverSessions) {
      if (!_localSessions.any((local) => local.id == serverSession.id)) {
        _localSessions.add(serverSession);
      }
    }

    // Sort and update stream
    _localSessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    _sessionsController.add(List.from(_localSessions));
    _saveLocalSessions();
  }

  Future<void> _uploadPendingSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingSessionIds = prefs.getStringList('pending_sessions') ?? [];

    for (final sessionId in pendingSessionIds) {
      final session = _localSessions
          .where((s) => s.id == sessionId)
          .firstOrNull;
      if (session != null) {
        try {
          await _saveSessionToServer(session);
          await _removeSessionFromPendingSync(sessionId);
        } catch (e) {
          _logger.warning('Failed to upload pending session $sessionId: $e');
        }
      }
    }
  }

  Future<void> _markSessionForSync(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingSessions = prefs.getStringList('pending_sessions') ?? [];
    if (!pendingSessions.contains(sessionId)) {
      pendingSessions.add(sessionId);
      await prefs.setStringList('pending_sessions', pendingSessions);
    }
  }

  Future<void> _removeSessionFromPendingSync(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingSessions = prefs.getStringList('pending_sessions') ?? [];
    pendingSessions.remove(sessionId);
    await prefs.setStringList('pending_sessions', pendingSessions);
  }

  Future<void> _saveLocalSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = _localSessions.map((s) => s.toMap()).toList();
      await prefs.setString('local_sessions', jsonEncode(sessionsJson));
    } catch (e) {
      _logger.warning('Failed to save local sessions: $e');
    }
  }

  Future<void> _loadLocalSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = prefs.getString('local_sessions');

      if (sessionsJson != null && sessionsJson.isNotEmpty) {
        final decoded = _jsonDecode(sessionsJson);
        if (decoded is List) {
          _localSessions = decoded
              .whereType<Map<String, dynamic>>()
              .map((json) => SessionRecord.fromMap(json))
              .toList();
          _sessionsController.add(List.from(_localSessions));
        }
      }
    } catch (e) {
      _logger.warning('Failed to load local sessions: $e');
      _localSessions = [];
    }
  }

  dynamic _jsonDecode(String source) {
    try {
      return jsonDecode(source);
    } catch (_) {
      return null;
    }
  }

  Future<int> _calculateCurrentStreak() async {
    // Calculate current streak of consecutive days with sessions
    final now = DateTime.now();
    var streak = 0;
    var currentDate = now;

    while (true) {
      final dayStart = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );
      final dayEnd = dayStart.add(const Duration(days: 1));

      final hasSessionOnDay = _localSessions.any(
        (session) =>
            session.startedAt.isAfter(dayStart) &&
            session.startedAt.isBefore(dayEnd) &&
            session.completed == true,
      );

      if (hasSessionOnDay) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<int> _calculateLongestStreak() async {
    // Calculate longest streak in history
    var longestStreak = 0;
    var currentStreak = 0;

    final sortedSessions = List<SessionRecord>.from(_localSessions)
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));

    DateTime? lastSessionDate;

    for (final session in sortedSessions) {
      if (!session.completed!) continue;

      final sessionDate = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );

      if (lastSessionDate == null) {
        currentStreak = 1;
      } else {
        final daysDiff = sessionDate.difference(lastSessionDate).inDays;
        if (daysDiff == 1) {
          currentStreak++;
        } else if (daysDiff > 1) {
          longestStreak = longestStreak > currentStreak
              ? longestStreak
              : currentStreak;
          currentStreak = 1;
        }
      }

      lastSessionDate = sessionDate;
    }

    return longestStreak > currentStreak ? longestStreak : currentStreak;
  }

  void dispose() {
    _sessionsController.close();
  }
}

class SessionStats {
  final int totalSessions;
  final Duration totalDuration;
  final Duration averageSessionLength;
  final Map<BrainwaveBand, int> sessionsByBrainwaveBand;
  final int currentStreak;
  final int longestStreak;

  const SessionStats({
    required this.totalSessions,
    required this.totalDuration,
    required this.averageSessionLength,
    required this.sessionsByBrainwaveBand,
    required this.currentStreak,
    required this.longestStreak,
  });

  static SessionStats empty() => const SessionStats(
    totalSessions: 0,
    totalDuration: Duration.zero,
    averageSessionLength: Duration.zero,
    sessionsByBrainwaveBand: {},
    currentStreak: 0,
    longestStreak: 0,
  );
}
