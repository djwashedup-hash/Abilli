// lib/models/alternative.dart
// Enhanced alternative model with independence and local scoring

import 'package:flutter/material.dart';

/// Score representing how independent a business is from billionaire/corporate control
class IndependenceScore {
  final int value; // 0-100
  final String explanation;
  final List<String> factors;
  final bool isCooperative;
  final bool isBCorp;
  final bool isEmployeeOwned;
  final bool isFamilyOwned;
  final bool isPubliclyTraded;

  const IndependenceScore({
    required this.value,
    required this.explanation,
    required this.factors,
    this.isCooperative = false,
    this.isBCorp = false,
    this.isEmployeeOwned = false,
    this.isFamilyOwned = false,
    this.isPubliclyTraded = false,
  });

  String get category {
    if (value >= 86) return 'Community-Owned';
    if (value >= 61) return 'Independent';
    if (value >= 31) return 'Franchise';
    return 'Corporate';
  }

  Color get color {
    if (value >= 86) return const Color(0xFF238636);
    if (value >= 61) return const Color(0xFF58A6FF);
    if (value >= 31) return const Color(0xFFFFA500);
    return const Color(0xFFFF6B6B);
  }

  IconData get icon {
    if (isCooperative) return Icons.people;
    if (isBCorp) return Icons.verified;
    if (isEmployeeOwned) return Icons.work;
    if (isFamilyOwned) return Icons.family_restroom;
    if (isPubliclyTraded) return Icons.trending_up;
    return Icons.store;
  }
}

/// Score representing how local a business is to the user
class LocalScore {
  final int value; // 0-100
  final String location;
  final double? distanceKm;
  final String? city;
  final String? state;
  final String? country;
  final bool sourcesLocally;
  final double? percentLocalSourcing;

  const LocalScore({
    required this.value,
    required this.location,
    this.distanceKm,
    this.city,
    this.state,
    this.country,
    this.sourcesLocally = false,
    this.percentLocalSourcing,
  });

  String get category {
    if (value >= 86) return 'Local';
    if (value >= 61) return 'Regional';
    if (value >= 31) return 'National';
    return 'International';
  }

  String get distanceDisplay {
    if (distanceKm == null) return location;
    if (distanceKm! < 1) return 'Less than 1 km away';
    if (distanceKm! < 25) return '${distanceKm!.toStringAsFixed(1)} km away';
    if (distanceKm! < 200) return '${distanceKm!.toStringAsFixed(0)} km away';
    return location;
  }

  Color get color {
    if (value >= 86) return const Color(0xFF238636);
    if (value >= 61) return const Color(0xFF58A6FF);
    if (value >= 31) return const Color(0xFFFFA500);
    return const Color(0xFFFF6B6B);
  }
}

/// User-configurable filter for alternative recommendations
class AlternativeFilter {
  int minIndependenceScore;
  int minLocalScore;
  bool prioritizeCoops;
  bool prioritizeBCorps;
  bool prioritizeEmployeeOwned;
  bool prioritizeFamilyOwned;
  double? maxDistanceKm;
  List<String>? preferredCategories;
  String? searchQuery;

  AlternativeFilter({
    this.minIndependenceScore = 0,
    this.minLocalScore = 0,
    this.prioritizeCoops = false,
    this.prioritizeBCorps = false,
    this.prioritizeEmployeeOwned = false,
    this.prioritizeFamilyOwned = false,
    this.maxDistanceKm,
    this.preferredCategories,
    this.searchQuery,
  });

  bool passes(Alternative alt) {
    if (alt.independenceScore.value < minIndependenceScore) return false;
    if (alt.localScore.value < minLocalScore) return false;
    if (maxDistanceKm != null && alt.localScore.distanceKm != null) {
      if (alt.localScore.distanceKm! > maxDistanceKm!) return false;
    }
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      final searchable = '${alt.name} ${alt.description} ${alt.category} ${alt.tags.join(' ')}'.toLowerCase();
      if (!searchable.contains(query)) return false;
    }
    return true;
  }

  List<Alternative> sort(List<Alternative> alternatives) {
    final scored = alternatives.map((alt) {
      int score = alt.independenceScore.value + alt.localScore.value;
      
      if (prioritizeCoops && alt.independenceScore.isCooperative) score += 50;
      if (prioritizeBCorps && alt.independenceScore.isBCorp) score += 40;
      if (prioritizeEmployeeOwned && alt.independenceScore.isEmployeeOwned) score += 30;
      if (prioritizeFamilyOwned && alt.independenceScore.isFamilyOwned) score += 20;
      
      if (alt.localScore.distanceKm != null && alt.localScore.distanceKm! < 10) {
        score += 25;
      }
      
      return (alternative: alt, score: score);
    }).toList();
    
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((s) => s.alternative).toList();
  }

  List<Alternative> apply(List<Alternative> alternatives) {
    final filtered = alternatives.where(passes).toList();
    return sort(filtered);
  }
}

/// Enhanced alternative model with scoring
class Alternative {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> tags;
  final IndependenceScore independenceScore;
  final LocalScore localScore;
  final String? imageUrl;
  final String? website;
  final String? phone;
  final String? address;
  final Map<String, String>? socialMedia;
  final List<String>? replacesBrands;
  final double? averagePrice;
  final double? priceComparison;
  final List<String>? hours;
  final bool isOpenNow;

  const Alternative({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tags,
    required this.independenceScore,
    required this.localScore,
    this.imageUrl,
    this.website,
    this.phone,
    this.address,
    this.socialMedia,
    this.replacesBrands,
    this.averagePrice,
    this.priceComparison,
    this.hours,
    this.isOpenNow = false,
  });

  String get valueProposition {
    final parts = <String>[];
    
    if (independenceScore.value >= 61) {
      parts.add('${independenceScore.category} business');
    }
    if (localScore.value >= 61) {
      parts.add(localScore.distanceKm != null 
        ? '${localScore.distanceKm!.toStringAsFixed(1)} km away'
        : 'Locally owned');
    }
    if (priceComparison != null && priceComparison! < 1.0) {
      final savings = ((1 - priceComparison!) * 100).toStringAsFixed(0);
      parts.add('$savings% cheaper');
    }
    
    return parts.join(' • ');
  }
}

/// Suggested alternative for a specific product or category
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
