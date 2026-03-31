// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionRecord {
 String get id; String get userId; String get presetId; String get presetName; BrainwaveBand get brainwaveBand; double get beatFrequency; double get carrierFrequency; double get volume; DateTime get startedAt; Duration get targetDuration; SessionStatus get status; DateTime? get endedAt; Duration? get currentDuration; Duration? get actualDuration; double? get currentVolume; bool? get completed; String? get notes; bool get isLocalOnly; bool get needsSync; DateTime? get lastUpdatedAt; Map<String, dynamic>? get metadata;

@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionRecordCopyWith<SessionRecord> get copyWith => _$SessionRecordCopyWithImpl<SessionRecord>(this as SessionRecord, _$identity);

  Map<String, dynamic> toJson();

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.presetId, presetId) || other.presetId == presetId)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.brainwaveBand, brainwaveBand) || other.brainwaveBand == brainwaveBand)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.targetDuration, targetDuration) || other.targetDuration == targetDuration)&&(identical(other.status, status) || other.status == status)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.currentDuration, currentDuration) || other.currentDuration == currentDuration)&&(identical(other.actualDuration, actualDuration) || other.actualDuration == actualDuration)&&(identical(other.currentVolume, currentVolume) || other.currentVolume == currentVolume)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isLocalOnly, isLocalOnly) || other.isLocalOnly == isLocalOnly)&&(identical(other.needsSync, needsSync) || other.needsSync == needsSync)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,presetId,presetName,brainwaveBand,beatFrequency,carrierFrequency,volume,startedAt,targetDuration,status,endedAt,currentDuration,actualDuration,currentVolume,completed,notes,isLocalOnly,needsSync,lastUpdatedAt,const DeepCollectionEquality().hash(metadata)]);

@override
String toString() {
  return 'SessionRecord(id: $id, userId: $userId, presetId: $presetId, presetName: $presetName, brainwaveBand: $brainwaveBand, beatFrequency: $beatFrequency, carrierFrequency: $carrierFrequency, volume: $volume, startedAt: $startedAt, targetDuration: $targetDuration, status: $status, endedAt: $endedAt, currentDuration: $currentDuration, actualDuration: $actualDuration, currentVolume: $currentVolume, completed: $completed, notes: $notes, isLocalOnly: $isLocalOnly, needsSync: $needsSync, lastUpdatedAt: $lastUpdatedAt, metadata: $metadata)';
}
}

/// @nodoc
abstract mixin class $SessionRecordCopyWith<$Res> {
  factory $SessionRecordCopyWith(SessionRecord value, $Res Function(SessionRecord) _then) = _$SessionRecordCopyWithImpl;
@useResult
$Res call({String id, String userId, String presetId, String presetName, BrainwaveBand brainwaveBand, double beatFrequency, double carrierFrequency, double volume, DateTime startedAt, Duration targetDuration, SessionStatus status, DateTime? endedAt, Duration? currentDuration, Duration? actualDuration, double? currentVolume, bool? completed, String? notes, bool isLocalOnly, bool needsSync, DateTime? lastUpdatedAt, Map<String, dynamic>? metadata});
}

/// @nodoc
class _$SessionRecordCopyWithImpl<$Res> implements $SessionRecordCopyWith<$Res> {
  _$SessionRecordCopyWithImpl(this._self, this._then);
  final SessionRecord _self;
  final $Res Function(SessionRecord) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null, Object? userId = null, Object? presetId = null, Object? presetName = null, Object? brainwaveBand = null, Object? beatFrequency = null, Object? carrierFrequency = null, Object? volume = null, Object? startedAt = null, Object? targetDuration = null, Object? status = null, Object? endedAt = freezed, Object? currentDuration = freezed, Object? actualDuration = freezed, Object? currentVolume = freezed, Object? completed = freezed, Object? notes = freezed, Object? isLocalOnly = null, Object? needsSync = null, Object? lastUpdatedAt = freezed, Object? metadata = freezed}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id as String,
userId: null == userId ? _self.userId : userId as String,
presetId: null == presetId ? _self.presetId : presetId as String,
presetName: null == presetName ? _self.presetName : presetName as String,
brainwaveBand: null == brainwaveBand ? _self.brainwaveBand : brainwaveBand as BrainwaveBand,
beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency as double,
carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency as double,
volume: null == volume ? _self.volume : volume as double,
startedAt: null == startedAt ? _self.startedAt : startedAt as DateTime,
targetDuration: null == targetDuration ? _self.targetDuration : targetDuration as Duration,
status: null == status ? _self.status : status as SessionStatus,
endedAt: freezed == endedAt ? _self.endedAt : endedAt as DateTime?,
currentDuration: freezed == currentDuration ? _self.currentDuration : currentDuration as Duration?,
actualDuration: freezed == actualDuration ? _self.actualDuration : actualDuration as Duration?,
currentVolume: freezed == currentVolume ? _self.currentVolume : currentVolume as double?,
completed: freezed == completed ? _self.completed : completed as bool?,
notes: freezed == notes ? _self.notes : notes as String?,
isLocalOnly: null == isLocalOnly ? _self.isLocalOnly : isLocalOnly as bool,
needsSync: null == needsSync ? _self.needsSync : needsSync as bool,
lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt as DateTime?,
metadata: freezed == metadata ? _self.metadata : metadata as Map<String, dynamic>?,
  ));
}
}

/// @nodoc
@JsonSerializable()
class _SessionRecord extends SessionRecord {
  const _SessionRecord({required this.id, required this.userId, required this.presetId, required this.presetName, required this.brainwaveBand, required this.beatFrequency, required this.carrierFrequency, required this.volume, required this.startedAt, required this.targetDuration, this.status = SessionStatus.active, this.endedAt, this.currentDuration, this.actualDuration, this.currentVolume, this.completed = false, this.notes, this.isLocalOnly = false, this.needsSync = false, this.lastUpdatedAt, this.metadata}) : super._();
  factory _SessionRecord.fromJson(Map<String, dynamic> json) => _$SessionRecordFromJson(json);

@override final String id;
@override final String userId;
@override final String presetId;
@override final String presetName;
@override final BrainwaveBand brainwaveBand;
@override final double beatFrequency;
@override final double carrierFrequency;
@override final double volume;
@override final DateTime startedAt;
@override final Duration targetDuration;
@override@JsonKey() final SessionStatus status;
@override final DateTime? endedAt;
@override final Duration? currentDuration;
@override final Duration? actualDuration;
@override final double? currentVolume;
@override@JsonKey() final bool? completed;
@override final String? notes;
@override@JsonKey() final bool isLocalOnly;
@override@JsonKey() final bool needsSync;
@override final DateTime? lastUpdatedAt;
@override final Map<String, dynamic>? metadata;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionRecordCopyWith<_SessionRecord> get copyWith => __$SessionRecordCopyWithImpl<_SessionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionRecordToJson(this);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.presetId, presetId) || other.presetId == presetId)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.brainwaveBand, brainwaveBand) || other.brainwaveBand == brainwaveBand)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.targetDuration, targetDuration) || other.targetDuration == targetDuration)&&(identical(other.status, status) || other.status == status)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.currentDuration, currentDuration) || other.currentDuration == currentDuration)&&(identical(other.actualDuration, actualDuration) || other.actualDuration == actualDuration)&&(identical(other.currentVolume, currentVolume) || other.currentVolume == currentVolume)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isLocalOnly, isLocalOnly) || other.isLocalOnly == isLocalOnly)&&(identical(other.needsSync, needsSync) || other.needsSync == needsSync)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,presetId,presetName,brainwaveBand,beatFrequency,carrierFrequency,volume,startedAt,targetDuration,status,endedAt,currentDuration,actualDuration,currentVolume,completed,notes,isLocalOnly,needsSync,lastUpdatedAt,const DeepCollectionEquality().hash(metadata)]);

@override
String toString() {
  return 'SessionRecord(id: $id, userId: $userId, presetId: $presetId, presetName: $presetName, brainwaveBand: $brainwaveBand, beatFrequency: $beatFrequency, carrierFrequency: $carrierFrequency, volume: $volume, startedAt: $startedAt, targetDuration: $targetDuration, status: $status, endedAt: $endedAt, currentDuration: $currentDuration, actualDuration: $actualDuration, currentVolume: $currentVolume, completed: $completed, notes: $notes, isLocalOnly: $isLocalOnly, needsSync: $needsSync, lastUpdatedAt: $lastUpdatedAt, metadata: $metadata)';
}
}

/// @nodoc
abstract mixin class _$SessionRecordCopyWith<$Res> implements $SessionRecordCopyWith<$Res> {
  factory _$SessionRecordCopyWith(_SessionRecord value, $Res Function(_SessionRecord) _then) = __$SessionRecordCopyWithImpl;
@override @useResult
$Res call({String id, String userId, String presetId, String presetName, BrainwaveBand brainwaveBand, double beatFrequency, double carrierFrequency, double volume, DateTime startedAt, Duration targetDuration, SessionStatus status, DateTime? endedAt, Duration? currentDuration, Duration? actualDuration, double? currentVolume, bool? completed, String? notes, bool isLocalOnly, bool needsSync, DateTime? lastUpdatedAt, Map<String, dynamic>? metadata});
}

/// @nodoc
class __$SessionRecordCopyWithImpl<$Res> implements _$SessionRecordCopyWith<$Res> {
  __$SessionRecordCopyWithImpl(this._self, this._then);
  final _SessionRecord _self;
  final $Res Function(_SessionRecord) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null, Object? userId = null, Object? presetId = null, Object? presetName = null, Object? brainwaveBand = null, Object? beatFrequency = null, Object? carrierFrequency = null, Object? volume = null, Object? startedAt = null, Object? targetDuration = null, Object? status = null, Object? endedAt = freezed, Object? currentDuration = freezed, Object? actualDuration = freezed, Object? currentVolume = freezed, Object? completed = freezed, Object? notes = freezed, Object? isLocalOnly = null, Object? needsSync = null, Object? lastUpdatedAt = freezed, Object? metadata = freezed}) {
  return _then(_SessionRecord(
id: null == id ? _self.id : id as String,
userId: null == userId ? _self.userId : userId as String,
presetId: null == presetId ? _self.presetId : presetId as String,
presetName: null == presetName ? _self.presetName : presetName as String,
brainwaveBand: null == brainwaveBand ? _self.brainwaveBand : brainwaveBand as BrainwaveBand,
beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency as double,
carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency as double,
volume: null == volume ? _self.volume : volume as double,
startedAt: null == startedAt ? _self.startedAt : startedAt as DateTime,
targetDuration: null == targetDuration ? _self.targetDuration : targetDuration as Duration,
status: null == status ? _self.status : status as SessionStatus,
endedAt: freezed == endedAt ? _self.endedAt : endedAt as DateTime?,
currentDuration: freezed == currentDuration ? _self.currentDuration : currentDuration as Duration?,
actualDuration: freezed == actualDuration ? _self.actualDuration : actualDuration as Duration?,
currentVolume: freezed == currentVolume ? _self.currentVolume : currentVolume as double?,
completed: freezed == completed ? _self.completed : completed as bool?,
notes: freezed == notes ? _self.notes : notes as String?,
isLocalOnly: null == isLocalOnly ? _self.isLocalOnly : isLocalOnly as bool,
needsSync: null == needsSync ? _self.needsSync : needsSync as bool,
lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt as DateTime?,
metadata: freezed == metadata ? _self.metadata : metadata as Map<String, dynamic>?,
  ));
}
}

// dart format on
