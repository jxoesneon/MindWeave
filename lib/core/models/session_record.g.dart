// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionRecord _$SessionRecordFromJson(Map<String, dynamic> json) =>
    _SessionRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String,
      presetId: json['preset_id'] as String? ?? json['presetId'] as String,
      presetName: json['preset_name'] as String? ?? json['presetName'] as String,
      brainwaveBand: $enumDecode(_$BrainwaveBandEnumMap, json['brainwave_band'] ?? json['brainwaveBand']),
      beatFrequency: (json['beat_frequency'] as num?)?.toDouble() ?? (json['beatFrequency'] as num).toDouble(),
      carrierFrequency: (json['carrier_frequency'] as num?)?.toDouble() ?? (json['carrierFrequency'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      startedAt: DateTime.parse(json['started_at'] as String? ?? json['startedAt'] as String),
      targetDuration: Duration(microseconds: (json['target_duration'] as num?)?.toInt() ?? (json['targetDuration'] as num?)?.toInt() ?? 0),
      status: $enumDecodeNullable(_$SessionStatusEnumMap, json['status']) ?? SessionStatus.active,
      endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at'] as String) : json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
      currentDuration: json['current_duration'] != null ? Duration(microseconds: (json['current_duration'] as num).toInt()) : json['currentDuration'] != null ? Duration(microseconds: (json['currentDuration'] as num).toInt()) : null,
      actualDuration: json['actual_duration'] != null ? Duration(microseconds: (json['actual_duration'] as num).toInt()) : json['actualDuration'] != null ? Duration(microseconds: (json['actualDuration'] as num).toInt()) : null,
      currentVolume: (json['current_volume'] as num?)?.toDouble() ?? (json['currentVolume'] as num?)?.toDouble(),
      completed: json['completed'] as bool? ?? false,
      notes: json['notes'] as String?,
      isLocalOnly: json['is_local_only'] as bool? ?? json['isLocalOnly'] as bool? ?? false,
      needsSync: json['needs_sync'] as bool? ?? json['needsSync'] as bool? ?? false,
      lastUpdatedAt: json['last_updated_at'] != null ? DateTime.parse(json['last_updated_at'] as String) : json['lastUpdatedAt'] != null ? DateTime.parse(json['lastUpdatedAt'] as String) : null,
      metadata: (json['metadata'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$SessionRecordToJson(_SessionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'preset_id': instance.presetId,
      'preset_name': instance.presetName,
      'brainwave_band': _$BrainwaveBandEnumMap[instance.brainwaveBand]!,
      'beat_frequency': instance.beatFrequency,
      'carrier_frequency': instance.carrierFrequency,
      'volume': instance.volume,
      'started_at': instance.startedAt.toIso8601String(),
      'target_duration': instance.targetDuration.inMicroseconds,
      'status': _$SessionStatusEnumMap[instance.status]!,
      'ended_at': instance.endedAt?.toIso8601String(),
      'current_duration': instance.currentDuration?.inMicroseconds,
      'actual_duration': instance.actualDuration?.inMicroseconds,
      'current_volume': instance.currentVolume,
      'completed': instance.completed,
      'notes': instance.notes,
      'is_local_only': instance.isLocalOnly,
      'needs_sync': instance.needsSync,
      'last_updated_at': instance.lastUpdatedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$BrainwaveBandEnumMap = {
  BrainwaveBand.delta: 'delta',
  BrainwaveBand.theta: 'theta',
  BrainwaveBand.alpha: 'alpha',
  BrainwaveBand.beta: 'beta',
  BrainwaveBand.gamma: 'gamma',
};

const _$SessionStatusEnumMap = {
  SessionStatus.active: 'active',
  SessionStatus.paused: 'paused',
  SessionStatus.completed: 'completed',
  SessionStatus.cancelled: 'cancelled',
};
