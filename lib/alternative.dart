export 'models/alternative.dart';
/*
// lib/models/alternative.dart
// Enhanced alternative model with independence and local scoring

import 'package:flutter/material.dart';

/// Score representing how independent a business is from billionaire/corporate control
class IndependenceScore {
  final int value; // 0-100
  final String explanation;
  final List<String> factors;
  export 'models/alternative.dart';
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
