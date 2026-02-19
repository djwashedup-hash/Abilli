import 'package:flutter/foundation.dart';
import 'public_action.dart';

/// Represents a shareholder or ownership-linked individual.
/// 
/// This model stores information about individuals who own shares
/// in companies, along with their public actions that are sourced
/// from official records (FEC, NLRB, FTC, court filings, etc.).
@immutable
class Individual {
  final String id;
  final String name;
  final String? title;
  final String? description;
  final List<PublicAction> publicActions;
  
  const Individual({
    required this.id,
    required this.name,
    this.title,
    this.description,
    this.publicActions = const [],
  });
  
  /// Creates a copy of this individual with optional field updates.
  Individual copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    List<PublicAction>? publicActions,
  }) {
    return Individual(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      publicActions: publicActions ?? this.publicActions,
    );
  }
  
  /// Gets public actions filtered by category.
  List<PublicAction> getActionsByCategory(ActionCategory category) {
    return publicActions.where((action) => action.category == category).toList();
  }
  
  @override
  String toString() => 'Individual(id: $id, name: $name, actions: ${publicActions.length})';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Individual && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
