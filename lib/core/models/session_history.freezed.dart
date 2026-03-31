// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionHistory {
 String get id; String get userId; DateTime get startedAt; DateTime get endedAt; int get durationSeconds; String? get presetId; String? get presetName; double get beatFrequency; double get carrierFrequency; double get volumeLevel; bool get completed; DateTime? get createdAt;

@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionHistoryCopyWith<SessionHistory> get copyWith => _$SessionHistoryCopyWithImpl<SessionHistory>(this as SessionHistory, _$identity);

  Map<String, dynamic> toJson();

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.presetId, presetId) || other.presetId == presetId)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.volumeLevel, volumeLevel) || other.volumeLevel == volumeLevel)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startedAt,endedAt,durationSeconds,presetId,presetName,beatFrequency,carrierFrequency,volumeLevel,completed,createdAt);

@override
String toString() {
  return 'SessionHistory(id: $id, userId: $userId, startedAt: $startedAt, endedAt: $endedAt, durationSeconds: $durationSeconds, presetId: $presetId, presetName: $presetName, beatFrequency: $beatFrequency, carrierFrequency: $carrierFrequency, volumeLevel: $volumeLevel, completed: $completed, createdAt: $createdAt)';
}
}

/// @nodoc
abstract mixin class $SessionHistoryCopyWith<$Res> {
  factory $SessionHistoryCopyWith(SessionHistory value, $Res Function(SessionHistory) _then) = _$SessionHistoryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime startedAt, DateTime endedAt, int durationSeconds, String? presetId, String? presetName, double beatFrequency, double carrierFrequency, double volumeLevel, bool completed, DateTime? createdAt
});
}

/// @nodoc
class _$SessionHistoryCopyWithImpl<$Res> implements $SessionHistoryCopyWith<$Res> {
  _$SessionHistoryCopyWithImpl(this._self, this._then);
  final SessionHistory _self;
  final $Res Function(SessionHistory) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? startedAt = null,Object? endedAt = null,Object? durationSeconds = null,Object? presetId = freezed,Object? presetName = freezed,Object? beatFrequency = null,Object? carrierFrequency = null,Object? volumeLevel = null,Object? completed = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id as String,
userId: null == userId ? _self.userId : userId as String,
startedAt: null == startedAt ? _self.startedAt : startedAt as DateTime,
endedAt: null == endedAt ? _self.endedAt : endedAt as DateTime,
durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds as int,
presetId: freezed == presetId ? _self.presetId : presetId as String?,
presetName: freezed == presetName ? _self.presetName : presetName as String?,
beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency as double,
carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency as double,
volumeLevel: null == volumeLevel ? _self.volumeLevel : volumeLevel as double,
completed: null == completed ? _self.completed : completed as bool,
createdAt: freezed == createdAt ? _self.createdAt : createdAt as DateTime?,
  ));
}
}

/// @nodoc
@JsonSerializable()
class _SessionHistory extends SessionHistory {
  const _SessionHistory({required this.id, required this.userId, required this.startedAt, required this.endedAt, required this.durationSeconds, this.presetId, this.presetName, required this.beatFrequency, required this.carrierFrequency, required this.volumeLevel, this.completed = true, this.createdAt}) : super._();
  factory _SessionHistory.fromJson(Map<String, dynamic> json) => _$SessionHistoryFromJson(json);

@override final String id;
@override final String userId;
@override final DateTime startedAt;
@override final DateTime endedAt;
@override final int durationSeconds;
@override final String? presetId;
@override final String? presetName;
@override final double beatFrequency;
@override final double carrierFrequency;
@override final double volumeLevel;
@override@JsonKey() final bool completed;
@override final DateTime? createdAt;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionHistoryCopyWith<_SessionHistory> get copyWith => __$SessionHistoryCopyWithImpl<_SessionHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionHistoryToJson(this);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.presetId, presetId) || other.presetId == presetId)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.volumeLevel, volumeLevel) || other.volumeLevel == volumeLevel)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startedAt,endedAt,durationSeconds,presetId,presetName,beatFrequency,carrierFrequency,volumeLevel,completed,createdAt);

@override
String toString() {
  return 'SessionHistory(id: $id, userId: $userId, startedAt: $startedAt, endedAt: $endedAt, durationSeconds: $durationSeconds, presetId: $presetId, presetName: $presetName, beatFrequency: $beatFrequency, carrierFrequency: $carrierFrequency, volumeLevel: $volumeLevel, completed: $completed, createdAt: $createdAt)';
}
}

/// @nodoc
abstract mixin class _$SessionHistoryCopyWith<$Res> implements $SessionHistoryCopyWith<$Res> {
  factory _$SessionHistoryCopyWith(_SessionHistory value, $Res Function(_SessionHistory) _then) = __$SessionHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime startedAt, DateTime endedAt, int durationSeconds, String? presetId, String? presetName, double beatFrequency, double carrierFrequency, double volumeLevel, bool completed, DateTime? createdAt
});
}

/// @nodoc
class __$SessionHistoryCopyWithImpl<$Res> implements _$SessionHistoryCopyWith<$Res> {
  __$SessionHistoryCopyWithImpl(this._self, this._then);
  final _SessionHistory _self;
  final $Res Function(_SessionHistory) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? startedAt = null,Object? endedAt = null,Object? durationSeconds = null,Object? presetId = freezed,Object? presetName = freezed,Object? beatFrequency = null,Object? carrierFrequency = null,Object? volumeLevel = null,Object? completed = null,Object? createdAt = freezed,}) {
  return _then(_SessionHistory(
id: null == id ? _self.id : id as String,
userId: null == userId ? _self.userId : userId as String,
startedAt: null == startedAt ? _self.startedAt : startedAt as DateTime,
endedAt: null == endedAt ? _self.endedAt : endedAt as DateTime,
durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds as int,
presetId: freezed == presetId ? _self.presetId : presetId as String?,
presetName: freezed == presetName ? _self.presetName : presetName as String?,
beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency as double,
carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency as double,
volumeLevel: null == volumeLevel ? _self.volumeLevel : volumeLevel as double,
completed: null == completed ? _self.completed : completed as bool,
createdAt: freezed == createdAt ? _self.createdAt : createdAt as DateTime?,
  ));
}
}

/// @nodoc
mixin _$SessionStatistics {
 int get totalSessions; int get totalMinutes; double get averageSessionMinutes; String? get mostUsedPreset; Map<String, int> get presetUsageCounts;

@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStatisticsCopyWith<SessionStatistics> get copyWith => _$SessionStatisticsCopyWithImpl<SessionStatistics>(this as SessionStatistics, _$identity);

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStatistics&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.averageSessionMinutes, averageSessionMinutes) || other.averageSessionMinutes == averageSessionMinutes)&&(identical(other.mostUsedPreset, mostUsedPreset) || other.mostUsedPreset == mostUsedPreset)&&const DeepCollectionEquality().equals(other.presetUsageCounts, presetUsageCounts));
}

@override
int get hashCode => Object.hash(runtimeType,totalSessions,totalMinutes,averageSessionMinutes,mostUsedPreset,const DeepCollectionEquality().hash(presetUsageCounts));

@override
String toString() {
  return 'SessionStatistics(totalSessions: $totalSessions, totalMinutes: $totalMinutes, averageSessionMinutes: $averageSessionMinutes, mostUsedPreset: $mostUsedPreset, presetUsageCounts: $presetUsageCounts)';
}
}

/// @nodoc
abstract mixin class $SessionStatisticsCopyWith<$Res> {
  factory $SessionStatisticsCopyWith(SessionStatistics value, $Res Function(SessionStatistics) _then) = _$SessionStatisticsCopyWithImpl;
@useResult
$Res call({int totalSessions, int totalMinutes, double averageSessionMinutes, String? mostUsedPreset, Map<String, int> presetUsageCounts});
}

/// @nodoc
class _$SessionStatisticsCopyWithImpl<$Res> implements $SessionStatisticsCopyWith<$Res> {
  _$SessionStatisticsCopyWithImpl(this._self, this._then);
  final SessionStatistics _self;
  final $Res Function(SessionStatistics) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? totalSessions = null,Object? totalMinutes = null,Object? averageSessionMinutes = null,Object? mostUsedPreset = freezed,Object? presetUsageCounts = null,}) {
  return _then(_self.copyWith(
totalSessions: null == totalSessions ? _self.totalSessions : totalSessions as int,
totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes as int,
averageSessionMinutes: null == averageSessionMinutes ? _self.averageSessionMinutes : averageSessionMinutes as double,
mostUsedPreset: freezed == mostUsedPreset ? _self.mostUsedPreset : mostUsedPreset as String?,
presetUsageCounts: null == presetUsageCounts ? _self.presetUsageCounts : presetUsageCounts as Map<String, int>,
  ));
}
}

/// @nodoc
class _SessionStatistics implements SessionStatistics {
  const _SessionStatistics({required this.totalSessions, required this.totalMinutes, required this.averageSessionMinutes, this.mostUsedPreset, required final Map<String, int> presetUsageCounts}): _presetUsageCounts = presetUsageCounts;

@override final int totalSessions;
@override final int totalMinutes;
@override final double averageSessionMinutes;
@override final String? mostUsedPreset;
final Map<String, int> _presetUsageCounts;
@override Map<String, int> get presetUsageCounts {
  if (_presetUsageCounts is EqualUnmodifiableMapView) return _presetUsageCounts;
  return EqualUnmodifiableMapView(_presetUsageCounts);
}

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStatisticsCopyWith<_SessionStatistics> get copyWith => __$SessionStatisticsCopyWithImpl<_SessionStatistics>(this, _$identity);

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionStatistics&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.averageSessionMinutes, averageSessionMinutes) || other.averageSessionMinutes == averageSessionMinutes)&&(identical(other.mostUsedPreset, mostUsedPreset) || other.mostUsedPreset == mostUsedPreset)&&const DeepCollectionEquality().equals(other._presetUsageCounts, _presetUsageCounts));
}

@override
int get hashCode => Object.hash(runtimeType,totalSessions,totalMinutes,averageSessionMinutes,mostUsedPreset,const DeepCollectionEquality().hash(_presetUsageCounts));

@override
String toString() {
  return 'SessionStatistics(totalSessions: $totalSessions, totalMinutes: $totalMinutes, averageSessionMinutes: $averageSessionMinutes, mostUsedPreset: $mostUsedPreset, presetUsageCounts: $presetUsageCounts)';
}
}

/// @nodoc
abstract mixin class _$SessionStatisticsCopyWith<$Res> implements $SessionStatisticsCopyWith<$Res> {
  factory _$SessionStatisticsCopyWith(_SessionStatistics value, $Res Function(_SessionStatistics) _then) = __$SessionStatisticsCopyWithImpl;
@override @useResult
$Res call({int totalSessions, int totalMinutes, double averageSessionMinutes, String? mostUsedPreset, Map<String, int> presetUsageCounts});
}

/// @nodoc
class __$SessionStatisticsCopyWithImpl<$Res> implements _$SessionStatisticsCopyWith<$Res> {
  __$SessionStatisticsCopyWithImpl(this._self, this._then);
  final _SessionStatistics _self;
  final $Res Function(_SessionStatistics) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? totalSessions = null,Object? totalMinutes = null,Object? averageSessionMinutes = null,Object? mostUsedPreset = freezed,Object? presetUsageCounts = null,}) {
  return _then(_SessionStatistics(
totalSessions: null == totalSessions ? _self.totalSessions : totalSessions as int,
totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes as int,
averageSessionMinutes: null == averageSessionMinutes ? _self.averageSessionMinutes : averageSessionMinutes as double,
mostUsedPreset: freezed == mostUsedPreset ? _self.mostUsedPreset : mostUsedPreset as String?,
presetUsageCounts: null == presetUsageCounts ? _self._presetUsageCounts : presetUsageCounts as Map<String, int>,
  ));
}
}

// dart format on
