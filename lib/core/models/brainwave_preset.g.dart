// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brainwave_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BrainwavePreset _$BrainwavePresetFromJson(Map<String, dynamic> json) =>
    _BrainwavePreset(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      band: $enumDecode(_$BrainwaveBandEnumMap, json['band']),
      beatFrequency: (json['beatFrequency'] as num).toDouble(),
      defaultCarrierFrequency:
          (json['defaultCarrierFrequency'] as num?)?.toDouble() ?? 250.0,
      minCarrierFrequency:
          (json['minCarrierFrequency'] as num?)?.toDouble() ?? 100.0,
      maxCarrierFrequency:
          (json['maxCarrierFrequency'] as num?)?.toDouble() ?? 500.0,
      iconPath: json['iconPath'] as String,
      accentColorValue: (json['accentColorValue'] as num).toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      defaultDuration: json['defaultDuration'] == null
          ? const Duration(minutes: 15)
          : Duration(microseconds: (json['defaultDuration'] as num).toInt()),
      isPremium: json['isPremium'] as bool? ?? false,
      defaultVolume: (json['defaultVolume'] as num?)?.toDouble() ?? 0.8,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BrainwavePresetToJson(_BrainwavePreset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'band': _$BrainwaveBandEnumMap[instance.band]!,
      'beatFrequency': instance.beatFrequency,
      'defaultCarrierFrequency': instance.defaultCarrierFrequency,
      'minCarrierFrequency': instance.minCarrierFrequency,
      'maxCarrierFrequency': instance.maxCarrierFrequency,
      'iconPath': instance.iconPath,
      'accentColorValue': instance.accentColorValue,
      'tags': instance.tags,
      'defaultDuration': instance.defaultDuration.inMicroseconds,
      'isPremium': instance.isPremium,
      'defaultVolume': instance.defaultVolume,
      'metadata': instance.metadata,
    };

const _$BrainwaveBandEnumMap = {
  BrainwaveBand.delta: 'delta',
  BrainwaveBand.theta: 'theta',
  BrainwaveBand.alpha: 'alpha',
  BrainwaveBand.beta: 'beta',
  BrainwaveBand.gamma: 'gamma',
};
