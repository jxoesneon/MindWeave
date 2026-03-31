import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation.freezed.dart';
part 'donation.g.dart';

@freezed
abstract class Donation with _$Donation {
  const factory Donation({
    required String id,
    required String userId,
    required double amount,
    required DonationType type,
    String? message,
    @Default(false) bool isAnonymous,
    @Default(false) bool isMonthly,
    @Default(DonationStatus.pending) DonationStatus status,
    required DateTime createdAt,
    DateTime? processedAt,
    DateTime? cancelledAt,
    String? paymentMethod,
    String? transactionId,
    Map<String, dynamic>? metadata,
  }) = _Donation;

  factory Donation.fromJson(Map<String, dynamic> json) =>
      _$DonationFromJson(json);

  const Donation._();

  // Helper methods
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  String get formattedType => type.displayName;
  String get formattedStatus => status.displayName;
  String get formattedCreatedAt =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year}';

  String get displayName {
    if (isAnonymous) return 'Anonymous Supporter';
    return 'Supporter';
  }

  bool get isCompleted => status == DonationStatus.completed;
  bool get isPending => status == DonationStatus.pending;
  bool get isFailed => status == DonationStatus.failed;
  bool get isCancelled => status == DonationStatus.cancelled;
  bool get isRefunded => status == DonationStatus.refunded;

  bool get isRecurring => isMonthly || type == DonationType.monthly;
  bool get isOneTime => !isMonthly && type == DonationType.oneTime;

  Duration? get processingTime {
    if (processedAt == null) return null;
    return processedAt!.difference(createdAt);
  }

  Donation markAsCompleted({String? transactionId, String? paymentMethod}) {
    return copyWith(
      status: DonationStatus.completed,
      processedAt: DateTime.now(),
      transactionId: transactionId,
      paymentMethod: paymentMethod,
    );
  }

  Donation markAsFailed(String reason) {
    return copyWith(
      status: DonationStatus.failed,
      metadata: {...?metadata, 'failure_reason': reason},
    );
  }

  Donation markAsCancelled(String reason) {
    return copyWith(
      status: DonationStatus.cancelled,
      cancelledAt: DateTime.now(),
      metadata: {...?metadata, 'cancellation_reason': reason},
    );
  }

  Donation markAsRefunded(String reason) {
    return copyWith(
      status: DonationStatus.refunded,
      metadata: {...?metadata, 'refund_reason': reason},
    );
  }

  Donation makeAnonymous() {
    return copyWith(isAnonymous: true);
  }

  Donation makePublic() {
    return copyWith(isAnonymous: false);
  }
}

enum DonationType { oneTime, monthly, yearly }

extension DonationTypeExtension on DonationType {
  String get displayName {
    switch (this) {
      case DonationType.oneTime:
        return 'One-time';
      case DonationType.monthly:
        return 'Monthly';
      case DonationType.yearly:
        return 'Yearly';
    }
  }

  String get description {
    switch (this) {
      case DonationType.oneTime:
        return 'Single donation';
      case DonationType.monthly:
        return 'Recurring monthly donation';
      case DonationType.yearly:
        return 'Recurring yearly donation';
    }
  }

  bool get isRecurring => this != DonationType.oneTime;
}

enum DonationStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
}

extension DonationStatusExtension on DonationStatus {
  String get displayName {
    switch (this) {
      case DonationStatus.pending:
        return 'Pending';
      case DonationStatus.processing:
        return 'Processing';
      case DonationStatus.completed:
        return 'Completed';
      case DonationStatus.failed:
        return 'Failed';
      case DonationStatus.cancelled:
        return 'Cancelled';
      case DonationStatus.refunded:
        return 'Refunded';
    }
  }

  String get description {
    switch (this) {
      case DonationStatus.pending:
        return 'Waiting for payment processing';
      case DonationStatus.processing:
        return 'Payment is being processed';
      case DonationStatus.completed:
        return 'Payment completed successfully';
      case DonationStatus.failed:
        return 'Payment failed';
      case DonationStatus.cancelled:
        return 'Payment was cancelled';
      case DonationStatus.refunded:
        return 'Payment was refunded';
    }
  }

  bool get isFinalStatus {
    return [
      DonationStatus.completed,
      DonationStatus.failed,
      DonationStatus.cancelled,
      DonationStatus.refunded,
    ].contains(this);
  }

  bool get isSuccess => this == DonationStatus.completed;
  bool get isFailure => [
    DonationStatus.failed,
    DonationStatus.cancelled,
    DonationStatus.refunded,
  ].contains(this);
}

class DonationStats {
  final int totalDonations;
  final double totalAmount;
  final double averageAmount;
  final int monthlyDonors;
  final int oneTimeDonors;
  final Map<DonationType, int> donationsByType;
  final Map<DonationStatus, int> donationsByStatus;

  const DonationStats({
    required this.totalDonations,
    required this.totalAmount,
    required this.averageAmount,
    required this.monthlyDonors,
    required this.oneTimeDonors,
    required this.donationsByType,
    required this.donationsByStatus,
  });

  static DonationStats empty() => const DonationStats(
    totalDonations: 0,
    totalAmount: 0.0,
    averageAmount: 0.0,
    monthlyDonors: 0,
    oneTimeDonors: 0,
    donationsByType: {},
    donationsByStatus: {},
  );

  String get formattedTotalAmount => '\$${totalAmount.toStringAsFixed(2)}';
  String get formattedAverageAmount => '\$${averageAmount.toStringAsFixed(2)}';

  double get monthlyDonationPercentage {
    if (totalDonations == 0) return 0.0;
    return (monthlyDonors / totalDonations) * 100;
  }

  double get oneTimeDonationPercentage {
    if (totalDonations == 0) return 0.0;
    return (oneTimeDonors / totalDonations) * 100;
  }

  double get successRate {
    final successful = donationsByStatus[DonationStatus.completed] ?? 0;
    if (totalDonations == 0) return 0.0;
    return (successful / totalDonations) * 100;
  }
}
