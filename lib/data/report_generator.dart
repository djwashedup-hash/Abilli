import '../models/purchase.dart';
import '../models/monthly_report.dart';
import '../models/individual.dart';
import 'ownership_database.dart';

/// Generates spending reports by connecting purchases to shareholders.
/// 
/// This service accumulates all purchases in a date range and computes
/// illustrative amounts for each shareholder based on ownership chains.
class ReportGenerator {
  final OwnershipDatabase _database;
  
  ReportGenerator({OwnershipDatabase? database}) 
      : _database = database ?? OwnershipDatabase();
  
  /// Generates a spending report for the given date range.
  /// 
  /// [purchases] - All purchases to include in the report
  /// [startDate] - Start of the reporting period
  /// [endDate] - End of the reporting period
  SpendingReport generateReport({
    required List<Purchase> purchases,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Filter purchases to the date range
    final filteredPurchases = purchases.where((purchase) {
      return purchase.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
             purchase.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    
    // Calculate total spending
    final totalSpending = filteredPurchases.fold<double>(
      0.0,
      (sum, purchase) => sum + purchase.amount,
    );
    
    // Aggregate shareholder data
    final shareholderData = <String, _ShareholderAccumulator>{};
    
    for (final purchase in filteredPurchases) {
      final companyId = _database.matchMerchant(purchase.companyName);
      if (companyId == null) continue;
      
      final shareholders = _database.getShareholders(companyId);
      
      for (final entry in shareholders) {
        final shareholder = entry['shareholder'] as Individual?;
        final percentage = entry['percentage'] as double?;
        
        if (shareholder == null || percentage == null) continue;
        
        final accumulator = shareholderData.putIfAbsent(
          shareholder.id,
          () => _ShareholderAccumulator(shareholder: shareholder),
        );
        
        accumulator.addPurchase(purchase, percentage);
      }
    }
    
    // Create report slices
    final slices = shareholderData.values.map((accumulator) {
      return ReportSlice(
        shareholder: accumulator.shareholder,
        ownershipPercentage: accumulator.weightedAveragePercentage,
        illustrativeAmount: accumulator.totalIllustrativeAmount,
        contributingPurchases: List.unmodifiable(accumulator.purchases),
      );
    }).toList();
    
    // Sort by illustrative amount descending
    slices.sort((a, b) => b.illustrativeAmount.compareTo(a.illustrativeAmount));
    
    return SpendingReport(
      startDate: startDate,
      endDate: endDate,
      purchases: List.unmodifiable(filteredPurchases),
      slices: List.unmodifiable(slices),
      totalSpending: totalSpending,
    );
  }
  
  /// Generates a daily report.
  SpendingReport generateDaily(DateTime date, List<Purchase> purchases) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    
    return generateReport(
      purchases: purchases,
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }
  
  /// Generates a weekly report.
  SpendingReport generateWeekly(DateTime weekStart, List<Purchase> purchases) {
    final endOfWeek = weekStart.add(const Duration(days: 7)).subtract(const Duration(milliseconds: 1));
    
    return generateReport(
      purchases: purchases,
      startDate: weekStart,
      endDate: endOfWeek,
    );
  }
  
  /// Generates a monthly report.
  SpendingReport generateMonthly(int year, int month, List<Purchase> purchases) {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = (month < 12)
        ? DateTime(year, month + 1, 1).subtract(const Duration(milliseconds: 1))
        : DateTime(year + 1, 1, 1).subtract(const Duration(milliseconds: 1));
    
    return generateReport(
      purchases: purchases,
      startDate: startOfMonth,
      endDate: endOfMonth,
    );
  }
  
  /// Generates a yearly report.
  SpendingReport generateYearly(int year, List<Purchase> purchases) {
    return generateReport(
      purchases: purchases,
      startDate: DateTime(year, 1, 1),
      endDate: DateTime(year, 12, 31, 23, 59, 59),
    );
  }
  
  /// Gets the current week's start date (Monday).
  DateTime getCurrentWeekStart() {
    final now = DateTime.now();
    final weekday = now.weekday;
    return now.subtract(Duration(days: weekday - 1));
  }
  
  /// Gets spending totals by company for a list of purchases.
  Map<String, double> getSpendingByCompany(List<Purchase> purchases) {
    final totals = <String, double>{};
    
    for (final purchase in purchases) {
      totals[purchase.companyName] = 
          (totals[purchase.companyName] ?? 0.0) + purchase.amount;
    }
    
    return totals;
  }
  
  /// Gets spending totals by category for a list of purchases.
  /// 
  /// Categories are determined by matching merchant names to company categories.
  Map<String, double> getSpendingByCategory(List<Purchase> purchases) {
    final totals = <String, double>{};
    
    for (final purchase in purchases) {
      final companyId = _database.matchMerchant(purchase.companyName);
      String category = 'Other';
      
      if (companyId != null) {
        final company = _database.getCompany(companyId);
        category = _categorizeCompany(company?.name ?? '');
      }
      
      totals[category] = (totals[category] ?? 0.0) + purchase.amount;
    }
    
    return totals;
  }
  
  /// Categorizes a company name into a spending category.
  String _categorizeCompany(String companyName) {
    final name = companyName.toLowerCase();
    
    if (name.contains('grocery') || 
        name.contains('foods') || 
        name.contains('superstore') ||
        name.contains('walmart') ||
        name.contains('costco')) {
      return 'Groceries';
    }
    
    if (name.contains('restaurant') ||
        name.contains('mcdonald') ||
        name.contains('burger') ||
        name.contains('pizza') ||
        name.contains('taco') ||
        name.contains('wendy') ||
        name.contains('subway') ||
        name.contains('kfc')) {
      return 'Dining';
    }
    
    if (name.contains('coffee') ||
        name.contains('starbucks') ||
        name.contains('tim hortons') ||
        name.contains('a&w')) {
      return 'Coffee & Snacks';
    }
    
    if (name.contains('pharmacy') ||
        name.contains('drug') ||
        name.contains('cvs') ||
        name.contains('walgreens')) {
      return 'Health & Pharmacy';
    }
    
    if (name.contains('gas') ||
        name.contains('petro') ||
        name.contains('shell') ||
        name.contains('esso') ||
        name.contains('oil')) {
      return 'Fuel';
    }
    
    if (name.contains('liquor') ||
        name.contains('beer') ||
        name.contains('wine')) {
      return 'Alcohol';
    }
    
    if (name.contains('home') ||
        name.contains('hardware') ||
        name.contains('ikea') ||
        name.contains('best buy')) {
      return 'Home & Electronics';
    }
    
    return 'Other';
  }
}

/// Internal class for accumulating shareholder data during report generation.
class _ShareholderAccumulator {
  final Individual shareholder;
  final List<Purchase> purchases = [];
  final List<double> percentages = [];
  double totalIllustrativeAmount = 0.0;
  
  _ShareholderAccumulator({required this.shareholder});
  
  void addPurchase(Purchase purchase, double percentage) {
    purchases.add(purchase);
    percentages.add(percentage);
    totalIllustrativeAmount += purchase.amount * (percentage / 100.0);
  }
  
  double get weightedAveragePercentage {
    if (percentages.isEmpty) return 0.0;
    
    double totalWeight = 0.0;
    double weightedSum = 0.0;
    
    for (var i = 0; i < percentages.length; i++) {
      final weight = purchases[i].amount;
      totalWeight += weight;
      weightedSum += percentages[i] * weight;
    }
    
    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }
}
