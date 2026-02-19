import 'package:flutter/foundation.dart';

/// Represents a company or corporation in the ownership chain.
/// 
/// Companies can have parent companies, forming ownership chains.
/// For example: Save-On-Foods → Pattison Food Group → Jim Pattison Group
@immutable
class Company {
  final String id;
  final String name;
  final String? parentId;
  final String? description;
  final String? headquarters;
  final bool isCooperative;
  
  const Company({
    required this.id,
    required this.name,
    this.parentId,
    this.description,
    this.headquarters,
    this.isCooperative = false,
  });
  
  /// Creates a copy of this company with optional field updates.
  Company copyWith({
    String? id,
    String? name,
    String? parentId,
    String? description,
    String? headquarters,
    bool? isCooperative,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      description: description ?? this.description,
      headquarters: headquarters ?? this.headquarters,
      isCooperative: isCooperative ?? this.isCooperative,
    );
  }
  
  @override
  String toString() => 'Company(id: $id, name: $name, parentId: $parentId)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Company && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
