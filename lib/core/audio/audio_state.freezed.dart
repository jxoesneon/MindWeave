// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioState {

 bool get isPlaying; double get carrierFrequency; double get beatFrequency; double get volume; BrainwavePreset? get selectedPreset; Duration? get timerDuration; Duration? get remainingTime;
/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioStateCopyWith<AudioState> get copyWith => _$AudioStateCopyWithImpl<AudioState>(this as AudioState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.selectedPreset, selectedPreset) || other.selectedPreset == selectedPreset)&&(identical(other.timerDuration, timerDuration) || other.timerDuration == timerDuration)&&(identical(other.remainingTime, remainingTime) || other.remainingTime == remainingTime));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,carrierFrequency,beatFrequency,volume,selectedPreset,timerDuration,remainingTime);

@override
String toString() {
  return 'AudioState(isPlaying: $isPlaying, carrierFrequency: $carrierFrequency, beatFrequency: $beatFrequency, volume: $volume, selectedPreset: $selectedPreset, timerDuration: $timerDuration, remainingTime: $remainingTime)';
}


}

/// @nodoc
abstract mixin class $AudioStateCopyWith<$Res>  {
  factory $AudioStateCopyWith(AudioState value, $Res Function(AudioState) _then) = _$AudioStateCopyWithImpl;
@useResult
$Res call({
 bool isPlaying, double carrierFrequency, double beatFrequency, double volume, BrainwavePreset? selectedPreset, Duration? timerDuration, Duration? remainingTime
});


$BrainwavePresetCopyWith<$Res>? get selectedPreset;

}
/// @nodoc
class _$AudioStateCopyWithImpl<$Res>
    implements $AudioStateCopyWith<$Res> {
  _$AudioStateCopyWithImpl(this._self, this._then);

  final AudioState _self;
  final $Res Function(AudioState) _then;

/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPlaying = null,Object? carrierFrequency = null,Object? beatFrequency = null,Object? volume = null,Object? selectedPreset = freezed,Object? timerDuration = freezed,Object? remainingTime = freezed,}) {
  return _then(_self.copyWith(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency // ignore: cast_nullable_to_non_nullable
as double,beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,selectedPreset: freezed == selectedPreset ? _self.selectedPreset : selectedPreset // ignore: cast_nullable_to_non_nullable
as BrainwavePreset?,timerDuration: freezed == timerDuration ? _self.timerDuration : timerDuration // ignore: cast_nullable_to_non_nullable
as Duration?,remainingTime: freezed == remainingTime ? _self.remainingTime : remainingTime // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}
/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrainwavePresetCopyWith<$Res>? get selectedPreset {
    if (_self.selectedPreset == null) {
    return null;
  }

  return $BrainwavePresetCopyWith<$Res>(_self.selectedPreset!, (value) {
    return _then(_self.copyWith(selectedPreset: value));
  });
}
}


/// Adds pattern-matching-related methods to [AudioState].
extension AudioStatePatterns on AudioState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```text

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```text

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioState value)  $default,){
final _that = this;
switch (_that) {
case _AudioState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```text

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioState value)?  $default,){
final _that = this;
switch (_that) {
case _AudioState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```text

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPlaying,  double carrierFrequency,  double beatFrequency,  double volume,  BrainwavePreset? selectedPreset,  Duration? timerDuration,  Duration? remainingTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioState() when $default != null:
return $default(_that.isPlaying,_that.carrierFrequency,_that.beatFrequency,_that.volume,_that.selectedPreset,_that.timerDuration,_that.remainingTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```text

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPlaying,  double carrierFrequency,  double beatFrequency,  double volume,  BrainwavePreset? selectedPreset,  Duration? timerDuration,  Duration? remainingTime)  $default,) {final _that = this;
switch (_that) {
case _AudioState():
return $default(_that.isPlaying,_that.carrierFrequency,_that.beatFrequency,_that.volume,_that.selectedPreset,_that.timerDuration,_that.remainingTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```text

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPlaying,  double carrierFrequency,  double beatFrequency,  double volume,  BrainwavePreset? selectedPreset,  Duration? timerDuration,  Duration? remainingTime)?  $default,) {final _that = this;
switch (_that) {
case _AudioState() when $default != null:
return $default(_that.isPlaying,_that.carrierFrequency,_that.beatFrequency,_that.volume,_that.selectedPreset,_that.timerDuration,_that.remainingTime);case _:
  return null;

}
}

}

/// @nodoc


class _AudioState implements AudioState {
  const _AudioState({required this.isPlaying, required this.carrierFrequency, required this.beatFrequency, required this.volume, this.selectedPreset, this.timerDuration, this.remainingTime});
  

@override final  bool isPlaying;
@override final  double carrierFrequency;
@override final  double beatFrequency;
@override final  double volume;
@override final  BrainwavePreset? selectedPreset;
@override final  Duration? timerDuration;
@override final  Duration? remainingTime;

/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioStateCopyWith<_AudioState> get copyWith => __$AudioStateCopyWithImpl<_AudioState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.selectedPreset, selectedPreset) || other.selectedPreset == selectedPreset)&&(identical(other.timerDuration, timerDuration) || other.timerDuration == timerDuration)&&(identical(other.remainingTime, remainingTime) || other.remainingTime == remainingTime));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,carrierFrequency,beatFrequency,volume,selectedPreset,timerDuration,remainingTime);

@override
String toString() {
  return 'AudioState(isPlaying: $isPlaying, carrierFrequency: $carrierFrequency, beatFrequency: $beatFrequency, volume: $volume, selectedPreset: $selectedPreset, timerDuration: $timerDuration, remainingTime: $remainingTime)';
}


}

/// @nodoc
abstract mixin class _$AudioStateCopyWith<$Res> implements $AudioStateCopyWith<$Res> {
  factory _$AudioStateCopyWith(_AudioState value, $Res Function(_AudioState) _then) = __$AudioStateCopyWithImpl;
@override @useResult
$Res call({
 bool isPlaying, double carrierFrequency, double beatFrequency, double volume, BrainwavePreset? selectedPreset, Duration? timerDuration, Duration? remainingTime
});


@override $BrainwavePresetCopyWith<$Res>? get selectedPreset;

}
/// @nodoc
class __$AudioStateCopyWithImpl<$Res>
    implements _$AudioStateCopyWith<$Res> {
  __$AudioStateCopyWithImpl(this._self, this._then);

  final _AudioState _self;
  final $Res Function(_AudioState) _then;

/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPlaying = null,Object? carrierFrequency = null,Object? beatFrequency = null,Object? volume = null,Object? selectedPreset = freezed,Object? timerDuration = freezed,Object? remainingTime = freezed,}) {
  return _then(_AudioState(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency // ignore: cast_nullable_to_non_nullable
as double,beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,selectedPreset: freezed == selectedPreset ? _self.selectedPreset : selectedPreset // ignore: cast_nullable_to_non_nullable
as BrainwavePreset?,timerDuration: freezed == timerDuration ? _self.timerDuration : timerDuration // ignore: cast_nullable_to_non_nullable
as Duration?,remainingTime: freezed == remainingTime ? _self.remainingTime : remainingTime // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrainwavePresetCopyWith<$Res>? get selectedPreset {
    if (_self.selectedPreset == null) {
    return null;
  }

  return $BrainwavePresetCopyWith<$Res>(_self.selectedPreset!, (value) {
    return _then(_self.copyWith(selectedPreset: value));
  });
}
}

// dart format on
