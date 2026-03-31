// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation.dart';

_Donation _$DonationFromJson(Map<String, dynamic> json) => _Donation(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$DonationTypeEnumMap, json['type']),
      message: json['message'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? json['isAnonymous'] as bool? ?? false,
      isMonthly: json['is_monthly'] as bool? ?? json['isMonthly'] as bool? ?? false,
      status: $enumDecodeNullable(_$DonationStatusEnumMap, json['status']) ?? DonationStatus.pending,
      createdAt: DateTime.parse(json['created_at'] as String? ?? json['createdAt'] as String),
      processedAt: json['processed_at'] != null ? DateTime.parse(json['processed_at'] as String) : json['processedAt'] != null ? DateTime.parse(json['processedAt'] as String) : null,
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at'] as String) : json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
      paymentMethod: json['payment_method'] as String? ?? json['paymentMethod'] as String?,
      transactionId: json['transaction_id'] as String? ?? json['transactionId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DonationToJson(_Donation instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'amount': instance.amount,
      'type': _$DonationTypeEnumMap[instance.type]!,
      'message': instance.message,
      'is_anonymous': instance.isAnonymous,
      'is_monthly': instance.isMonthly,
      'status': _$DonationStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'processed_at': instance.processedAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'payment_method': instance.paymentMethod,
      'transaction_id': instance.transactionId,
      'metadata': instance.metadata,
    };

const _$DonationTypeEnumMap = {
  DonationType.oneTime: 'oneTime',
  DonationType.monthly: 'monthly',
  DonationType.yearly: 'yearly',
};

const _$DonationStatusEnumMap = {
  DonationStatus.pending: 'pending',
  DonationStatus.processing: 'processing',
  DonationStatus.completed: 'completed',
  DonationStatus.failed: 'failed',
  DonationStatus.cancelled: 'cancelled',
  DonationStatus.refunded: 'refunded',
};
