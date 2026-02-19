import 'package:economic_influence/data/report_generator.dart';
import 'package:economic_influence/models/purchase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportGenerator', () {
    late ReportGenerator generator;
    
    setUp(() {
      generator = ReportGenerator();
    });
    
    group('generateReport', () {
      test('generates report for single purchase', () {
        final purchases = [
          _createPurchase(
            amount: 100.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 15),
          ),
        ];
        
        final report = generator.generateReport(
          purchases: purchases,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        expect(report.purchases.length, equals(1));
        expect(report.totalSpending, equals(100.0));
        expect(report.slices, isNotEmpty);
      });
      
      test('generates report for multiple purchases', () {
        final purchases = [
          _createPurchase(
            amount: 50.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 10),
          ),
          _createPurchase(
            amount: 75.0,
            companyName: 'Save-On-Foods',
            date: DateTime(2024, 1, 15),
          ),
          _createPurchase(
            amount: 25.0,
            companyName: 'Starbucks',
            date: DateTime(2024, 1, 20),
          ),
        ];
        
        final report = generator.generateReport(
          purchases: purchases,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        expect(report.purchases.length, equals(3));
        expect(report.totalSpending, equals(150.0));
      });
      
      test('filters purchases by date range', () {
        final purchases = [
          _createPurchase(
            amount: 50.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 10),
          ),
          _createPurchase(
            amount: 75.0,
            companyName: 'Save-On-Foods',
            date: DateTime(2024, 2, 15),
          ),
        ];
        
        final report = generator.generateReport(
          purchases: purchases,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        expect(report.purchases.length, equals(1));
        expect(report.totalSpending, equals(50.0));
      });
      
      test('generates empty report for no purchases', () {
        final report = generator.generateReport(
          purchases: [],
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        expect(report.purchases, isEmpty);
        expect(report.totalSpending, equals(0.0));
        expect(report.slices, isEmpty);
      });
      
      test('generates empty report for empty month', () {
        final purchases = [
          _createPurchase(
            amount: 50.0,
            companyName: 'Walmart',
            date: DateTime(2024, 2, 10),
          ),
        ];
        
        final report = generator.generateReport(
          purchases: purchases,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        expect(report.purchases, isEmpty);
        expect(report.totalSpending, equals(0.0));
      });
      
      test('calculates illustrative amounts correctly', () {
        final purchases = [
          _createPurchase(
            amount: 100.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 15),
          ),
        ];
        
        final report = generator.generateReport(
          purchases: purchases,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        // Walmart has Walton Family at 45%
        final waltonSlice = report.slices.firstWhere(
          (s) => s.shareholder.name == 'Walton Family',
          orElse: () => throw Exception('Walton Family not found'),
        );
        
        expect(waltonSlice.illustrativeAmount, equals(45.0)); // 100 * 0.45
      });
      
      test('sorts slices by illustrative amount descending', () {
        final purchases = [
          _createPurchase(
            amount: 100.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 15),
          ),
          _createPurchase(
            amount: 100.0,
            companyName: 'Amazon',
            date: DateTime(2024, 1, 16),
          ),
        ];
        
        final report = generator.generateReport(
          purchases: purchases,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        // Verify slices are sorted
        for (var i = 0; i < report.slices.length - 1; i++) {
          expect(
            report.slices[i].illustrativeAmount,
            greaterThanOrEqualTo(report.slices[i + 1].illustrativeAmount),
          );
        }
      });
    });
    
    group('generateDaily', () {
      test('generates daily report', () {
        final purchases = [
          _createPurchase(
            amount: 50.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 15, 10, 30),
          ),
          _createPurchase(
            amount: 25.0,
            companyName: 'Starbucks',
            date: DateTime(2024, 1, 15, 14, 0),
          ),
          _createPurchase(
            amount: 75.0,
            companyName: 'Save-On-Foods',
            date: DateTime(2024, 1, 16),
          ),
        ];
        
        final report = generator.generateDaily(DateTime(2024, 1, 15), purchases);
        
        expect(report.purchases.length, equals(2));
        expect(report.totalSpending, equals(75.0));
      });
    });
    
    group('generateWeekly', () {
      test('generates weekly report', () {
        final purchases = [
          _createPurchase(
            amount: 50.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 15), // Monday
          ),
          _createPurchase(
            amount: 25.0,
            companyName: 'Starbucks',
            date: DateTime(2024, 1, 17), // Wednesday
          ),
          _createPurchase(
            amount: 75.0,
            companyName: 'Save-On-Foods',
            date: DateTime(2024, 1, 22), // Next Monday
          ),
        ];
        
        final weekStart = DateTime(2024, 1, 15);
        final report = generator.generateWeekly(weekStart, purchases);
        
        expect(report.purchases.length, equals(2));
        expect(report.totalSpending, equals(75.0));
      });
    });
    
    group('generateMonthly', () {
      test('generates monthly report', () {
        final purchases = [
          _createPurchase(
            amount: 50.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 10),
          ),
          _createPurchase(
            amount: 25.0,
            companyName: 'Starbucks',
            date: DateTime(2024, 1, 20),
          ),
          _createPurchase(
            amount: 75.0,
            companyName: 'Save-On-Foods',
            date: DateTime(2024, 2, 5),
          ),
        ];
        
        final report = generator.generateMonthly(2024, 1, purchases);
        
        expect(report.purchases.length, equals(2));
        expect(report.totalSpending, equals(75.0));
      });
    });
    
    group('generateYearly', () {
      test('generates yearly report', () {
        final purchases = [
          _createPurchase(
            amount: 50.0,
            companyName: 'Walmart',
            date: DateTime(2024, 1, 10),
          ),
          _createPurchase(
            amount: 25.0,
            companyName: 'Starbucks',
            date: DateTime(2024, 6, 15),
          ),
          _createPurchase(
            amount: 75.0,
            companyName: 'Save-On-Foods',
            date: DateTime(2023, 12, 20),
          ),
        ];
        
        final report = generator.generateYearly(2024, purchases);
        
        expect(report.purchases.length, equals(2));
        expect(report.totalSpending, equals(75.0));
      });
    });
    
    group('getSpendingByCompany', () {
      test('aggregates spending by company', () {
        final purchases = [
          _createPurchase(amount: 50.0, companyName: 'Walmart'),
          _createPurchase(amount: 75.0, companyName: 'Walmart'),
          _createPurchase(amount: 25.0, companyName: 'Starbucks'),
        ];
        
        final byCompany = generator.getSpendingByCompany(purchases);
        
        expect(byCompany['Walmart'], equals(125.0));
        expect(byCompany['Starbucks'], equals(25.0));
      });
    });
    
    group('getSpendingByCategory', () {
      test('categorizes spending', () {
        final purchases = [
          _createPurchase(amount: 50.0, companyName: 'Walmart'),
          _createPurchase(amount: 25.0, companyName: 'Starbucks'),
          _createPurchase(amount: 75.0, companyName: 'McDonald\'s'),
        ];
        
        final byCategory = generator.getSpendingByCategory(purchases);
        
        expect(byCategory, isNotEmpty);
        expect(byCategory.values.reduce((a, b) => a + b), equals(150.0));
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
    id: 'test-$companyName-$amount',
    productName: 'Test Product',
    amount: amount,
    date: date ?? DateTime.now(),
    companyName: companyName,
    createdAt: DateTime.now(),
  );
}
