// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_tier.dart';

// dart format off
T _$identity<T>(T value) => value;

mixin _$SubscriptionTier {
 String get id; String get name; String get description; double get monthlyPrice; double get yearlyPrice; List<String> get features; int get sortOrder; bool get isPopular; String get color; Map<String, dynamic>? get metadata;

@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionTierCopyWith<SubscriptionTier> get copyWith => _$SubscriptionTierCopyWithImpl<SubscriptionTier>(this as SubscriptionTier, _$identity);

  Map<String, dynamic> toJson();

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionTier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.monthlyPrice, monthlyPrice) || other.monthlyPrice == monthlyPrice)&&(identical(other.yearlyPrice, yearlyPrice) || other.yearlyPrice == yearlyPrice)&&const DeepCollectionEquality().equals(other.features, features)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,monthlyPrice,yearlyPrice,const DeepCollectionEquality().hash(features),sortOrder,isPopular,color,const DeepCollectionEquality().hash(metadata));
}

abstract mixin class $SubscriptionTierCopyWith<$Res> {
  factory $SubscriptionTierCopyWith(SubscriptionTier value, $Res Function(SubscriptionTier) _then) = _$SubscriptionTierCopyWithImpl;
@useResult
$Res call({String id, String name, String description, double monthlyPrice, double yearlyPrice, List<String> features, int sortOrder, bool isPopular, String color, Map<String, dynamic>? metadata});
}

class _$SubscriptionTierCopyWithImpl<$Res> implements $SubscriptionTierCopyWith<$Res> {
  _$SubscriptionTierCopyWithImpl(this._self, this._then);
  final SubscriptionTier _self;
  final $Res Function(SubscriptionTier) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null, Object? name = null, Object? description = null, Object? monthlyPrice = null, Object? yearlyPrice = null, Object? features = null, Object? sortOrder = null, Object? isPopular = null, Object? color = null, Object? metadata = freezed}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id as String,
name: null == name ? _self.name : name as String,
description: null == description ? _self.description : description as String,
monthlyPrice: null == monthlyPrice ? _self.monthlyPrice : monthlyPrice as double,
yearlyPrice: null == yearlyPrice ? _self.yearlyPrice : yearlyPrice as double,
features: null == features ? _self.features : features as List<String>,
sortOrder: null == sortOrder ? _self.sortOrder : sortOrder as int,
isPopular: null == isPopular ? _self.isPopular : isPopular as bool,
color: null == color ? _self.color : color as String,
metadata: freezed == metadata ? _self.metadata : metadata as Map<String, dynamic>?,
  ));
}
}

@JsonSerializable()
class _SubscriptionTier extends SubscriptionTier {
  const _SubscriptionTier({required this.id, required this.name, required this.description, required this.monthlyPrice, required this.yearlyPrice, required final List<String> features, required this.sortOrder, this.isPopular = false, this.color = '#000000', this.metadata}) : _features = features, super._();
  factory _SubscriptionTier.fromJson(Map<String, dynamic> json) => _$SubscriptionTierFromJson(json);

@override final String id;
@override final String name;
@override final String description;
@override final double monthlyPrice;
@override final double yearlyPrice;
final List<String> _features;
@override List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  return EqualUnmodifiableListView(_features);
}
@override final int sortOrder;
@override@JsonKey() final bool isPopular;
@override@JsonKey() final String color;
@override final Map<String, dynamic>? metadata;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionTierCopyWith<_SubscriptionTier> get copyWith => __$SubscriptionTierCopyWithImpl<_SubscriptionTier>(this, _$identity);

@override
Map<String, dynamic> toJson() { return _$SubscriptionTierToJson(this); }

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionTier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.monthlyPrice, monthlyPrice) || other.monthlyPrice == monthlyPrice)&&(identical(other.yearlyPrice, yearlyPrice) || other.yearlyPrice == yearlyPrice)&&const DeepCollectionEquality().equals(other._features, _features)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,monthlyPrice,yearlyPrice,const DeepCollectionEquality().hash(_features),sortOrder,isPopular,color,const DeepCollectionEquality().hash(metadata));
}

abstract mixin class _$SubscriptionTierCopyWith<$Res> implements $SubscriptionTierCopyWith<$Res> {
  factory _$SubscriptionTierCopyWith(_SubscriptionTier value, $Res Function(_SubscriptionTier) _then) = __$SubscriptionTierCopyWithImpl;
@override @useResult
$Res call({String id, String name, String description, double monthlyPrice, double yearlyPrice, List<String> features, int sortOrder, bool isPopular, String color, Map<String, dynamic>? metadata});
}

class __$SubscriptionTierCopyWithImpl<$Res> implements _$SubscriptionTierCopyWith<$Res> {
  __$SubscriptionTierCopyWithImpl(this._self, this._then);
  final _SubscriptionTier _self;
  final $Res Function(_SubscriptionTier) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null, Object? name = null, Object? description = null, Object? monthlyPrice = null, Object? yearlyPrice = null, Object? features = null, Object? sortOrder = null, Object? isPopular = null, Object? color = null, Object? metadata = freezed}) {
  return _then(_SubscriptionTier(
id: null == id ? _self.id : id as String,
name: null == name ? _self.name : name as String,
description: null == description ? _self.description : description as String,
monthlyPrice: null == monthlyPrice ? _self.monthlyPrice : monthlyPrice as double,
yearlyPrice: null == yearlyPrice ? _self.yearlyPrice : yearlyPrice as double,
features: null == features ? _self._features : features as List<String>,
sortOrder: null == sortOrder ? _self.sortOrder : sortOrder as int,
isPopular: null == isPopular ? _self.isPopular : isPopular as bool,
color: null == color ? _self.color : color as String,
metadata: freezed == metadata ? _self.metadata : metadata as Map<String, dynamic>?,
  ));
}
}

// dart format on
