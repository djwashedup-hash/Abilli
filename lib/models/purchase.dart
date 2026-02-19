import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Represents a consumer purchase transaction.
/// 
/// Purchases are stored locally on the device and linked to
/// companies through merchant name matching.
@immutable
class Purchase {
  final String id;
  final String productName;
  final double amount;
  final DateTime date;
  final String companyName;
  final String? merchantAlias;
  final String? notes;
  final DateTime createdAt;
  
  const Purchase({
    required this.id,
    required this.productName,
    required this.amount,
    required this.date,
    required this.companyName,
    this.merchantAlias,
    this.notes,
    required this.createdAt,
  });
  
  /// Creates a new purchase with a generated UUID.
  factory Purchase.create({
    required String productName,
    required double amount,
    required DateTime date,
    required String companyName,
    String? merchantAlias,
    String? notes,
  }) {
    return Purchase(
      id: const Uuid().v4(),
      productName: productName,
      amount: amount,
      date: date,
      companyName: companyName,
      merchantAlias: merchantAlias,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }
  
  /// Creates a copy of this purchase with optional field updates.
  Purchase copyWith({
    String? id,
    String? productName,
    double? amount,
    DateTime? date,
    String? companyName,
    String? merchantAlias,
    String? notes,
    DateTime? createdAt,
  }) {
    return Purchase(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      companyName: companyName ?? this.companyName,
      merchantAlias: merchantAlias ?? this.merchantAlias,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  /// Formats the amount as currency.
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  
  /// Formats the date for display.
  String get formattedDate {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  @override
  String toString() => 'Purchase($productName: $formattedAmount at $companyName)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Purchase && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
