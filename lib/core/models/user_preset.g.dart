// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreset _$UserPresetFromJson(Map<String, dynamic> json) => _UserPreset(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  carrierFrequency: (json['carrier_frequency'] as num).toDouble(),
  beatFrequency: (json['beat_frequency'] as num).toDouble(),
  noiseType:
      $enumDecodeNullable(_$NoiseTypeEnumMap, json['noise_type']) ??
      NoiseType.none,
  noiseVolume: (json['noise_volume'] as num?)?.toDouble() ?? 0.2,
  binauralVolume: (json['binaural_volume'] as num?)?.toDouble() ?? 1.0,
  isPublic: json['is_public'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserPresetToJson(_UserPreset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'carrier_frequency': instance.carrierFrequency,
      'beat_frequency': instance.beatFrequency,
      'noise_type': _$NoiseTypeEnumMap[instance.noiseType]!,
      'noise_volume': instance.noiseVolume,
      'binaural_volume': instance.binauralVolume,
      'is_public': instance.isPublic,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$NoiseTypeEnumMap = {
  NoiseType.none: 'none',
  NoiseType.white: 'white',
  NoiseType.pink: 'pink',
  NoiseType.brown: 'brown',
};
