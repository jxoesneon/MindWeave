import 'package:freezed_annotation/freezed_annotation.dart';
import 'brainwave_preset.dart';

part 'session_record.freezed.dart';
part 'session_record.g.dart';

@freezed
abstract class SessionRecord with _$SessionRecord {
  const factory SessionRecord({
    required String id,
    required String userId,
    required String presetId,
    required String presetName,
    required BrainwaveBand brainwaveBand,
    required double beatFrequency,
    required double carrierFrequency,
    required double volume,
    required DateTime startedAt,
    required Duration targetDuration,
    @Default(SessionStatus.active) SessionStatus status,
    DateTime? endedAt,
    Duration? currentDuration,
    Duration? actualDuration,
    double? currentVolume,
    @Default(false) bool? completed,
    String? notes,
    @Default(false) bool isLocalOnly,
    @Default(false) bool needsSync,
    DateTime? lastUpdatedAt,
    Map<String, dynamic>? metadata,
  }) = _SessionRecord;

  factory SessionRecord.fromJson(Map<String, dynamic> json) =>
      _$SessionRecordFromJson(json);

  const SessionRecord._();

  Map<String, dynamic> toMap() {
    return toJson();
  }

  static SessionRecord fromMap(Map<String, dynamic> map) {
    return SessionRecord.fromJson(map);
  }

  bool get isActive => status == SessionStatus.active;
  bool get isCompleted => status == SessionStatus.completed;
  bool get isCancelled => status == SessionStatus.cancelled;
  bool get isPaused => status == SessionStatus.paused;

  Duration? get remainingDuration {
    if (currentDuration == null) return targetDuration;
    final remaining = targetDuration - currentDuration!;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  double get completionPercentage {
    if (currentDuration == null || targetDuration.inSeconds == 0) return 0.0;
    return (currentDuration!.inSeconds / targetDuration.inSeconds).clamp(
      0.0,
      1.0,
    );
  }

  String get formattedDuration {
    final duration = actualDuration ?? currentDuration ?? Duration.zero;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String get formattedStartTime {
    return '${startedAt.hour.toString().padLeft(2, '0')}:${startedAt.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDate {
    return '${startedAt.day}/${startedAt.month}/${startedAt.year}';
  }

  SessionRecord copyWithUpdatedDuration(Duration newDuration) {
    return copyWith(
      currentDuration: newDuration,
      lastUpdatedAt: DateTime.now(),
    );
  }

  SessionRecord copyWithUpdatedVolume(double newVolume) {
    return copyWith(currentVolume: newVolume, lastUpdatedAt: DateTime.now());
  }

  SessionRecord markAsCompleted({Duration? actualDuration, String? notes}) {
    return copyWith(
      status: SessionStatus.completed,
      completed: true,
      endedAt: DateTime.now(),
      actualDuration: actualDuration ?? currentDuration,
      notes: notes,
      lastUpdatedAt: DateTime.now(),
    );
  }

  SessionRecord markAsCancelled({String? reason}) {
    return copyWith(
      status: SessionStatus.cancelled,
      endedAt: DateTime.now(),
      notes: reason,
      lastUpdatedAt: DateTime.now(),
    );
  }

  SessionRecord markAsPaused() {
    return copyWith(
      status: SessionStatus.paused,
      lastUpdatedAt: DateTime.now(),
    );
  }

  SessionRecord markAsResumed() {
    return copyWith(
      status: SessionStatus.active,
      lastUpdatedAt: DateTime.now(),
    );
  }

  SessionRecord markForSync() {
    return copyWith(needsSync: true, lastUpdatedAt: DateTime.now());
  }

  SessionRecord markAsSynced() {
    return copyWith(
      isLocalOnly: false,
      needsSync: false,
      lastUpdatedAt: DateTime.now(),
    );
  }
}

enum SessionStatus { active, paused, completed, cancelled }

extension SessionStatusExtension on SessionStatus {
  String get displayName {
    switch (this) {
      case SessionStatus.active:
        return 'Active';
      case SessionStatus.paused:
        return 'Paused';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case SessionStatus.active:
        return 'Session is currently running';
      case SessionStatus.paused:
        return 'Session is paused';
      case SessionStatus.completed:
        return 'Session completed successfully';
      case SessionStatus.cancelled:
        return 'Session was cancelled';
    }
  }

  bool get isFinalStatus {
    return this == SessionStatus.completed || this == SessionStatus.cancelled;
  }

  bool get canBeEdited {
    return this == SessionStatus.active || this == SessionStatus.paused;
  }
}
