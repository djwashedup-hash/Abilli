import 'package:intl/intl.dart';

/// Parses receipt text to extract purchase information.
/// 
/// Supports multiple receipt formats including:
/// - Save-On-Foods email receipts
/// - Walmart digital receipts
/// - Starbucks purchase confirmations
/// - Generic email receipts
class ReceiptParser {
  /// Parses receipt text and returns extracted data.
  /// 
  /// Returns a map with keys: storeName, total, date, items (optional)
  ReceiptParseResult parse(String receiptText) {
    if (receiptText.isEmpty) {
      return const ReceiptParseResult(success: false, error: 'Empty receipt text');
    }
    
    final lines = receiptText.split('\n');
    
    // Try specific parsers first
    var result = _parseSaveOnFoods(lines);
    if (result.success) return result;
    
    result = _parseWalmart(lines);
    if (result.success) return result;
    
    result = _parseStarbucks(lines);
    if (result.success) return result;
    
    // Fall back to generic parser
    return _parseGeneric(lines);
  }
  
  /// Parses Save-On-Foods email receipt format.
  ReceiptParseResult _parseSaveOnFoods(List<String> lines) {
    // Save-On-Foods receipts typically have:
    // - Store name at the top
    // - "Save-On-Foods" or similar
    // - Total at the bottom with "Total" or "Balance"
    
    String? storeName;
    double? total;
    DateTime? date;
    final items = <String>[];
    
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final lowerLine = line.toLowerCase();
      
      // Look for store name
      if (storeName == null && 
          (lowerLine.contains('save-on-foods') || 
           lowerLine.contains('save on foods'))) {
        storeName = 'Save-On-Foods';
      }
      
      // Look for date
      date ??= _extractDate(line);

      // Look for total
      if (total == null &&
          (lowerLine.contains('total') || lowerLine.contains('balance'))) {
        total = _extractAmount(line);
      }
      
      // Collect item lines (simplified)
      if (line.startsWith(RegExp(r'^\d+\s+'))) {
        items.add(line);
      }
    }
    
    if (storeName != null && total != null) {
      return ReceiptParseResult(
        success: true,
        storeName: storeName,
        total: total,
        date: date ?? DateTime.now(),
        items: items,
      );
    }

    return const ReceiptParseResult(success: false);
  }

  /// Parses Walmart digital receipt format.
  ReceiptParseResult _parseWalmart(List<String> lines) {
    String? storeName;
    double? total;
    DateTime? date;
    
    for (final line in lines) {
      final lowerLine = line.toLowerCase().trim();
      
      // Look for Walmart
      if (storeName == null && 
          (lowerLine.contains('walmart') || lowerLine.contains('wal-mart'))) {
        storeName = 'Walmart';
      }
      
      // Look for date
      date ??= _extractDate(line);

      // Look for total - Walmart often uses "Total" or "Order Total"
      if (total == null && 
          (lowerLine.contains('order total') || 
           (lowerLine.contains('total') && !lowerLine.contains('subtotal')))) {
        total = _extractAmount(line);
      }
    }
    
    if (storeName != null && total != null) {
      return ReceiptParseResult(
        success: true,
        storeName: storeName,
        total: total,
        date: date ?? DateTime.now(),
      );
    }

    return const ReceiptParseResult(success: false);
  }

  /// Parses Starbucks purchase confirmation format.
  ReceiptParseResult _parseStarbucks(List<String> lines) {
    String? storeName;
    double? total;
    DateTime? date;
    
    for (final line in lines) {
      final lowerLine = line.toLowerCase().trim();
      
      // Look for Starbucks
      if (storeName == null && lowerLine.contains('starbucks')) {
        storeName = 'Starbucks';
      }
      
      // Look for date
      date ??= _extractDate(line);

      // Look for total - Starbucks often shows "Total" or just the amount
      if (total == null && 
          (lowerLine.contains('total') || 
           lowerLine.contains('charged'))) {
        total = _extractAmount(line);
      }
    }
    
    if (storeName != null && total != null) {
      return ReceiptParseResult(
        success: true,
        storeName: storeName,
        total: total,
        date: date ?? DateTime.now(),
      );
    }

    return const ReceiptParseResult(success: false);
  }

  /// Generic parser for unknown receipt formats.
  ReceiptParseResult _parseGeneric(List<String> lines) {
    String? storeName;
    double? total;
    DateTime? date;
    
    // Look for store name in first few lines
    for (var i = 0; i < lines.length && i < 5; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty && line.length > 2 && line.length < 50) {
        // Check if it looks like a store name (not an address)
        if (!line.contains(RegExp(r'^\d+')) && 
            !line.contains('@') &&
            !line.toLowerCase().contains('receipt')) {
          storeName = line;
          break;
        }
      }
    }
    
    // Look for total and date in all lines
    for (final line in lines) {
      final lowerLine = line.toLowerCase();

      // Look for date
      date ??= _extractDate(line);
      
      // Look for total - prioritize lines with "total" keyword
      if (total == null) {
        if (lowerLine.contains('total') && 
            !lowerLine.contains('subtotal') &&
            !lowerLine.contains('tax')) {
          total = _extractAmount(line);
        }
      }
    }
    
    // If no total found with "total" keyword, look for the largest amount
    if (total == null) {
      double? maxAmount;
      for (final line in lines) {
        final amount = _extractAmount(line);
        if (amount != null && (maxAmount == null || amount > maxAmount)) {
          maxAmount = amount;
        }
      }
      total = maxAmount;
    }
    
    if (storeName != null && total != null) {
      return ReceiptParseResult(
        success: true,
        storeName: storeName,
        total: total,
        date: date ?? DateTime.now(),
      );
    }
    
    return const ReceiptParseResult(
      success: false,
      error: 'Could not identify store name and total',
    );
  }
  
  /// Extracts a monetary amount from a line of text.
  /// 
  /// Handles formats like: $12.34, 12.34, $1,234.56, etc.
  double? _extractAmount(String line) {
    // Look for dollar amount patterns
    final patterns = [
      RegExp(r'\$([0-9,]+\.\d{2})'),
      RegExp(r'\$?([0-9,]+\.\d{2})'),
      RegExp(r'total[:\s]*\$?([0-9,]+\.\d{2})', caseSensitive: false),
      RegExp(r'balance[:\s]*\$?([0-9,]+\.\d{2})', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final amountStr = match.group(1)?.replaceAll(',', '');
        if (amountStr != null) {
          final amount = double.tryParse(amountStr);
          if (amount != null && amount > 0) {
            return amount;
          }
        }
      }
    }
    
    return null;
  }
  
  /// Extracts a date from a line of text.
  /// 
  /// Handles various date formats.
  DateTime? _extractDate(String line) {
    final patterns = [
      // MM/DD/YYYY
      RegExp(r'(\d{1,2})/(\d{1,2})/(\d{4})'),
      // YYYY-MM-DD
      RegExp(r'(\d{4})-(\d{1,2})-(\d{1,2})'),
      // DD-MM-YYYY
      RegExp(r'(\d{1,2})-(\d{1,2})-(\d{4})'),
      // Month DD, YYYY
      RegExp(r'(\w+)\s+(\d{1,2}),?\s+(\d{4})', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        try {
          // Try parsing with intl package
          final formats = [
            DateFormat('MM/dd/yyyy'),
            DateFormat('yyyy-MM-dd'),
            DateFormat('dd-MM-yyyy'),
            DateFormat('MMMM dd, yyyy'),
            DateFormat('MMM dd, yyyy'),
          ];
          
          for (final format in formats) {
            try {
              return format.parse(line);
            } catch (e) {
              // Try next format
            }
          }
        } catch (e) {
          // Continue to next pattern
        }
      }
    }
    
    return null;
  }
}

/// Result of parsing a receipt.
class ReceiptParseResult {
  final bool success;
  final String? storeName;
  final double? total;
  final DateTime? date;
  final List<String>? items;
  final String? error;
  
  const ReceiptParseResult({
    required this.success,
    this.storeName,
    this.total,
    this.date,
    this.items,
    this.error,
  });
  
  @override
  String toString() {
    if (success) {
      return 'ReceiptParseResult(success: $success, store: $storeName, '
          'total: \$${total?.toStringAsFixed(2)}, date: $date)';
    } else {
      return 'ReceiptParseResult(success: $success, error: $error)';
    }
  }
}
