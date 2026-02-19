import 'package:flutter/foundation.dart';

/// Represents an alternative product or store suggestion.
/// 
/// Alternatives provide users with options for different companies
/// that offer similar products or services. The app never rates
/// or judges these alternatives - it simply presents them as options.
@immutable
class Alternative {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String? companyId;
  final List<String> alternativeToCompanyIds;
  final bool isLocal;
  final bool isIndependent;
  final bool isCooperative;
  
  const Alternative({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.companyId,
    required this.alternativeToCompanyIds,
    this.isLocal = false,
    this.isIndependent = false,
    this.isCooperative = false,
  });
  
  /// Creates a copy of this alternative with optional field updates.
  Alternative copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? companyId,
    List<String>? alternativeToCompanyIds,
    bool? isLocal,
    bool? isIndependent,
    bool? isCooperative,
  }) {
    return Alternative(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      companyId: companyId ?? this.companyId,
      alternativeToCompanyIds: alternativeToCompanyIds ?? this.alternativeToCompanyIds,
      isLocal: isLocal ?? this.isLocal,
      isIndependent: isIndependent ?? this.isIndependent,
      isCooperative: isCooperative ?? this.isCooperative,
    );
  }
  
  @override
  String toString() => 'Alternative(id: $id, name: $name, category: $category)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Alternative && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
