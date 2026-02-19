import 'package:abilli/models/purchase.dart';
import 'package:abilli/services/purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PurchaseService', () {
    late PurchaseService service;
    
    setUp(() async {
      // Set up mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      
      service = PurchaseService();
      await service.initialize();
    });
    
    tearDown(() async {
      await service.clearAllPurchases();
    });
    
    group('addPurchase', () {
      test('adds a purchase', () async {
        final purchase = _createPurchase(
          amount: 50.0,
          companyName: 'Walmart',
        );
        
        await service.addPurchase(purchase);
        
        expect(service.purchases.length, equals(1));
        expect(service.purchaseCount, equals(1));
        expect(service.totalSpending, equals(50.0));
      });
      
      test('adds multiple purchases', () async {
        await service.addPurchase(_createPurchase(amount: 50.0, companyName: 'Walmart'));
        await service.addPurchase(_createPurchase(amount: 25.0, companyName: 'Starbucks'));
        await service.addPurchase(_createPurchase(amount: 75.0, companyName: 'Save-On-Foods'));
        
        expect(service.purchases.length, equals(3));
        expect(service.totalSpending, equals(150.0));
      });
      
      test('notifies listeners when purchase added', () async {
        var notified = false;
        service.addListener(() {
          notified = true;
        });
        
        await service.addPurchase(_createPurchase(amount: 50.0, companyName: 'Walmart'));
        
        expect(notified, isTrue);
      });
    });
    
    group('removePurchase', () {
      test('removes a purchase by ID', () async {
        final purchase = _createPurchase(amount: 50.0, companyName: 'Walmart');
        await service.addPurchase(purchase);
        
        await service.removePurchase(purchase.id);
        
        expect(service.purchases, isEmpty);
        expect(service.totalSpending, equals(0.0));
      });
      
      test('does nothing for non-existent ID', () async {
        await service.addPurchase(_createPurchase(amount: 50.0, companyName: 'Walmart'));
        
        await service.removePurchase('non-existent-id');
        
        expect(service.purchases.length, equals(1));
      });
    });
    
    group('updatePurchase', () {
      test('updates an existing purchase', () async {
        final purchase = _createPurchase(amount: 50.0, companyName: 'Walmart');
        await service.addPurchase(purchase);
        
        final updated = purchase.copyWith(amount: 75.0);
        await service.updatePurchase(updated);
        
        expect(service.totalSpending, equals(75.0));
      });
      
      test('does nothing for non-existent purchase', () async {
        await service.addPurchase(_createPurchase(amount: 50.0, companyName: 'Walmart'));
        
        final nonExistent = _createPurchase(amount: 100.0, companyName: 'Amazon');
        await service.updatePurchase(nonExistent);
        
        expect(service.totalSpending, equals(50.0));
      });
    });
    
    group('clearAllPurchases', () {
      test('removes all purchases', () async {
        await service.addPurchase(_createPurchase(amount: 50.0, companyName: 'Walmart'));
        await service.addPurchase(_createPurchase(amount: 25.0, companyName: 'Starbucks'));
        
        await service.clearAllPurchases();
        
        expect(service.purchases, isEmpty);
        expect(service.purchaseCount, equals(0));
        expect(service.totalSpending, equals(0.0));
      });
    });
    
    group('getPurchasesInRange', () {
      test('returns purchases in date range', () async {
        final purchase1 = _createPurchase(
          amount: 50.0,
          companyName: 'Walmart',
          date: DateTime(2024, 1, 10),
        );
        final purchase2 = _createPurchase(
          amount: 25.0,
          companyName: 'Starbucks',
          date: DateTime(2024, 1, 15),
        );
        final purchase3 = _createPurchase(
          amount: 75.0,
          companyName: 'Save-On-Foods',
          date: DateTime(2024, 2, 5),
        );
        
        await service.addPurchase(purchase1);
        await service.addPurchase(purchase2);
        await service.addPurchase(purchase3);
        
        final inRange = service.getPurchasesInRange(
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 31),
        );
        
        expect(inRange.length, equals(2));
      });
    });
    
    group('getPurchasesForDate', () {
      test('returns purchases for specific date', () async {
        final purchase1 = _createPurchase(
          amount: 50.0,
          companyName: 'Walmart',
          date: DateTime(2024, 1, 15, 10, 30),
        );
        final purchase2 = _createPurchase(
          amount: 25.0,
          companyName: 'Starbucks',
          date: DateTime(2024, 1, 15, 14, 0),
        );
        final purchase3 = _createPurchase(
          amount: 75.0,
          companyName: 'Save-On-Foods',
          date: DateTime(2024, 1, 16),
        );
        
        await service.addPurchase(purchase1);
        await service.addPurchase(purchase2);
        await service.addPurchase(purchase3);
        
        final forDate = service.getPurchasesForDate(DateTime(2024, 1, 15));
        
        expect(forDate.length, equals(2));
      });
    });
    
    group('getPurchasesForMonth', () {
      test('returns purchases for specific month', () async {
        await service.addPurchase(_createPurchase(
          amount: 50.0,
          companyName: 'Walmart',
          date: DateTime(2024, 1, 10),
        ));
        await service.addPurchase(_createPurchase(
          amount: 25.0,
          companyName: 'Starbucks',
          date: DateTime(2024, 1, 20),
        ));
        await service.addPurchase(_createPurchase(
          amount: 75.0,
          companyName: 'Save-On-Foods',
          date: DateTime(2024, 2, 5),
        ));
        
        final forMonth = service.getPurchasesForMonth(2024, 1);
        
        expect(forMonth.length, equals(2));
      });
    });
    
    group('getPurchasesForYear', () {
      test('returns purchases for specific year', () async {
        await service.addPurchase(_createPurchase(
          amount: 50.0,
          companyName: 'Walmart',
          date: DateTime(2024, 1, 10),
        ));
        await service.addPurchase(_createPurchase(
          amount: 25.0,
          companyName: 'Starbucks',
          date: DateTime(2024, 6, 15),
        ));
        await service.addPurchase(_createPurchase(
          amount: 75.0,
          companyName: 'Save-On-Foods',
          date: DateTime(2023, 12, 20),
        ));
        
        final forYear = service.getPurchasesForYear(2024);
        
        expect(forYear.length, equals(2));
      });
    });
    
    group('getPurchaseById', () {
      test('returns purchase by ID', () async {
        final purchase = _createPurchase(amount: 50.0, companyName: 'Walmart');
        await service.addPurchase(purchase);
        
        final found = service.getPurchaseById(purchase.id);
        
        expect(found, isNotNull);
        expect(found!.id, equals(purchase.id));
      });
      
      test('returns null for non-existent ID', () {
        final found = service.getPurchaseById('non-existent');
        
        expect(found, isNull);
      });
    });
    
    group('getPurchasesByCompany', () {
      test('returns purchases by company name', () async {
        await service.addPurchase(_createPurchase(amount: 50.0, companyName: 'Walmart'));
        await service.addPurchase(_createPurchase(amount: 75.0, companyName: 'Walmart'));
        await service.addPurchase(_createPurchase(amount: 25.0, companyName: 'Starbucks'));
        
        final walmartPurchases = service.getPurchasesByCompany('Walmart');
        
        expect(walmartPurchases.length, equals(2));
      });
      
      test('is case insensitive', () async {
        await service.addPurchase(_createPurchase(amount: 50.0, companyName: 'Walmart'));
        
        final walmartPurchases = service.getPurchasesByCompany('walmart');
        
        expect(walmartPurchases.length, equals(1));
      });
    });
  });
}

/// Helper to create a purchase for testing.
Purchase _createPurchase({
  required double amount,
  required String companyName,
  DateTime? date,
}) {
  return Purchase(
    id: 'test-$companyName-$amount-${DateTime.now().millisecondsSinceEpoch}',
    productName: 'Test Product',
    amount: amount,
    date: date ?? DateTime.now(),
    companyName: companyName,
    createdAt: DateTime.now(),
  );
}
