import 'package:flutter/foundation.dart';
import 'package:string_similarity/string_similarity.dart';

import '../models/company.dart';
import '../models/individual.dart';
import 'ownership_seed_data.dart' as seed;

/// In-memory database for ownership data.
/// 
/// This database provides fuzzy merchant matching and ownership chain lookups.
/// All data is loaded from seed data - no SQLite required for web builds.
class OwnershipDatabase {
  static final OwnershipDatabase _instance = OwnershipDatabase._internal();
  
  factory OwnershipDatabase() => _instance;
  
  OwnershipDatabase._internal() {
    _loadData();
  }
  
  late Map<String, Company> _companies;
  late Map<String, Individual> _shareholders;
  late Map<String, List<Map<String, dynamic>>> _ownership;
  late Map<String, String> _merchantAliases;
  
  /// Minimum similarity score (0.0-1.0) for fuzzy matching.
  static const double _minSimilarity = 0.6;
  
  /// Loads all data from seed file.
  void _loadData() {
    _companies = seed.getCompanies();
    _shareholders = seed.getShareholders();
    _ownership = seed.getOwnership();
    _merchantAliases = seed.getMerchantAliases();
  }
  
  // ==================== MERCHANT MATCHING ====================
  
  /// Attempts to match a merchant name to a company.
  /// 
  /// Matching priority:
  /// 1. Exact match against merchant aliases
  /// 2. Fuzzy match against merchant aliases (similarity >= 0.6)
  /// 3. Fuzzy match against company names (similarity >= 0.6)
  /// 
  /// Returns the company ID if found, null otherwise.
  String? matchMerchant(String merchantName) {
    if (merchantName.isEmpty) return null;
    
    final normalizedInput = _normalize(merchantName);
    
    // Priority 1: Exact match against aliases
    final exactMatch = _merchantAliases[normalizedInput];
    if (exactMatch != null) {
      return exactMatch;
    }
    
    // Priority 2: Fuzzy match against aliases
    String? bestAliasMatch;
    double bestAliasScore = 0.0;
    
    for (final entry in _merchantAliases.entries) {
      final score = normalizedInput.similarityTo(entry.key);
      if (score > bestAliasScore && score >= _minSimilarity) {
        bestAliasScore = score;
        bestAliasMatch = entry.value;
      }
    }
    
    if (bestAliasMatch != null) {
      return bestAliasMatch;
    }
    
    // Priority 3: Fuzzy match against company names
    String? bestCompanyMatch;
    double bestCompanyScore = 0.0;
    
    for (final company in _companies.values) {
      final normalizedCompanyName = _normalize(company.name);
      final score = normalizedInput.similarityTo(normalizedCompanyName);
      if (score > bestCompanyScore && score >= _minSimilarity) {
        bestCompanyScore = score;
        bestCompanyMatch = company.id;
      }
    }
    
    return bestCompanyMatch;
  }
  
  /// Gets all possible matches for a merchant name with confidence scores.
  /// 
  /// Returns a list of maps containing 'companyId', 'companyName', and 'score'.
  List<Map<String, dynamic>> findPossibleMatches(String merchantName, {int limit = 5}) {
    if (merchantName.isEmpty) return [];
    
    final normalizedInput = _normalize(merchantName);
    final matches = <Map<String, dynamic>>[];
    final seenIds = <String>{};
    
    // Check aliases
    for (final entry in _merchantAliases.entries) {
      final score = normalizedInput.similarityTo(entry.key);
      if (score >= 0.4) {
        final company = _companies[entry.value];
        if (company != null && !seenIds.contains(company.id)) {
          seenIds.add(company.id);
          matches.add({
            'companyId': company.id,
            'companyName': company.name,
            'score': score,
            'matchType': 'alias',
          });
        }
      }
    }
    
    // Check company names
    for (final company in _companies.values) {
      if (!seenIds.contains(company.id)) {
        final normalizedCompanyName = _normalize(company.name);
        final score = normalizedInput.similarityTo(normalizedCompanyName);
        if (score >= 0.4) {
          matches.add({
            'companyId': company.id,
            'companyName': company.name,
            'score': score,
            'matchType': 'name',
          });
        }
      }
    }
    
    // Sort by score descending
    matches.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
    
    // Return top matches
    return matches.take(limit).toList();
  }
  
  // ==================== OWNERSHIP CHAIN ====================
  
  /// Gets the ownership chain for a company.
  /// 
  /// Returns a list of companies from the merchant up to the ultimate parent.
  /// For example: [Save-On-Foods, Pattison Food Group, Jim Pattison Group]
  List<Company> getOwnershipChain(String companyId) {
    final chain = <Company>[];
    String? currentId = companyId;
    final visited = <String>{};
    
    while (currentId != null && !visited.contains(currentId)) {
      visited.add(currentId);
      final company = _companies[currentId];
      if (company == null) break;
      chain.add(company);
      currentId = company.parentId;
    }
    
    return chain;
  }
  
  /// Gets all shareholders for a company with their ownership percentages.
  /// 
  /// This walks up the ownership chain and aggregates shareholder percentages.
  /// For example, if Save-On-Foods is 100% owned by Pattison Food Group,
  /// and Pattison Food Group is 100% owned by Jim Pattison Group,
  /// and Jim Pattison Group is 100% owned by Jim Pattison,
  /// then Jim Pattison effectively has 100% ownership of Save-On-Foods.
  List<Map<String, dynamic>> getShareholders(String companyId) {
    final chain = getOwnershipChain(companyId);
    if (chain.isEmpty) return [];
    
    final shareholderMap = <String, double>{};
    var cumulativeMultiplier = 1.0;
    
    for (final company in chain) {
      final companyShareholders = _ownership[company.id];
      
      if (companyShareholders != null && companyShareholders.isNotEmpty) {
        for (final entry in companyShareholders) {
          final shareholderId = entry['shareholderId'] as String;
          final percentage = entry['percentage'] as double;
          
          final effectivePercentage = percentage * cumulativeMultiplier;
          shareholderMap[shareholderId] = 
              (shareholderMap[shareholderId] ?? 0.0) + effectivePercentage;
        }
      }
      
      // For the next level, we need to account for the fact that
      // ownership percentages at this level apply to the parent
      // This is a simplified model - in reality, ownership structures
      // can be much more complex
      cumulativeMultiplier *= 1.0; // Simplified for now
    }
    
    // Convert to list format
    return shareholderMap.entries.map((entry) => {
      'shareholderId': entry.key,
      'shareholder': _shareholders[entry.key],
      'percentage': entry.value,
    }).toList();
  }
  
  /// Gets a company by ID.
  Company? getCompany(String companyId) => _companies[companyId];
  
  /// Gets a shareholder by ID.
  Individual? getShareholder(String shareholderId) => _shareholders[shareholderId];
  
  /// Gets all companies.
  List<Company> getAllCompanies() => _companies.values.toList();
  
  /// Gets all shareholders.
  List<Individual> getAllShareholders() => _shareholders.values.toList();
  
  /// Searches companies by name (partial match).
  List<Company> searchCompanies(String query) {
    if (query.isEmpty) return [];
    
    final normalizedQuery = _normalize(query);
    return _companies.values.where((company) {
      final normalizedName = _normalize(company.name);
      return normalizedName.contains(normalizedQuery) ||
             normalizedQuery.similarityTo(normalizedName) >= 0.5;
    }).toList();
  }
  
  // ==================== UTILITY ====================
  
  /// Normalizes a string for comparison.
  /// 
  /// Converts to lowercase, removes extra whitespace, and common punctuation.
  String _normalize(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s-]'), '');
  }
  
  /// Clears and reloads all data (useful for testing).
  @visibleForTesting
  void reload() {
    _loadData();
  }
}
