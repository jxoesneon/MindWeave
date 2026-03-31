// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donation.dart';

// dart format off
T _$identity<T>(T value) => value;

mixin _$Donation {
 String get id; String get userId; double get amount; DonationType get type; String? get message; bool get isAnonymous; bool get isMonthly; DonationStatus get status; DateTime get createdAt; DateTime? get processedAt; DateTime? get cancelledAt; String? get paymentMethod; String? get transactionId; Map<String, dynamic>? get metadata;

@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationCopyWith<Donation> get copyWith => _$DonationCopyWithImpl<Donation>(this as Donation, _$identity);

  Map<String, dynamic> toJson();

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Donation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.isMonthly, isMonthly) || other.isMonthly == isMonthly)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,type,message,isAnonymous,isMonthly,status,createdAt,processedAt,cancelledAt,paymentMethod,transactionId,const DeepCollectionEquality().hash(metadata));
}

abstract mixin class $DonationCopyWith<$Res> {
  factory $DonationCopyWith(Donation value, $Res Function(Donation) _then) = _$DonationCopyWithImpl;
@useResult
$Res call({String id, String userId, double amount, DonationType type, String? message, bool isAnonymous, bool isMonthly, DonationStatus status, DateTime createdAt, DateTime? processedAt, DateTime? cancelledAt, String? paymentMethod, String? transactionId, Map<String, dynamic>? metadata});
}

class _$DonationCopyWithImpl<$Res> implements $DonationCopyWith<$Res> {
  _$DonationCopyWithImpl(this._self, this._then);
  final Donation _self;
  final $Res Function(Donation) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null, Object? userId = null, Object? amount = null, Object? type = null, Object? message = freezed, Object? isAnonymous = null, Object? isMonthly = null, Object? status = null, Object? createdAt = null, Object? processedAt = freezed, Object? cancelledAt = freezed, Object? paymentMethod = freezed, Object? transactionId = freezed, Object? metadata = freezed}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id as String,
userId: null == userId ? _self.userId : userId as String,
amount: null == amount ? _self.amount : amount as double,
type: null == type ? _self.type : type as DonationType,
message: freezed == message ? _self.message : message as String?,
isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous as bool,
isMonthly: null == isMonthly ? _self.isMonthly : isMonthly as bool,
status: null == status ? _self.status : status as DonationStatus,
createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
processedAt: freezed == processedAt ? _self.processedAt : processedAt as DateTime?,
cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt as DateTime?,
paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod as String?,
transactionId: freezed == transactionId ? _self.transactionId : transactionId as String?,
metadata: freezed == metadata ? _self.metadata : metadata as Map<String, dynamic>?,
  ));
}
}

@JsonSerializable()
class _Donation extends Donation {
  const _Donation({required this.id, required this.userId, required this.amount, required this.type, this.message, this.isAnonymous = false, this.isMonthly = false, this.status = DonationStatus.pending, required this.createdAt, this.processedAt, this.cancelledAt, this.paymentMethod, this.transactionId, this.metadata}) : super._();
  factory _Donation.fromJson(Map<String, dynamic> json) => _$DonationFromJson(json);

@override final String id;
@override final String userId;
@override final double amount;
@override final DonationType type;
@override final String? message;
@override@JsonKey() final bool isAnonymous;
@override@JsonKey() final bool isMonthly;
@override@JsonKey() final DonationStatus status;
@override final DateTime createdAt;
@override final DateTime? processedAt;
@override final DateTime? cancelledAt;
@override final String? paymentMethod;
@override final String? transactionId;
@override final Map<String, dynamic>? metadata;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationCopyWith<_Donation> get copyWith => __$DonationCopyWithImpl<_Donation>(this, _$identity);

@override
Map<String, dynamic> toJson() { return _$DonationToJson(this); }

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Donation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.isMonthly, isMonthly) || other.isMonthly == isMonthly)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,type,message,isAnonymous,isMonthly,status,createdAt,processedAt,cancelledAt,paymentMethod,transactionId,const DeepCollectionEquality().hash(metadata));
}

abstract mixin class _$DonationCopyWith<$Res> implements $DonationCopyWith<$Res> {
  factory _$DonationCopyWith(_Donation value, $Res Function(_Donation) _then) = __$DonationCopyWithImpl;
@override @useResult
$Res call({String id, String userId, double amount, DonationType type, String? message, bool isAnonymous, bool isMonthly, DonationStatus status, DateTime createdAt, DateTime? processedAt, DateTime? cancelledAt, String? paymentMethod, String? transactionId, Map<String, dynamic>? metadata});
}

class __$DonationCopyWithImpl<$Res> implements _$DonationCopyWith<$Res> {
  __$DonationCopyWithImpl(this._self, this._then);
  final _Donation _self;
  final $Res Function(_Donation) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null, Object? userId = null, Object? amount = null, Object? type = null, Object? message = freezed, Object? isAnonymous = null, Object? isMonthly = null, Object? status = null, Object? createdAt = null, Object? processedAt = freezed, Object? cancelledAt = freezed, Object? paymentMethod = freezed, Object? transactionId = freezed, Object? metadata = freezed}) {
  return _then(_Donation(
id: null == id ? _self.id : id as String,
userId: null == userId ? _self.userId : userId as String,
amount: null == amount ? _self.amount : amount as double,
type: null == type ? _self.type : type as DonationType,
message: freezed == message ? _self.message : message as String?,
isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous as bool,
isMonthly: null == isMonthly ? _self.isMonthly : isMonthly as bool,
status: null == status ? _self.status : status as DonationStatus,
createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
processedAt: freezed == processedAt ? _self.processedAt : processedAt as DateTime?,
cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt as DateTime?,
paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod as String?,
transactionId: freezed == transactionId ? _self.transactionId : transactionId as String?,
metadata: freezed == metadata ? _self.metadata : metadata as Map<String, dynamic>?,
  ));
}
}

// dart format on
