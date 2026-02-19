import 'package:flutter/foundation.dart';

/// Categories of public actions that can be sourced from official records.
enum ActionCategory {
  politicalDonation,
  laborRelations,
  regulatoryAction,
  lobbying,
  philanthropy,
  legalProceeding,
  environmental,
  other,
}

/// Extension to provide human-readable labels for action categories.
extension ActionCategoryLabel on ActionCategory {
  String get label {
    switch (this) {
      case ActionCategory.politicalDonation:
        return 'Political Donations';
      case ActionCategory.laborRelations:
        return 'Labor Relations';
      case ActionCategory.regulatoryAction:
        return 'Regulatory Actions';
      case ActionCategory.lobbying:
        return 'Lobbying';
      case ActionCategory.philanthropy:
        return 'Philanthropy';
      case ActionCategory.legalProceeding:
        return 'Legal Proceedings';
      case ActionCategory.environmental:
        return 'Environmental';
      case ActionCategory.other:
        return 'Other';
    }
  }
}

/// Represents a public action taken by a shareholder that is sourced
/// from official public records.
/// 
/// All public actions MUST include:
/// - A source (FEC, NLRB, FTC, court filing, etc.)
/// - A date
/// - Neutral language describing the action
@immutable
class PublicAction {
  final String id;
  final String description;
  final ActionCategory category;
  final String source;
  final DateTime date;
  final String? url;
  final String? additionalContext;
  
  const PublicAction({
    required this.id,
    required this.description,
    required this.category,
    required this.source,
    required this.date,
    this.url,
    this.additionalContext,
  });
  
  /// Creates a copy of this action with optional field updates.
  PublicAction copyWith({
    String? id,
    String? description,
    ActionCategory? category,
    String? source,
    DateTime? date,
    String? url,
    String? additionalContext,
  }) {
    return PublicAction(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      source: source ?? this.source,
      date: date ?? this.date,
      url: url ?? this.url,
      additionalContext: additionalContext ?? this.additionalContext,
    );
  }
  
  /// Formats the date for display.
  String get formattedDate {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  @override
  String toString() => 'PublicAction($category: $description)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PublicAction && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
