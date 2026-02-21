// lib/models/alternative.dart
// Alternative model for local business recommendations

import 'package:flutter/material.dart';

/// Alternative business recommendation
/// 
/// This is the ORIGINAL Alternative class used by ownership_seed_data.dart
/// and throughout the app. It uses simple boolean flags for classification.
class Alternative {
  final String id;
  final String name;
  final String category;
  final String description;
  final String? companyId;
  final List<String> alternativeToCompanyIds;
  final bool isLocal;
  final bool isCooperative;
  final bool isIndependent;
  final String? website;
  final String? address;
  final String? phone;

  const Alternative({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.companyId,
    required this.alternativeToCompanyIds,
    this.isLocal = false,
    this.isCooperative = false,
    this.isIndependent = false,
    this.website,
    this.address,
    this.phone,
  });

  /// Get a score representing independence (0-100)
  int get independenceScore {
    if (isCooperative) return 90;
    if (isIndependent && isLocal) return 85;
    if (isIndependent) return 70;
    if (isLocal) return 50;
    return 30;
  }

  /// Get a score representing local-ness (0-100)
  int get localScore {
    if (isLocal && isIndependent) return 95;
    if (isLocal) return 75;
    if (isCooperative) return 60;
    return 20;
  }

  /// Get classification label
  String get classification {
    if (isCooperative) return 'Cooperative';
    if (isIndependent && isLocal) return 'Local Independent';
    if (isIndependent) return 'Independent';
    if (isLocal) return 'Local';
    return 'Alternative';
  }

  /// Get color for UI representation
  Color get classificationColor {
    if (isCooperative) return const Color(0xFF238636); // Green
    if (isIndependent && isLocal) return const Color(0xFF58A6FF); // Blue
    if (isIndependent) return const Color(0xFFFFA500); // Orange
    if (isLocal) return const Color(0xFFFFD700); // Yellow
    return const Color(0xFF808080); // Gray
  }
}

/// Alternative suggestion wrapper for shopping list
/// 
/// Links an Alternative to a specific product/brand with a match score
class AlternativeSuggestion {
  final Alternative alternative;
  final String forProduct;
  final String? forBrand;
  final String reason;
  final double matchScore;

  const AlternativeSuggestion({
    required this.alternative,
    required this.forProduct,
    this.forBrand,
    required this.reason,
    required this.matchScore,
  });
}

/// Filter for alternative recommendations
class AlternativeFilter {
  int minIndependenceScore;
  int minLocalScore;
  bool prioritizeCoops;
  bool prioritizeIndependent;
  bool prioritizeLocal;
  String? searchQuery;

  AlternativeFilter({
    this.minIndependenceScore = 0,
    this.minLocalScore = 0,
    this.prioritizeCoops = false,
    this.prioritizeIndependent = false,
    this.prioritizeLocal = false,
    this.searchQuery,
  });

  bool passes(Alternative alt) {
    if (alt.independenceScore < minIndependenceScore) return false;
    if (alt.localScore < minLocalScore) return false;
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      final searchable = '${alt.name} ${alt.description} ${alt.category}'.toLowerCase();
      if (!searchable.contains(query)) return false;
    }
    return true;
  }

  List<Alternative> sort(List<Alternative> alternatives) {
    final scored = alternatives.map((alt) {
      int score = alt.independenceScore + alt.localScore;
      
      if (prioritizeCoops && alt.isCooperative) score += 50;
      if (prioritizeIndependent && alt.isIndependent) score += 30;
      if (prioritizeLocal && alt.isLocal) score += 20;
      
      return (alternative: alt, score: score);
    }).toList();
    
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((s) => s.alternative).toList();
  }

  List<Alternative> apply(List<Alternative> alternatives) {
    final filtered = alternatives.where(passes).toList();
    return sort(filtered);
  }

  AlternativeFilter copyWith({
    int? minIndependenceScore,
    int? minLocalScore,
    bool? prioritizeCoops,
    bool? prioritizeIndependent,
    bool? prioritizeLocal,
    String? searchQuery,
  }) {
    return AlternativeFilter(
      minIndependenceScore: minIndependenceScore ?? this.minIndependenceScore,
      minLocalScore: minLocalScore ?? this.minLocalScore,
      prioritizeCoops: prioritizeCoops ?? this.prioritizeCoops,
      prioritizeIndependent: prioritizeIndependent ?? this.prioritizeIndependent,
      prioritizeLocal: prioritizeLocal ?? this.prioritizeLocal,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
