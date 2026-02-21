// lib/services/shopping_list_service.dart
// Smart shopping list with purchase pattern learning

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_item.dart';
import '../models/alternative.dart';

/// Service for managing smart shopping list
class ShoppingListService extends ChangeNotifier {
  static const String _storageKey = 'abilli_shopping_list';
  static const String _patternsKey = 'abilli_purchase_patterns';
  
  List<ShoppingItem> _items = [];
  Map<String, PurchasePattern> _patterns = {};
  bool _isLoading = false;
  
  final _itemsController = StreamController<List<ShoppingItem>>.broadcast();
  Stream<List<ShoppingItem>> get itemsStream => _itemsController.stream;

  List<ShoppingItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  List<ShoppingItem> get uncheckedItems => 
    _items.where((i) => !i.isChecked).toList();
  
  List<ShoppingItem> get checkedItems => 
    _items.where((i) => i.isChecked).toList();

  List<ShoppingItem> get itemsByUrgency {
    final unchecked = uncheckedItems;
    unchecked.sort((a, b) => a.urgency.priority.compareTo(b.urgency.priority));
    return unchecked;
  }

  Map<UrgencyLevel, List<ShoppingItem>> get itemsByUrgencyGroup {
    final grouped = <UrgencyLevel, List<ShoppingItem>>{};
    for (final level in UrgencyLevel.values) {
      grouped[level] = [];
    }
    for (final item in uncheckedItems) {
      grouped[item.urgency]!.add(item);
    }
    return grouped;
  }

  List<ShoppingItem> get predictedItems {
    return uncheckedItems
      .where((i) => i.isPredicted && i.urgency != UrgencyLevel.later)
      .toList();
  }

  List<ShoppingItem> get urgentItems {
    return uncheckedItems.where((i) => 
      i.urgency == UrgencyLevel.overdue || 
      i.urgency == UrgencyLevel.urgent
    ).toList();
  }

  Future<void> initialize() async {
    await _loadItems();
    await _loadPatterns();
  }

  Future<void> addItem({
    required String name,
    required String category,
    String? notes,
    List<AlternativeSuggestion>? alternativeSuggestions,
    bool isPredicted = false,
    String? predictedFromProductId,
  }) async {
    final item = ShoppingItem(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}_${name.hashCode}',
      name: name,
      category: category,
      notes: notes,
      purchasePattern: _patterns[name.toLowerCase()],
      alternativeSuggestions: alternativeSuggestions ?? [],
      addedDate: DateTime.now(),
      isPredicted: isPredicted,
      predictedFromProductId: predictedFromProductId,
    );

    _items.add(item);
    await _saveItems();
    _notifyUpdate();
  }

  Future<void> addItems(List<({String name, String category})> items) async {
    for (final itemData in items) {
      final item = ShoppingItem(
        id: 'item_${DateTime.now().millisecondsSinceEpoch}_${itemData.name.hashCode}',
        name: itemData.name,
        category: itemData.category,
        purchasePattern: _patterns[itemData.name.toLowerCase()],
        addedDate: DateTime.now(),
      );
      _items.add(item);
    }
    await _saveItems();
    _notifyUpdate();
  }

  Future<void> checkItem(String itemId) async {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    _items[index] = _items[index].check();
    await _updatePattern(_items[index]);
    await _saveItems();
    _notifyUpdate();
  }

  Future<void> uncheckItem(String itemId) async {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    _items[index] = _items[index].uncheck();
    await _saveItems();
    _notifyUpdate();
  }

  Future<void> removeItem(String itemId) async {
    _items.removeWhere((i) => i.id == itemId);
    await _saveItems();
    _notifyUpdate();
  }

  Future<void> clearCheckedItems() async {
    _items.removeWhere((i) => i.isChecked);
    await _saveItems();
    _notifyUpdate();
  }

  Future<void> updateItemNotes(String itemId, String? notes) async {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    final oldItem = _items[index];
    _items[index] = ShoppingItem(
      id: oldItem.id,
      name: oldItem.name,
      category: oldItem.category,
      notes: notes,
      purchasePattern: oldItem.purchasePattern,
      alternativeSuggestions: oldItem.alternativeSuggestions,
      isChecked: oldItem.isChecked,
      addedDate: oldItem.addedDate,
      checkedDate: oldItem.checkedDate,
      isPredicted: oldItem.isPredicted,
      predictedFromProductId: oldItem.predictedFromProductId,
    );
    
    await _saveItems();
    _notifyUpdate();
  }

  Future<void> setAlternatives(
    String itemId, 
    List<AlternativeSuggestion> alternatives
  ) async {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    final oldItem = _items[index];
    _items[index] = ShoppingItem(
      id: oldItem.id,
      name: oldItem.name,
      category: oldItem.category,
      notes: oldItem.notes,
      purchasePattern: oldItem.purchasePattern,
      alternativeSuggestions: alternatives,
      isChecked: oldItem.isChecked,
      addedDate: oldItem.addedDate,
      checkedDate: oldItem.checkedDate,
      isPredicted: oldItem.isPredicted,
      predictedFromProductId: oldItem.predictedFromProductId,
    );
    
    await _saveItems();
    _notifyUpdate();
  }

  Future<void> rebuildPatterns(List<({String name, DateTime date, double amount})> purchases) async {
    final byName = <String, List<PurchaseRecord>>{};
    for (final p in purchases) {
      final key = p.name.toLowerCase();
      byName.putIfAbsent(key, () => []);
      byName[key]!.add(PurchaseRecord(date: p.date, amount: p.amount));
    }

    _patterns = {};
    for (final entry in byName.entries) {
      final pattern = PurchasePattern.fromPurchases(entry.value);
      if (pattern.purchaseCount >= 2) {
        _patterns[entry.key] = pattern;
      }
    }

    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      final pattern = _patterns[item.name.toLowerCase()];
      if (pattern != null) {
        _items[i] = ShoppingItem(
          id: item.id,
          name: item.name,
          category: item.category,
          notes: item.notes,
          purchasePattern: pattern,
          alternativeSuggestions: item.alternativeSuggestions,
          isChecked: item.isChecked,
          addedDate: item.addedDate,
          checkedDate: item.checkedDate,
          isPredicted: item.isPredicted,
          predictedFromProductId: item.predictedFromProductId,
        );
      }
    }

    await _savePatterns();
    await _saveItems();
    _notifyUpdate();
  }

  List<ShoppingItem> generatePredictions() {
    final predictions = <ShoppingItem>[];
    final now = DateTime.now();

    for (final entry in _patterns.entries) {
      final pattern = entry.value;
      if (pattern.confidence < 0.3) continue;

      final nextPurchase = pattern.predictNextPurchase();
      if (nextPurchase == null) continue;

      final daysUntil = nextPurchase.difference(now).inDays;
      if (daysUntil > 7) continue;

      final alreadyOnList = _items.any((i) => 
        i.name.toLowerCase() == entry.key && 
        !i.isChecked &&
        !i.isPredicted
      );
      if (alreadyOnList) continue;

      predictions.add(ShoppingItem(
        id: 'predicted_${entry.key}_${now.millisecondsSinceEpoch}',
        name: entry.key,
        category: 'Predicted',
        purchasePattern: pattern,
        addedDate: now,
        isPredicted: true,
        predictedFromProductId: entry.key,
      ));
    }

    return predictions;
  }

  Future<void> addPredictions() async {
    final predictions = generatePredictions();
    for (final item in predictions) {
      final exists = _items.any((i) => 
        i.name.toLowerCase() == item.name.toLowerCase() && !i.isChecked
      );
      if (!exists) {
        _items.add(item);
      }
    }
    await _saveItems();
    _notifyUpdate();
  }

  Map<String, List<ShoppingItem>> get itemsByCategory {
    final grouped = <String, List<ShoppingItem>>{};
    for (final item in uncheckedItems) {
      grouped.putIfAbsent(item.category, () => []);
      grouped[item.category]!.add(item);
    }
    return grouped;
  }

  ({int total, int checked, double percent}) get stats {
    final total = _items.length;
    final checked = _items.where((i) => i.isChecked).length;
    final percent = total > 0 ? ((checked / total) * 100).toDouble() : 0.0;
    return (total: total, checked: checked, percent: percent);
  }

  List<ShoppingItem> search(String query) {
    final lower = query.toLowerCase();
    return _items.where((i) =>
      i.name.toLowerCase().contains(lower) ||
      i.category.toLowerCase().contains(lower) ||
      (i.notes?.toLowerCase().contains(lower) ?? false)
    ).toList();
  }

  Future<void> _loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      
      if (jsonStr != null) {
        final jsonList = jsonDecode(jsonStr) as List;
        _items = jsonList.map((j) => _itemFromJson(j)).toList();
      }
    } catch (e) {
      debugPrint('Error loading shopping list: $e');
      _items = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _items.map((i) => i.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving shopping list: $e');
    }
  }

  Future<void> _loadPatterns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_patternsKey);
      
      if (jsonStr != null) {
        final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
        _patterns = jsonMap.map((k, v) => 
          MapEntry(k, PurchasePattern.fromJson(v))
        );
      }
    } catch (e) {
      debugPrint('Error loading patterns: $e');
      _patterns = {};
    }
  }

  Future<void> _savePatterns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonMap = _patterns.map((k, v) => MapEntry(k, v.toJson()));
      await prefs.setString(_patternsKey, jsonEncode(jsonMap));
    } catch (e) {
      debugPrint('Error saving patterns: $e');
    }
  }

  Future<void> _updatePattern(ShoppingItem item) async {
    if (item.checkedDate == null) return;

    final key = item.name.toLowerCase();
    final existingPattern = _patterns[key];
    
    final dates = existingPattern?.purchaseDates ?? [];
    final amounts = existingPattern?.purchaseAmounts ?? [];
    
    dates.add(item.checkedDate!);
    amounts.add(10.0);

    final purchases = <PurchaseRecord>[];
    for (int i = 0; i < dates.length && i < amounts.length; i++) {
      purchases.add(PurchaseRecord(date: dates[i], amount: amounts[i]));
    }

    _patterns[key] = PurchasePattern.fromPurchases(purchases);
    await _savePatterns();
  }

  ShoppingItem _itemFromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      notes: json['notes'],
      purchasePattern: json['purchasePattern'] != null
        ? PurchasePattern.fromJson(json['purchasePattern'])
        : null,
      alternativeSuggestions: const [],
      isChecked: json['isChecked'] ?? false,
      addedDate: DateTime.parse(json['addedDate']),
      checkedDate: json['checkedDate'] != null 
        ? DateTime.parse(json['checkedDate'])
        : null,
      isPredicted: json['isPredicted'] ?? false,
      predictedFromProductId: json['predictedFromProductId'],
    );
  }

  void _notifyUpdate() {
    notifyListeners();
    _itemsController.add(List.unmodifiable(_items));
  }

  @override
  void dispose() {
    _itemsController.close();
    super.dispose();
  }
}
