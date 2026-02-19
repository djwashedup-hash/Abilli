import 'package:flutter/foundation.dart';

/// Represents a product that can be purchased.
/// 
/// Products are linked to companies and can have alternatives
/// suggested for users who want to explore different options.
@immutable
class Product {
  final String id;
  final String name;
  final String category;
  final String? brand;
  final String? description;
  final List<String> companyIds;
  
  const Product({
    required this.id,
    required this.name,
    required this.category,
    this.brand,
    this.description,
    required this.companyIds,
  });
  
  /// Creates a copy of this product with optional field updates.
  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? brand,
    String? description,
    List<String>? companyIds,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      companyIds: companyIds ?? this.companyIds,
    );
  }
  
  @override
  String toString() => 'Product(id: $id, name: $name, category: $category)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
