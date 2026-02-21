// lib/models/shopping_item.dart
// Smart shopping list with purchase pattern learning

import 'alternative.dart';

/// Urgency level for shopping items
enum UrgencyLevel {
  overdue,
  urgent,
  soon,
  later,
  unknown,
}

extension UrgencyLevelExtension on UrgencyLevel {
  String get emoji {
    switch (this) {
      case UrgencyLevel.overdue:
        return '🔴';
      case UrgencyLevel.urgent:
        return '🟠';
      case UrgencyLevel.soon:
        return '🟡';
      case UrgencyLevel.later:
        return '🟢';
      case UrgencyLevel.unknown:
        return '⚪';
    }
  }

  String get label {
    switch (this) {
      case UrgencyLevel.overdue:
        return 'Overdue';
      case UrgencyLevel.urgent:
        return 'Urgent';
      case UrgencyLevel.soon:
        return 'Soon';
      case UrgencyLevel.later:
        return 'Later';
      case UrgencyLevel.unknown:
        return 'Unknown';
    }
  }

  int get priority {
    switch (this) {
      case UrgencyLevel.overdue:
        return 0;
      case UrgencyLevel.urgent:
        return 1;
      case UrgencyLevel.soon:
        return 2;
      case UrgencyLevel.later:
        return 3;
      case UrgencyLevel.unknown:
        return 4;
    }
  }
}

/// Pattern of purchases for a specific item
class PurchasePattern {
  final int purchaseCount;
  final double averageDaysBetweenPurchases;
  final double averageAmount;
  final DateTime? lastPurchaseDate;
  final double confidence;
  final List<DateTime> purchaseDates;
  final List<double> purchaseAmounts;

  const PurchasePattern({
    required this.purchaseCount,
    required this.averageDaysBetweenPurchases,
    required this.averageAmount,
    this.lastPurchaseDate,
    required this.confidence,
    this.purchaseDates = const [],
    this.purchaseAmounts = const [],
  });

  DateTime? predictNextPurchase() {
    if (lastPurchaseDate == null || confidence < 0.3) return null;
    return lastPurchaseDate!.add(Duration(days: averageDaysBetweenPurchases.round()));
  }

  UrgencyLevel calculateUrgency() {
    final nextPurchase = predictNextPurchase();
    if (nextPurchase == null) return UrgencyLevel.unknown;

    final now = DateTime.now();
    final daysUntil = nextPurchase.difference(now).inDays;

    if (daysUntil < 0) return UrgencyLevel.overdue;
    if (daysUntil <= 2) return UrgencyLevel.urgent;
    if (daysUntil <= 7) return UrgencyLevel.soon;
    return UrgencyLevel.later;
  }

  int? get daysUntilPurchase {
    final nextPurchase = predictNextPurchase();
    if (nextPurchase == null) return null;
    return nextPurchase.difference(DateTime.now()).inDays;
  }

  factory PurchasePattern.fromPurchases(List<_Purchase> purchases) {
    if (purchases.isEmpty) {
      return const PurchasePattern(
        purchaseCount: 0,
        averageDaysBetweenPurchases: 0,
        averageAmount: 0,
        confidence: 0,
      );
    }

    final sorted = List<_Purchase>.from(purchases)
      ..sort((a, b) => a.date.compareTo(b.date));

    double totalDays = 0;
    int intervalCount = 0;
    for (int i = 1; i < sorted.length; i++) {
      final days = sorted[i].date.difference(sorted[i - 1].date).inDays;
      if (days > 0) {
        totalDays += days;
        intervalCount++;
      }
    }

    final avgDays = intervalCount > 0 ? (totalDays / intervalCount).toDouble() : 0.0;
    final totalAmount = sorted.fold<double>(0, (sum, p) => sum + p.amount);
    final avgAmount = totalAmount / sorted.length;

    double confidence = 0;
    if (sorted.length >= 3) {
      if (intervalCount > 1) {
        final intervals = <int>[];
        for (int i = 1; i < sorted.length; i++) {
          final days = sorted[i].date.difference(sorted[i - 1].date).inDays;
          if (days > 0) intervals.add(days);
        }
        
        final mean = (intervals.reduce((a, b) => a + b) / intervals.length).toDouble();
        final variance = intervals.fold<double>(
          0, 
          (sum, d) => sum + (d - mean) * (d - mean)
        ) / intervals.length;
        final stdDev = variance > 0 ? variance.toDouble() : 0.0;
        
        final cv = mean > 0 ? stdDev / mean : 1;
        confidence = (1 - cv.clamp(0, 1)) * (sorted.length / 10).clamp(0.3, 1.0);
      } else {
        confidence = 0.3;
      }
    } else if (sorted.length == 2) {
      confidence = 0.2;
    } else {
      confidence = 0.1;
    }

    return PurchasePattern(
      purchaseCount: sorted.length,
      averageDaysBetweenPurchases: avgDays,
      averageAmount: avgAmount,
      lastPurchaseDate: sorted.last.date,
      confidence: confidence,
      purchaseDates: sorted.map((p) => p.date).toList(),
      purchaseAmounts: sorted.map((p) => p.amount).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'purchaseCount': purchaseCount,
    'averageDaysBetweenPurchases': averageDaysBetweenPurchases,
    'averageAmount': averageAmount,
    'lastPurchaseDate': lastPurchaseDate?.toIso8601String(),
    'confidence': confidence,
    'purchaseDates': purchaseDates.map((d) => d.toIso8601String()).toList(),
    'purchaseAmounts': purchaseAmounts,
  };

  factory PurchasePattern.fromJson(Map<String, dynamic> json) => PurchasePattern(
    purchaseCount: json['purchaseCount'] ?? 0,
    averageDaysBetweenPurchases: (json['averageDaysBetweenPurchases'] ?? 0).toDouble(),
    averageAmount: (json['averageAmount'] ?? 0).toDouble(),
    lastPurchaseDate: json['lastPurchaseDate'] != null 
      ? DateTime.parse(json['lastPurchaseDate'])
      : null,
    confidence: (json['confidence'] ?? 0).toDouble(),
    purchaseDates: (json['purchaseDates'] as List? ?? [])
      .map((d) => DateTime.parse(d))
      .toList(),
    purchaseAmounts: (json['purchaseAmounts'] as List? ?? [])
      .map((a) => (a as num).toDouble())
      .toList(),
  );
}

class _Purchase {
  final DateTime date;
  final double amount;
  
  _Purchase({required this.date, required this.amount});
}

/// Shopping list item with smart predictions
class ShoppingItem {
  final String id;
  final String name;
  final String category;
  final String? notes;
  final PurchasePattern? purchasePattern;
  final List<AlternativeSuggestion> alternativeSuggestions;
  final bool isChecked;
  final DateTime addedDate;
  final DateTime? checkedDate;
  final bool isPredicted;
  final String? predictedFromProductId;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    this.notes,
    this.purchasePattern,
    this.alternativeSuggestions = const [],
    this.isChecked = false,
    required this.addedDate,
    this.checkedDate,
    this.isPredicted = false,
    this.predictedFromProductId,
  });

  UrgencyLevel get urgency {
    if (isChecked) return UrgencyLevel.unknown;
    return purchasePattern?.calculateUrgency() ?? UrgencyLevel.unknown;
  }

  DateTime? get nextPredictedPurchase => purchasePattern?.predictNextPurchase();
  int? get daysUntil => purchasePattern?.daysUntilPurchase;

  String get urgencyDisplay {
    final level = urgency;
    final days = daysUntil;
    
    if (days == null) return '${level.emoji} ${level.label}';
    
    if (days < 0) {
      return '${level.emoji} ${level.label} (${-days}d ago)';
    } else if (days == 0) {
      return '${level.emoji} ${level.label} (today)';
    } else if (days == 1) {
      return '${level.emoji} ${level.label} (tomorrow)';
    } else {
      return '${level.emoji} ${level.label} (in $days days)';
    }
  }

  bool get hasAlternatives => alternativeSuggestions.isNotEmpty;

  AlternativeSuggestion? get bestAlternative {
    if (alternativeSuggestions.isEmpty) return null;
    return alternativeSuggestions.reduce((a, b) => a.matchScore > b.matchScore ? a : b);
  }

  ShoppingItem check() => ShoppingItem(
    id: id,
    name: name,
    category: category,
    notes: notes,
    purchasePattern: purchasePattern,
    alternativeSuggestions: alternativeSuggestions,
    isChecked: true,
    addedDate: addedDate,
    checkedDate: DateTime.now(),
    isPredicted: isPredicted,
    predictedFromProductId: predictedFromProductId,
  );

  ShoppingItem uncheck() => ShoppingItem(
    id: id,
    name: name,
    category: category,
    notes: notes,
    purchasePattern: purchasePattern,
    alternativeSuggestions: alternativeSuggestions,
    isChecked: false,
    addedDate: addedDate,
    checkedDate: null,
    isPredicted: isPredicted,
    predictedFromProductId: predictedFromProductId,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'notes': notes,
    'purchasePattern': purchasePattern?.toJson(),
    'alternativeSuggestions': alternativeSuggestions.map((a) => {
      'alternativeId': a.alternative.id,
      'forProduct': a.forProduct,
      'forBrand': a.forBrand,
      'reason': a.reason,
      'matchScore': a.matchScore,
    }).toList(),
    'isChecked': isChecked,
    'addedDate': addedDate.toIso8601String(),
    'checkedDate': checkedDate?.toIso8601String(),
    'isPredicted': isPredicted,
    'predictedFromProductId': predictedFromProductId,
  };
}
