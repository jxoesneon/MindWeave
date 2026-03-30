// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brainwave_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BrainwavePreset {

 String get id; String get name; String get description; BrainwaveBand get band; double get beatFrequency; double get defaultCarrierFrequency; double get minCarrierFrequency; double get maxCarrierFrequency; String get iconPath; int get accentColorValue; List<String> get tags;
/// Create a copy of BrainwavePreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrainwavePresetCopyWith<BrainwavePreset> get copyWith => _$BrainwavePresetCopyWithImpl<BrainwavePreset>(this as BrainwavePreset, _$identity);

  /// Serializes this BrainwavePreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrainwavePreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.band, band) || other.band == band)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.defaultCarrierFrequency, defaultCarrierFrequency) || other.defaultCarrierFrequency == defaultCarrierFrequency)&&(identical(other.minCarrierFrequency, minCarrierFrequency) || other.minCarrierFrequency == minCarrierFrequency)&&(identical(other.maxCarrierFrequency, maxCarrierFrequency) || other.maxCarrierFrequency == maxCarrierFrequency)&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath)&&(identical(other.accentColorValue, accentColorValue) || other.accentColorValue == accentColorValue)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,band,beatFrequency,defaultCarrierFrequency,minCarrierFrequency,maxCarrierFrequency,iconPath,accentColorValue,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'BrainwavePreset(id: $id, name: $name, description: $description, band: $band, beatFrequency: $beatFrequency, defaultCarrierFrequency: $defaultCarrierFrequency, minCarrierFrequency: $minCarrierFrequency, maxCarrierFrequency: $maxCarrierFrequency, iconPath: $iconPath, accentColorValue: $accentColorValue, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $BrainwavePresetCopyWith<$Res>  {
  factory $BrainwavePresetCopyWith(BrainwavePreset value, $Res Function(BrainwavePreset) _then) = _$BrainwavePresetCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, BrainwaveBand band, double beatFrequency, double defaultCarrierFrequency, double minCarrierFrequency, double maxCarrierFrequency, String iconPath, int accentColorValue, List<String> tags
});




}
/// @nodoc
class _$BrainwavePresetCopyWithImpl<$Res>
    implements $BrainwavePresetCopyWith<$Res> {
  _$BrainwavePresetCopyWithImpl(this._self, this._then);

  final BrainwavePreset _self;
  final $Res Function(BrainwavePreset) _then;

/// Create a copy of BrainwavePreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? band = null,Object? beatFrequency = null,Object? defaultCarrierFrequency = null,Object? minCarrierFrequency = null,Object? maxCarrierFrequency = null,Object? iconPath = null,Object? accentColorValue = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,band: null == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as BrainwaveBand,beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency // ignore: cast_nullable_to_non_nullable
as double,defaultCarrierFrequency: null == defaultCarrierFrequency ? _self.defaultCarrierFrequency : defaultCarrierFrequency // ignore: cast_nullable_to_non_nullable
as double,minCarrierFrequency: null == minCarrierFrequency ? _self.minCarrierFrequency : minCarrierFrequency // ignore: cast_nullable_to_non_nullable
as double,maxCarrierFrequency: null == maxCarrierFrequency ? _self.maxCarrierFrequency : maxCarrierFrequency // ignore: cast_nullable_to_non_nullable
as double,iconPath: null == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String,accentColorValue: null == accentColorValue ? _self.accentColorValue : accentColorValue // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BrainwavePreset].
extension BrainwavePresetPatterns on BrainwavePreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrainwavePreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrainwavePreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrainwavePreset value)  $default,){
final _that = this;
switch (_that) {
case _BrainwavePreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrainwavePreset value)?  $default,){
final _that = this;
switch (_that) {
case _BrainwavePreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  BrainwaveBand band,  double beatFrequency,  double defaultCarrierFrequency,  double minCarrierFrequency,  double maxCarrierFrequency,  String iconPath,  int accentColorValue,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrainwavePreset() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.band,_that.beatFrequency,_that.defaultCarrierFrequency,_that.minCarrierFrequency,_that.maxCarrierFrequency,_that.iconPath,_that.accentColorValue,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  BrainwaveBand band,  double beatFrequency,  double defaultCarrierFrequency,  double minCarrierFrequency,  double maxCarrierFrequency,  String iconPath,  int accentColorValue,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _BrainwavePreset():
return $default(_that.id,_that.name,_that.description,_that.band,_that.beatFrequency,_that.defaultCarrierFrequency,_that.minCarrierFrequency,_that.maxCarrierFrequency,_that.iconPath,_that.accentColorValue,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  BrainwaveBand band,  double beatFrequency,  double defaultCarrierFrequency,  double minCarrierFrequency,  double maxCarrierFrequency,  String iconPath,  int accentColorValue,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _BrainwavePreset() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.band,_that.beatFrequency,_that.defaultCarrierFrequency,_that.minCarrierFrequency,_that.maxCarrierFrequency,_that.iconPath,_that.accentColorValue,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BrainwavePreset implements BrainwavePreset {
  const _BrainwavePreset({required this.id, required this.name, required this.description, required this.band, required this.beatFrequency, this.defaultCarrierFrequency = 250.0, this.minCarrierFrequency = 100.0, this.maxCarrierFrequency = 500.0, required this.iconPath, required this.accentColorValue, final  List<String> tags = const []}): _tags = tags;
  factory _BrainwavePreset.fromJson(Map<String, dynamic> json) => _$BrainwavePresetFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  BrainwaveBand band;
@override final  double beatFrequency;
@override@JsonKey() final  double defaultCarrierFrequency;
@override@JsonKey() final  double minCarrierFrequency;
@override@JsonKey() final  double maxCarrierFrequency;
@override final  String iconPath;
@override final  int accentColorValue;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of BrainwavePreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrainwavePresetCopyWith<_BrainwavePreset> get copyWith => __$BrainwavePresetCopyWithImpl<_BrainwavePreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrainwavePresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrainwavePreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.band, band) || other.band == band)&&(identical(other.beatFrequency, beatFrequency) || other.beatFrequency == beatFrequency)&&(identical(other.defaultCarrierFrequency, defaultCarrierFrequency) || other.defaultCarrierFrequency == defaultCarrierFrequency)&&(identical(other.minCarrierFrequency, minCarrierFrequency) || other.minCarrierFrequency == minCarrierFrequency)&&(identical(other.maxCarrierFrequency, maxCarrierFrequency) || other.maxCarrierFrequency == maxCarrierFrequency)&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath)&&(identical(other.accentColorValue, accentColorValue) || other.accentColorValue == accentColorValue)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,band,beatFrequency,defaultCarrierFrequency,minCarrierFrequency,maxCarrierFrequency,iconPath,accentColorValue,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'BrainwavePreset(id: $id, name: $name, description: $description, band: $band, beatFrequency: $beatFrequency, defaultCarrierFrequency: $defaultCarrierFrequency, minCarrierFrequency: $minCarrierFrequency, maxCarrierFrequency: $maxCarrierFrequency, iconPath: $iconPath, accentColorValue: $accentColorValue, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$BrainwavePresetCopyWith<$Res> implements $BrainwavePresetCopyWith<$Res> {
  factory _$BrainwavePresetCopyWith(_BrainwavePreset value, $Res Function(_BrainwavePreset) _then) = __$BrainwavePresetCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, BrainwaveBand band, double beatFrequency, double defaultCarrierFrequency, double minCarrierFrequency, double maxCarrierFrequency, String iconPath, int accentColorValue, List<String> tags
});




}
/// @nodoc
class __$BrainwavePresetCopyWithImpl<$Res>
    implements _$BrainwavePresetCopyWith<$Res> {
  __$BrainwavePresetCopyWithImpl(this._self, this._then);

  final _BrainwavePreset _self;
  final $Res Function(_BrainwavePreset) _then;

/// Create a copy of BrainwavePreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? band = null,Object? beatFrequency = null,Object? defaultCarrierFrequency = null,Object? minCarrierFrequency = null,Object? maxCarrierFrequency = null,Object? iconPath = null,Object? accentColorValue = null,Object? tags = null,}) {
  return _then(_BrainwavePreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,band: null == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as BrainwaveBand,beatFrequency: null == beatFrequency ? _self.beatFrequency : beatFrequency // ignore: cast_nullable_to_non_nullable
as double,defaultCarrierFrequency: null == defaultCarrierFrequency ? _self.defaultCarrierFrequency : defaultCarrierFrequency // ignore: cast_nullable_to_non_nullable
as double,minCarrierFrequency: null == minCarrierFrequency ? _self.minCarrierFrequency : minCarrierFrequency // ignore: cast_nullable_to_non_nullable
as double,maxCarrierFrequency: null == maxCarrierFrequency ? _self.maxCarrierFrequency : maxCarrierFrequency // ignore: cast_nullable_to_non_nullable
as double,iconPath: null == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String,accentColorValue: null == accentColorValue ? _self.accentColorValue : accentColorValue // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
