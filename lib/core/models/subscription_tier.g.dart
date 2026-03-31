// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_tier.dart';

_SubscriptionTier _$SubscriptionTierFromJson(Map<String, dynamic> json) =>
    _SubscriptionTier(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      monthlyPrice: (json['monthlyPrice'] as num? ?? json['monthly_price'] as num).toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num? ?? json['yearly_price'] as num).toDouble(),
      features: (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      sortOrder: (json['sortOrder'] as num? ?? json['sort_order'] as num).toInt(),
      isPopular: json['isPopular'] as bool? ?? json['is_popular'] as bool? ?? false,
      color: json['color'] as String? ?? '#000000',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SubscriptionTierToJson(_SubscriptionTier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'monthlyPrice': instance.monthlyPrice,
      'yearlyPrice': instance.yearlyPrice,
      'features': instance.features,
      'sortOrder': instance.sortOrder,
      'isPopular': instance.isPopular,
      'color': instance.color,
      'metadata': instance.metadata,
    };
