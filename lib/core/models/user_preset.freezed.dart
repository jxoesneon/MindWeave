// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPreset {

 String get id; String get userId; String get name; double get carrierFrequency; double get beatFrequency; NoiseType get noiseType; double get noiseVolume; double get binauralVolume; bool get isPublic; DateTime get createdAt;
/// Create a copy of UserPreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPresetCopyWith<UserPreset> get copyWith => _$UserPresetCopyWithImpl<UserPreset>(this as UserPreset, _$identity);

  /// Serializes this UserPreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.noiseType, noiseType) || other.noiseType == noiseType)&&(identical(other.noiseVolume, noiseVolume) || other.noiseVolume == noiseVolume)&&(identical(other.binauralVolume, binauralVolume) || other.binauralVolume == binauralVolume)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,carrierFrequency,beatFrequency,noiseType,noiseVolume,binauralVolume,isPublic,createdAt);

@override
String toString() {
  return 'UserPreset(id: $id, userId: $userId, name: $name, carrierFrequency: $carrierFrequency, beatFrequency: $beatFrequency, noiseType: $noiseType, noiseVolume: $noiseVolume, binauralVolume: $binauralVolume, isPublic: $isPublic, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserPresetCopyWith<$Res>  {
  factory $UserPresetCopyWith(UserPreset value, $Res Function(UserPreset) _then) = _$UserPresetCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, double carrierFrequency, double beatFrequency, NoiseType noiseType, double noiseVolume, double binauralVolume, bool isPublic, DateTime createdAt
});




}
/// @nodoc
class _$UserPresetCopyWithImpl<$Res>
    implements $UserPresetCopyWith<$Res> {
  _$UserPresetCopyWithImpl(this._self, this._then);

  final UserPreset _self;
  final $Res Function(UserPreset) _then;

/// Create a copy of UserPreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? carrierFrequency = null,Object? beatFrequency = null,Object? noiseType = null,Object? noiseVolume = null,Object? binauralVolume = null,Object? isPublic = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency // ignore: cast_nullable_to_non_nullable
as double,beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency // ignore: cast_nullable_to_non_nullable
as double,noiseType: null == noiseType ? _self.noiseType : noiseType // ignore: cast_nullable_to_non_nullable
as NoiseType,noiseVolume: null == noiseVolume ? _self.noiseVolume : noiseVolume // ignore: cast_nullable_to_non_nullable
as double,binauralVolume: null == binauralVolume ? _self.binauralVolume : binauralVolume // ignore: cast_nullable_to_non_nullable
as double,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreset].
extension UserPresetPatterns on UserPreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreset value)  $default,){
final _that = this;
switch (_that) {
case _UserPreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreset value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  double carrierFrequency,  double beatFrequency,  NoiseType noiseType,  double noiseVolume,  double binauralVolume,  bool isPublic,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreset() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.carrierFrequency,_that.beatFrequency,_that.noiseType,_that.noiseVolume,_that.binauralVolume,_that.isPublic,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  double carrierFrequency,  double beatFrequency,  NoiseType noiseType,  double noiseVolume,  double binauralVolume,  bool isPublic,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserPreset():
return $default(_that.id,_that.userId,_that.name,_that.carrierFrequency,_that.beatFrequency,_that.noiseType,_that.noiseVolume,_that.binauralVolume,_that.isPublic,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  double carrierFrequency,  double beatFrequency,  NoiseType noiseType,  double noiseVolume,  double binauralVolume,  bool isPublic,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserPreset() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.carrierFrequency,_that.beatFrequency,_that.noiseType,_that.noiseVolume,_that.binauralVolume,_that.isPublic,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserPreset implements UserPreset {
  const _UserPreset({required this.id, required this.userId, required this.name, required this.carrierFrequency, required this.beatFrequency, this.noiseType = NoiseType.none, this.noiseVolume = 0.2, this.binauralVolume = 1.0, this.isPublic = false, required this.createdAt});
  factory _UserPreset.fromJson(Map<String, dynamic> json) => _$UserPresetFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  double carrierFrequency;
@override final  double beatFrequency;
@override@JsonKey() final  NoiseType noiseType;
@override@JsonKey() final  double noiseVolume;
@override@JsonKey() final  double binauralVolume;
@override@JsonKey() final  bool isPublic;
@override final  DateTime createdAt;

/// Create a copy of UserPreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPresetCopyWith<_UserPreset> get copyWith => __$UserPresetCopyWithImpl<_UserPreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.noiseType, noiseType) || other.noiseType == noiseType)&&(identical(other.noiseVolume, noiseVolume) || other.noiseVolume == noiseVolume)&&(identical(other.binauralVolume, binauralVolume) || other.binauralVolume == binauralVolume)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,carrierFrequency,beatFrequency,noiseType,noiseVolume,binauralVolume,isPublic,createdAt);

@override
String toString() {
  return 'UserPreset(id: $id, userId: $userId, name: $name, carrierFrequency: $carrierFrequency, beatFrequency: $beatFrequency, noiseType: $noiseType, noiseVolume: $noiseVolume, binauralVolume: $binauralVolume, isPublic: $isPublic, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserPresetCopyWith<$Res> implements $UserPresetCopyWith<$Res> {
  factory _$UserPresetCopyWith(_UserPreset value, $Res Function(_UserPreset) _then) = __$UserPresetCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, double carrierFrequency, double beatFrequency, NoiseType noiseType, double noiseVolume, double binauralVolume, bool isPublic, DateTime createdAt
});




}
/// @nodoc
class __$UserPresetCopyWithImpl<$Res>
    implements _$UserPresetCopyWith<$Res> {
  __$UserPresetCopyWithImpl(this._self, this._then);

  final _UserPreset _self;
  final $Res Function(_UserPreset) _then;

/// Create a copy of UserPreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? carrierFrequency = null,Object? beatFrequency = null,Object? noiseType = null,Object? noiseVolume = null,Object? binauralVolume = null,Object? isPublic = null,Object? createdAt = null,}) {
  return _then(_UserPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency // ignore: cast_nullable_to_non_nullable
as double,beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency // ignore: cast_nullable_to_non_nullable
as double,noiseType: null == noiseType ? _self.noiseType : noiseType // ignore: cast_nullable_to_non_nullable
as NoiseType,noiseVolume: null == noiseVolume ? _self.noiseVolume : noiseVolume // ignore: cast_nullable_to_non_nullable
as double,binauralVolume: null == binauralVolume ? _self.binauralVolume : binauralVolume // ignore: cast_nullable_to_non_nullable
as double,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
