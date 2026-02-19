import 'package:flutter/foundation.dart';
import 'purchase.dart';
import 'individual.dart';

/// Represents a slice of the spending report for a specific shareholder.
/// 
/// Contains the calculated illustrative amount that would be attributed
/// to this shareholder based on their ownership percentage.
@immutable
class ReportSlice {
  final Individual shareholder;
  final double ownershipPercentage;
  final double illustrativeAmount;
  final List<Purchase> contributingPurchases;
  
  const ReportSlice({
    required this.shareholder,
    required this.ownershipPercentage,
    required this.illustrativeAmount,
    required this.contributingPurchases,
  });
  
  /// Formats the ownership percentage for display.
  String get formattedOwnership => '${ownershipPercentage.toStringAsFixed(1)}%';
  
  /// Formats the illustrative amount as currency.
  String get formattedAmount => '\$${illustrativeAmount.toStringAsFixed(2)}';
  
  @override
  String toString() => 
      'ReportSlice(${shareholder.name}: $formattedOwnership = $formattedAmount)';
}

/// Represents a complete spending report for a given time period.
/// 
/// The report aggregates all purchases in the date range and computes
/// illustrative amounts for each shareholder based on ownership chains.
@immutable
class SpendingReport {
  final DateTime startDate;
  final DateTime endDate;
  final List<Purchase> purchases;
  final List<ReportSlice> slices;
  final double totalSpending;
  
  const SpendingReport({
    required this.startDate,
    required this.endDate,
    required this.purchases,
    required this.slices,
    required this.totalSpending,
  });
  
  /// Gets the top shareholders by illustrative amount.
  List<ReportSlice> get topShareholders {
    final sorted = List<ReportSlice>.from(slices)
      ..sort((a, b) => b.illustrativeAmount.compareTo(a.illustrativeAmount));
    return sorted;
  }
  
  /// Gets slices for a specific shareholder.
  List<ReportSlice> getSlicesForShareholder(String shareholderId) {
    return slices.where((slice) => slice.shareholder.id == shareholderId).toList();
  }
  
  /// Formats the total spending as currency.
  String get formattedTotal => '\$${totalSpending.toStringAsFixed(2)}';
  
  /// Formats the date range for display.
  String get formattedDateRange {
    final start = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final end = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
    return '$start to $end';
  }
  
  @override
  String toString() => 
      'SpendingReport($formattedDateRange: $formattedTotal, ${purchases.length} purchases)';
}

/// Enum for report time period filtering.
enum ReportPeriod {
  daily,
  weekly,
  monthly,
  yearly,
  custom,
}

/// Extension to provide human-readable labels for report periods.
extension ReportPeriodLabel on ReportPeriod {
  String get label {
    switch (this) {
      case ReportPeriod.daily:
        return 'Daily';
      case ReportPeriod.weekly:
        return 'Weekly';
      case ReportPeriod.monthly:
        return 'Monthly';
      case ReportPeriod.yearly:
        return 'Yearly';
      case ReportPeriod.custom:
        return 'Custom Range';
    }
  }
}
