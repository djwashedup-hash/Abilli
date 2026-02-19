import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/purchase.dart';

/// Service for managing purchases.
/// 
/// Uses ChangeNotifier for state management. All purchases are stored
/// locally using SharedPreferences. No data is sent to any server.
class PurchaseService extends ChangeNotifier {
  static const String _storageKey = 'economic_influence_purchases';
  
  List<Purchase> _purchases = [];
  bool _isLoading = false;
  String? _error;
  
  /// All purchases in the system.
  List<Purchase> get purchases => List.unmodifiable(_purchases);
  
  /// Whether data is currently loading.
  bool get isLoading => _isLoading;
  
  /// Current error message, if any.
  String? get error => _error;
  
  /// Total number of purchases.
  int get purchaseCount => _purchases.length;
  
  /// Total spending across all purchases.
  double get totalSpending => _purchases.fold<double>(
    0.0,
    (sum, purchase) => sum + purchase.amount,
  );
  
  /// Initializes the service by loading purchases from storage.
  Future<void> initialize() async {
    await _loadPurchases();
  }
  
  // ==================== CRUD OPERATIONS ====================
  
  /// Adds a new purchase.
  Future<void> addPurchase(Purchase purchase) async {
    _setLoading(true);
    
    try {
      _purchases.add(purchase);
      await _savePurchases();
      notifyListeners();
    } catch (e) {
      _setError('Failed to add purchase: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Removes a purchase by ID.
  Future<void> removePurchase(String purchaseId) async {
    _setLoading(true);
    
    try {
      _purchases.removeWhere((p) => p.id == purchaseId);
      await _savePurchases();
      notifyListeners();
    } catch (e) {
      _setError('Failed to remove purchase: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Updates an existing purchase.
  Future<void> updatePurchase(Purchase updatedPurchase) async {
    _setLoading(true);
    
    try {
      final index = _purchases.indexWhere((p) => p.id == updatedPurchase.id);
      if (index >= 0) {
        _purchases[index] = updatedPurchase;
        await _savePurchases();
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update purchase: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Clears all purchases.
  Future<void> clearAllPurchases() async {
    _setLoading(true);
    
    try {
      _purchases.clear();
      await _savePurchases();
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear purchases: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // ==================== QUERY OPERATIONS ====================
  
  /// Gets purchases for a specific date range.
  List<Purchase> getPurchasesInRange(DateTime start, DateTime end) {
    return _purchases.where((purchase) {
      return purchase.date.isAfter(start.subtract(const Duration(days: 1))) &&
             purchase.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }
  
  /// Gets purchases for a specific date.
  List<Purchase> getPurchasesForDate(DateTime date) {
    return _purchases.where((purchase) {
      return purchase.date.year == date.year &&
             purchase.date.month == date.month &&
             purchase.date.day == date.day;
    }).toList();
  }
  
  /// Gets purchases for a specific month.
  List<Purchase> getPurchasesForMonth(int year, int month) {
    return _purchases.where((purchase) {
      return purchase.date.year == year && purchase.date.month == month;
    }).toList();
  }
  
  /// Gets purchases for a specific year.
  List<Purchase> getPurchasesForYear(int year) {
    return _purchases.where((purchase) {
      return purchase.date.year == year;
    }).toList();
  }
  
  /// Gets purchases for the current month.
  List<Purchase> getCurrentMonthPurchases() {
    final now = DateTime.now();
    return getPurchasesForMonth(now.year, now.month);
  }
  
  /// Gets purchases for the current week.
  List<Purchase> getCurrentWeekPurchases() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return getPurchasesInRange(weekStart, weekEnd);
  }
  
  /// Gets purchases for today.
  List<Purchase> getTodayPurchases() {
    return getPurchasesForDate(DateTime.now());
  }
  
  /// Gets a purchase by ID.
  Purchase? getPurchaseById(String id) {
    try {
      return _purchases.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Gets purchases by company name.
  List<Purchase> getPurchasesByCompany(String companyName) {
    return _purchases.where((p) => 
      p.companyName.toLowerCase() == companyName.toLowerCase()
    ).toList();
  }
  
  // ==================== STORAGE ====================
  
  /// Loads purchases from SharedPreferences.
  Future<void> _loadPurchases() async {
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        _purchases = jsonList
            .map((json) => Purchase(
                  id: json['id'],
                  productName: json['productName'],
                  amount: json['amount'],
                  date: DateTime.parse(json['date']),
                  companyName: json['companyName'],
                  merchantAlias: json['merchantAlias'],
                  notes: json['notes'],
                  createdAt: DateTime.parse(json['createdAt']),
                ))
            .toList();
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load purchases: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Saves purchases to SharedPreferences.
  Future<void> _savePurchases() async {
    final prefs = await SharedPreferences.getInstance();
    
    final jsonList = _purchases.map((purchase) => {
      'id': purchase.id,
      'productName': purchase.productName,
      'amount': purchase.amount,
      'date': purchase.date.toIso8601String(),
      'companyName': purchase.companyName,
      'merchantAlias': purchase.merchantAlias,
      'notes': purchase.notes,
      'createdAt': purchase.createdAt.toIso8601String(),
    }).toList();
    
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
  
  // ==================== STATE MANAGEMENT ====================
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
  
  /// Clears any error message.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
