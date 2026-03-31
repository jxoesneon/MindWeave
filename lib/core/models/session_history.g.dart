// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionHistory _$SessionHistoryFromJson(Map<String, dynamic> json) =>
    _SessionHistory(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String,
      startedAt: DateTime.parse(json['started_at'] as String? ?? json['startedAt'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String? ?? json['endedAt'] as String),
      durationSeconds: (json['duration_seconds'] as num?)?.toInt() ?? (json['durationSeconds'] as num).toInt(),
      presetId: json['preset_id'] as String? ?? json['presetId'] as String?,
      presetName: json['preset_name'] as String? ?? json['presetName'] as String?,
      beatFrequency: (json['beat_frequency'] as num?)?.toDouble() ?? (json['beatFrequency'] as num).toDouble(),
      carrierFrequency: (json['carrier_frequency'] as num?)?.toDouble() ?? (json['carrierFrequency'] as num).toDouble(),
      volumeLevel: (json['volume_level'] as num?)?.toDouble() ?? (json['volumeLevel'] as num).toDouble(),
      completed: json['completed'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
    );

Map<String, dynamic> _$SessionHistoryToJson(_SessionHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt.toIso8601String(),
      'duration_seconds': instance.durationSeconds,
      'preset_id': instance.presetId,
      'preset_name': instance.presetName,
      'beat_frequency': instance.beatFrequency,
      'carrier_frequency': instance.carrierFrequency,
      'volume_level': instance.volumeLevel,
      'completed': instance.completed,
      'created_at': instance.createdAt?.toIso8601String(),
    };
