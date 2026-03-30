// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mixer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MixerState {

 double get backgroundVolume; NoiseType get noiseType;
/// Create a copy of MixerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MixerStateCopyWith<MixerState> get copyWith => _$MixerStateCopyWithImpl<MixerState>(this as MixerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MixerState&&(identical(other.backgroundVolume, backgroundVolume) || other.backgroundVolume == backgroundVolume)&&(identical(other.noiseType, noiseType) || other.noiseType == noiseType));
}


@override
int get hashCode => Object.hash(runtimeType,backgroundVolume,noiseType);

@override
String toString() {
  return 'MixerState(backgroundVolume: $backgroundVolume, noiseType: $noiseType)';
}


}

/// @nodoc
abstract mixin class $MixerStateCopyWith<$Res>  {
  factory $MixerStateCopyWith(MixerState value, $Res Function(MixerState) _then) = _$MixerStateCopyWithImpl;
@useResult
$Res call({
 double backgroundVolume, NoiseType noiseType
});




}
/// @nodoc
class _$MixerStateCopyWithImpl<$Res>
    implements $MixerStateCopyWith<$Res> {
  _$MixerStateCopyWithImpl(this._self, this._then);

  final MixerState _self;
  final $Res Function(MixerState) _then;

/// Create a copy of MixerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backgroundVolume = null,Object? noiseType = null,}) {
  return _then(_self.copyWith(
backgroundVolume: null == backgroundVolume ? _self.backgroundVolume : backgroundVolume // ignore: cast_nullable_to_non_nullable
as double,noiseType: null == noiseType ? _self.noiseType : noiseType // ignore: cast_nullable_to_non_nullable
as NoiseType,
  ));
}

}


/// Adds pattern-matching-related methods to [MixerState].
extension MixerStatePatterns on MixerState {
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
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MixerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MixerState() when $default != null:
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
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MixerState value)  $default,){
final _that = this;
switch (_that) {
case _MixerState():
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
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MixerState value)?  $default,){
final _that = this;
switch (_that) {
case _MixerState() when $default != null:
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
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double backgroundVolume,  NoiseType noiseType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MixerState() when $default != null:
return $default(_that.backgroundVolume,_that.noiseType);case _:
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
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double backgroundVolume,  NoiseType noiseType)  $default,) {final _that = this;
switch (_that) {
case _MixerState():
return $default(_that.backgroundVolume,_that.noiseType);case _:
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
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double backgroundVolume,  NoiseType noiseType)?  $default,) {final _that = this;
switch (_that) {
case _MixerState() when $default != null:
return $default(_that.backgroundVolume,_that.noiseType);case _:
  return null;

}
}

}

/// @nodoc


class _MixerState implements MixerState {
  const _MixerState({this.backgroundVolume = 0.2, this.noiseType = NoiseType.none});
  

@override@JsonKey() final  double backgroundVolume;
@override@JsonKey() final  NoiseType noiseType;

/// Create a copy of MixerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MixerStateCopyWith<_MixerState> get copyWith => __$MixerStateCopyWithImpl<_MixerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MixerState&&(identical(other.backgroundVolume, backgroundVolume) || other.backgroundVolume == backgroundVolume)&&(identical(other.noiseType, noiseType) || other.noiseType == noiseType));
}


@override
int get hashCode => Object.hash(runtimeType,backgroundVolume,noiseType);

@override
String toString() {
  return 'MixerState(backgroundVolume: $backgroundVolume, noiseType: $noiseType)';
}


}

/// @nodoc
abstract mixin class _$MixerStateCopyWith<$Res> implements $MixerStateCopyWith<$Res> {
  factory _$MixerStateCopyWith(_MixerState value, $Res Function(_MixerState) _then) = __$MixerStateCopyWithImpl;
@override @useResult
$Res call({
 double backgroundVolume, NoiseType noiseType
});




}
/// @nodoc
class __$MixerStateCopyWithImpl<$Res>
    implements _$MixerStateCopyWith<$Res> {
  __$MixerStateCopyWithImpl(this._self, this._then);

  final _MixerState _self;
  final $Res Function(_MixerState) _then;

/// Create a copy of MixerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backgroundVolume = null,Object? noiseType = null,}) {
  return _then(_MixerState(
backgroundVolume: null == backgroundVolume ? _self.backgroundVolume : backgroundVolume // ignore: cast_nullable_to_non_nullable
as double,noiseType: null == noiseType ? _self.noiseType : noiseType // ignore: cast_nullable_to_non_nullable
as NoiseType,
  ));
}


}

// dart format on
