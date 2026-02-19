import 'package:economic_influence/data/ownership_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OwnershipDatabase', () {
    late OwnershipDatabase database;
    
    setUp(() {
      database = OwnershipDatabase();
    });
    
    group('matchMerchant', () {
      test('returns exact match for alias', () {
        final result = database.matchMerchant('save on foods');
        expect(result, equals('save_on_foods'));
      });
      
      test('returns match for hyphenated alias', () {
        final result = database.matchMerchant('save-on-foods');
        expect(result, equals('save_on_foods'));
      });
      
      test('returns match for uppercase input', () {
        final result = database.matchMerchant('SAVE ON FOODS');
        expect(result, equals('save_on_foods'));
      });
      
      test('returns match for company name', () {
        final result = database.matchMerchant('walmart');
        expect(result, equals('walmart'));
      });
      
      test('returns null for unknown merchant', () {
        final result = database.matchMerchant('unknown store xyz');
        expect(result, isNull);
      });
      
      test('returns null for empty input', () {
        final result = database.matchMerchant('');
        expect(result, isNull);
      });
      
      test('returns match for Tim Hortons variations', () {
        expect(database.matchMerchant('tim hortons'), equals('tim_hortons'));
        expect(database.matchMerchant('timhortons'), equals('tim_hortons'));
        expect(database.matchMerchant('tims'), equals('tim_hortons'));
      });
      
      test('returns match for Starbucks variations', () {
        expect(database.matchMerchant('starbucks'), equals('starbucks'));
        expect(database.matchMerchant('sbux'), equals('starbucks'));
      });
      
      test('returns match for McDonald\'s variations', () {
        expect(database.matchMerchant('mcdonalds'), equals('mcdonalds'));
        expect(database.matchMerchant("mcdonald's"), equals('mcdonalds'));
      });
    });
    
    group('findPossibleMatches', () {
      test('returns multiple matches for partial input', () {
        final results = database.findPossibleMatches('save', limit: 3);
        expect(results, isNotEmpty);
        expect(results.length, lessThanOrEqualTo(3));
      });
      
      test('returns matches sorted by score', () {
        final results = database.findPossibleMatches('walmart');
        expect(results, isNotEmpty);
        if (results.length > 1) {
          expect(results[0]['score'], greaterThanOrEqualTo(results[1]['score'] as double));
        }
      });
      
      test('returns empty list for no matches', () {
        final results = database.findPossibleMatches('xyznonexistent');
        expect(results, isEmpty);
      });
      
      test('respects limit parameter', () {
        final results = database.findPossibleMatches('a', limit: 2);
        expect(results.length, lessThanOrEqualTo(2));
      });
    });
    
    group('getOwnershipChain', () {
      test('returns chain for company with parent', () {
        final chain = database.getOwnershipChain('save_on_foods');
        expect(chain, isNotEmpty);
        expect(chain.first.id, equals('save_on_foods'));
      });
      
      test('returns full chain for nested ownership', () {
        final chain = database.getOwnershipChain('save_on_foods');
        expect(chain.length, greaterThanOrEqualTo(2));
        
        // Should include Save-On-Foods and its parents
        final ids = chain.map((c) => c.id).toList();
        expect(ids, contains('save_on_foods'));
      });
      
      test('returns single company for top-level company', () {
        final chain = database.getOwnershipChain('walmart');
        expect(chain.length, equals(1));
        expect(chain.first.id, equals('walmart'));
      });
      
      test('returns empty list for unknown company', () {
        final chain = database.getOwnershipChain('unknown');
        expect(chain, isEmpty);
      });
      
      test('handles co-op with no parent', () {
        final chain = database.getOwnershipChain('country_grocer');
        expect(chain, isNotEmpty);
        expect(chain.first.isCooperative, isTrue);
      });
    });
    
    group('getShareholders', () {
      test('returns shareholders for company', () {
        final shareholders = database.getShareholders('walmart');
        expect(shareholders, isNotEmpty);
      });
      
      test('returns Walton family for Walmart', () {
        final shareholders = database.getShareholders('walmart');
        final waltonShareholder = shareholders.firstWhere(
          (s) => s['shareholderId'] == 'walton_family',
          orElse: () => {},
        );
        expect(waltonShareholder, isNotNull);
        if (waltonShareholder.isNotEmpty) {
          expect(waltonShareholder['percentage'], equals(45.0));
        }
      });
      
      test('returns Bezos for Amazon', () {
        final shareholders = database.getShareholders('amazon');
        final bezosShareholder = shareholders.firstWhere(
          (s) => s['shareholderId'] == 'jeff_bezos',
          orElse: () => {},
        );
        expect(bezosShareholder, isNotNull);
        if (bezosShareholder.isNotEmpty) {
          expect(bezosShareholder['percentage'], equals(8.3));
        }
      });
      
      test('returns empty list for unknown company', () {
        final shareholders = database.getShareholders('unknown');
        expect(shareholders, isEmpty);
      });
    });
    
    group('getCompany', () {
      test('returns company by ID', () {
        final company = database.getCompany('walmart');
        expect(company, isNotNull);
        expect(company!.name, equals('Walmart Inc.'));
      });
      
      test('returns null for unknown ID', () {
        final company = database.getCompany('unknown');
        expect(company, isNull);
      });
    });
    
    group('getShareholder', () {
      test('returns shareholder by ID', () {
        final shareholder = database.getShareholder('jeff_bezos');
        expect(shareholder, isNotNull);
        expect(shareholder!.name, equals('Jeff Bezos'));
      });
      
      test('returns null for unknown ID', () {
        final shareholder = database.getShareholder('unknown');
        expect(shareholder, isNull);
      });
    });
    
    group('searchCompanies', () {
      test('returns companies matching query', () {
        final results = database.searchCompanies('food');
        expect(results, isNotEmpty);
      });
      
      test('returns empty list for no matches', () {
        final results = database.searchCompanies('xyznonexistent');
        expect(results, isEmpty);
      });
      
      test('returns empty list for empty query', () {
        final results = database.searchCompanies('');
        expect(results, isEmpty);
      });
    });
    
    group('getAllCompanies', () {
      test('returns all companies', () {
        final companies = database.getAllCompanies();
        expect(companies, isNotEmpty);
        expect(companies.length, greaterThan(40)); // Should have 40+ companies
      });
    });
    
    group('getAllShareholders', () {
      test('returns all shareholders', () {
        final shareholders = database.getAllShareholders();
        expect(shareholders, isNotEmpty);
      });
    });
  });
}
