import 'package:flutter/foundation.dart';

/// Represents a note about data uncertainty or approximation.
/// 
/// The app preserves uncertainty by displaying these notes when
/// ownership data is approximate, estimated, or incomplete.
@immutable
class UncertaintyNote {
  final String id;
  final String context;
  final String explanation;
  final String? source;
  final DateTime? date;
  
  const UncertaintyNote({
    required this.id,
    required this.context,
    required this.explanation,
    this.source,
    this.date,
  });
  
  /// Creates a copy of this note with optional field updates.
  UncertaintyNote copyWith({
    String? id,
    String? context,
    String? explanation,
    String? source,
    DateTime? date,
  }) {
    return UncertaintyNote(
      id: id ?? this.id,
      context: context ?? this.context,
      explanation: explanation ?? this.explanation,
      source: source ?? this.source,
      date: date ?? this.date,
    );
  }
  
  @override
  String toString() => 'UncertaintyNote($context: $explanation)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UncertaintyNote && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

/// Predefined uncertainty notes for common data limitations.
class CommonUncertaintyNotes {
  static const institutionalOwnership = UncertaintyNote(
    id: 'institutional_ownership',
    context: 'Institutional Ownership',
    explanation: 'Vanguard and BlackRock ownership percentages are estimates based on '
        'public filings. Actual holdings fluctuate and may include shares held on behalf '
        'of millions of individual investors through index funds and retirement accounts.',
    source: 'SEC 13F Filings',
  );
  
  static const privateCompany = UncertaintyNote(
    id: 'private_company',
    context: 'Private Company',
    explanation: 'This is a privately held company. Ownership structure is based on '
        'publicly available information but may not reflect the complete ownership picture.',
  );
  
  static const approximatePercentage = UncertaintyNote(
    id: 'approximate_percentage',
    context: 'Approximate Percentage',
    explanation: 'Ownership percentage is approximate and may have changed since the '
        'last public filing.',
  );
  
  static const indirectOwnership = UncertaintyNote(
    id: 'indirect_ownership',
    context: 'Indirect Ownership',
    explanation: 'Ownership is held through parent companies, holding companies, or '
        'other indirect structures. The percentage shown represents effective economic interest.',
  );
  
  static const illustrativeCalculation = UncertaintyNote(
    id: 'illustrative_calculation',
    context: 'Illustrative Calculation',
    explanation: 'The amounts shown are illustrative calculations (purchase amount × '
        'ownership percentage) and do not represent actual cash flows to shareholders. '
        'This is a structural analysis tool, not a financial tracking system.',
  );
}
