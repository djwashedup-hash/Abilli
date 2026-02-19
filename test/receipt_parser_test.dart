import 'package:abilli/services/receipt_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReceiptParser', () {
    late ReceiptParser parser;
    
    setUp(() {
      parser = ReceiptParser();
    });
    
    group('parse', () {
      test('returns error for empty text', () {
        final result = parser.parse('');
        expect(result.success, isFalse);
        expect(result.error, isNotNull);
      });
      
      test('parses Save-On-Foods receipt', () {
        const receipt = '''
Save-On-Foods
123 Main Street
Nanaimo, BC

Date: 2024-01-15

Apples          \$5.99
Bread           \$3.49
Milk            \$4.99

Total           \$14.47
        ''';
        
        final result = parser.parse(receipt);
        
        expect(result.success, isTrue);
        expect(result.storeName, equals('Save-On-Foods'));
        expect(result.total, equals(14.47));
      });
      
      test('parses Walmart receipt', () {
        const receipt = '''
WALMART
Store #1234

Order Total: \$45.67
Date: 01/15/2024
        ''';
        
        final result = parser.parse(receipt);
        
        expect(result.success, isTrue);
        expect(result.storeName, equals('Walmart'));
        expect(result.total, equals(45.67));
      });
      
      test('parses Starbucks receipt', () {
        const receipt = '''
Starbucks Coffee
Order #12345

Total Charged: \$8.45
Date: 2024-01-15
        ''';
        
        final result = parser.parse(receipt);
        
        expect(result.success, isTrue);
        expect(result.storeName, equals('Starbucks'));
        expect(result.total, equals(8.45));
      });
      
      test('parses generic receipt', () {
        const receipt = '''
My Store
123 Main St

Item 1    \$10.00
Item 2    \$20.00

Total: \$30.00
01/15/2024
        ''';
        
        final result = parser.parse(receipt);
        
        expect(result.success, isTrue);
        expect(result.storeName, isNotNull);
        expect(result.total, equals(30.00));
      });
      
      test('extracts date from receipt', () {
        const receipt = '''
Store Name
Date: 2024-03-15

Total: \$25.00
        ''';
        
        final result = parser.parse(receipt);
        
        expect(result.success, isTrue);
        expect(result.date, isNotNull);
        expect(result.date!.year, equals(2024));
        expect(result.date!.month, equals(3));
        expect(result.date!.day, equals(15));
      });
      
      test('handles various date formats', () {
        final formats = [
          'Date: 01/15/2024',
          'Date: 2024-01-15',
          'Date: 15-01-2024',
          'January 15, 2024',
        ];
        
        for (final format in formats) {
          final receipt = '''
Store Name
$format

Total: \$25.00
          ''';
          
          final result = parser.parse(receipt);
          expect(result.success, isTrue, reason: 'Failed for format: $format');
        }
      });
      
      test('handles various amount formats', () {
        final formats = [
          'Total: \$12.34',
          'Total: 12.34',
          'Total: \$1,234.56',
          'Balance: \$99.99',
        ];
        
        for (final format in formats) {
          final receipt = '''
Store Name
$format
          ''';
          
          final result = parser.parse(receipt);
          expect(result.success, isTrue, reason: 'Failed for format: $format');
          expect(result.total, isNotNull, reason: 'No amount for format: $format');
        }
      });
      
      test('uses largest amount when no total keyword', () {
        const receipt = '''
Store Name

Item 1: \$10.00
Item 2: \$25.00
Item 3: \$5.00
        ''';
        
        final result = parser.parse(receipt);
        
        expect(result.success, isTrue);
        expect(result.total, equals(25.00));
      });
    });
    
    group('ReceiptParseResult', () {
      test('toString for successful parse', () {
        const result = ReceiptParseResult(
          success: true,
          storeName: 'Test Store',
          total: 50.00,
        );
        
        expect(result.toString(), contains('Test Store'));
        expect(result.toString(), contains('50.00'));
      });
      
      test('toString for failed parse', () {
        const result = ReceiptParseResult(
          success: false,
          error: 'Parse error',
        );
        
        expect(result.toString(), contains('Parse error'));
      });
    });
  });
}
