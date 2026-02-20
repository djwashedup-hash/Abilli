import 'package:intl/intl.dart';

/// Parses receipt text to extract purchase information.
/// 
/// Supports 50+ receipt formats including:
/// - Canadian retailers: Save-On-Foods, Quality Foods, Thrifty Foods, Loblaw, etc.
/// - US retailers: Walmart, Target, Costco, Amazon, etc.
/// - Restaurants: McDonald's, Starbucks, Tim Hortons, etc.
/// - Gas stations: Petro-Canada, Shell, Esso, etc.
class ReceiptParser {
  /// Known retailer patterns for matching
  final Map<String, List<String>> _retailerPatterns = {
    // Canadian Grocers
    'Save-On-Foods': ['save on foods', 'save-on-foods', 'saveonfoods', 'sof #'],
    'Quality Foods': ['quality foods', 'qualityfoods', 'qf nanaimo', 'qf #'],
    'Thrifty Foods': ['thrifty foods', 'thriftyfoods'],
    'Loblaws': ['loblaw', 'loblaws', 'real canadian superstore', 'superstore', 'no frills', 'nofrills'],
    'Shoppers Drug Mart': ['shoppers drug mart', 'shoppers', 'shoppers #'],
    'Sobeys': ['sobeys', 'sobeys #'],
    'Safeway': ['safeway', 'safeway #'],
    'Country Grocer': ['country grocer'],
    'Red Apple': ['red apple', 'red apple stores'],
    
    // US/International Retailers
    'Walmart': ['walmart', 'wal-mart', 'wmt #', 'walmart.com'],
    'Costco': ['costco', 'costco wholesale', 'costco #'],
    'Target': ['target', 'target store', 'target #'],
    'Amazon': ['amazon', 'amazon.com', 'amzn', 'prime'],
    'Whole Foods': ['whole foods', 'wholefoods', 'whole foods market'],
    'Home Depot': ['home depot', 'homedepot', 'thd #'],
    'Best Buy': ['best buy', 'bestbuy', 'bestbuy.com'],
    'IKEA': ['ikea'],
    
    // Restaurants - Fast Food
    "McDonald's": ['mcdonalds', "mcdonald's", 'mc donalds'],
    'Starbucks': ['starbucks', 'sbux', 'starbucks coffee'],
    'Tim Hortons': ['tim hortons', 'timhortons', 'tims'],
    'Burger King': ['burger king', 'burgerking', 'bk #'],
    'Wendy\'s': ['wendys', "wendy's"],
    'Subway': ['subway', 'subway restaurant'],
    'Taco Bell': ['taco bell', 'tacobell'],
    'KFC': ['kfc', 'kentucky fried chicken'],
    'Pizza Hut': ['pizza hut', 'pizzahut'],
    'A&W': ['a&w', 'a and w', 'a+w'],
    'Dairy Queen': ['dairy queen', 'dq'],
    'Popeyes': ['popeyes', 'popeyes louisiana kitchen'],
    
    // Coffee/Snacks
    'Dunkin': ['dunkin', 'dunkin donuts'],
    'Krispy Kreme': ['krispy kreme'],
    'Cinnabon': ['cinnabon'],
    
    // Gas Stations
    'Petro-Canada': ['petro-canada', 'petro canada', 'petrocanada'],
    'Shell': ['shell', 'shell canada'],
    'Esso': ['esso', 'esso station'],
    'Chevron': ['chevron'],
    'Mobil': ['mobil'],
    'Texaco': ['texaco'],
    
    // Pharmacies
    'CVS': ['cvs', 'cvs pharmacy', 'cvs health'],
    'Walgreens': ['walgreens', 'walgreen'],
    'Rexall': ['rexall', 'rexall pharmacy'],
    'London Drugs': ['london drugs', 'londondrugs'],
    
    // Convenience
    '7-Eleven': ['7-eleven', '7 eleven', '7eleven'],
    'Circle K': ['circle k'],
    
    // Liquor
    'BC Liquor': ['bc liquor', 'bc liquor store', 'bcl'],
    'SAQ': ['saq'],
    'LCBO': ['lcbo'],
    
    // Canadian Retailers
    'Canadian Tire': ['canadian tire', 'canadiantire'],
    'Dollarama': ['dollarama'],
    'Mark\'s': ['mark\'s', 'marks', 'l\'equipeur'],
    'Winners': ['winners'],
    'HomeSense': ['homesense', 'home sense'],
    'MEC': ['mec', 'mountain equipment company', 'mountain equipment co-op'],
    
    // Hardware/Home
    'Lowe\'s': ['lowe\'s', 'lowes'],
    'Rona': ['rona'],
    'Home Hardware': ['home hardware'],
    
    // Electronics
    'Apple Store': ['apple store', 'apple.com'],
    'The Source': ['the source'],
    
    // Office/School
    'Staples': ['staples'],
    'Office Depot': ['office depot'],
    
    // Books
    'Indigo': ['indigo', 'chapters'],
    
    // Sporting Goods
    'Sport Chek': ['sport chek', 'sportchek'],
    'Decathlon': ['decathlon'],
  };

  /// Parses receipt text and returns extracted data.
  /// 
  /// Returns a map with keys: storeName, total, date, items (optional)
  ReceiptParseResult parse(String receiptText) {
    if (receiptText.isEmpty) {
      return ReceiptParseResult(success: false, error: 'Empty receipt text');
    }
    
    final lines = receiptText.split('\n');
    final normalizedText = receiptText.toLowerCase();
    
    // Try specific parsers first
    var result = _parseSaveOnFoods(lines);
    if (result.success) return result;
    
    result = _parseWalmart(lines);
    if (result.success) return result;
    
    result = _parseStarbucks(lines);
    if (result.success) return result;
    
    result = _parseTimHortons(lines);
    if (result.success) return result;
    
    result = _parseMcDonalds(lines);
    if (result.success) return result;
    
    result = _parseCostco(lines);
    if (result.success) return result;
    
    result = _parseAmazon(lines);
    if (result.success) return result;
    
    // Fall back to generic parser
    return _parseGeneric(lines, normalizedText);
  }
  
  /// Detects retailer from receipt text
  String? detectRetailer(String text) {
    final normalized = text.toLowerCase();
    
    for (final entry in _retailerPatterns.entries) {
      for (final pattern in entry.value) {
        if (normalized.contains(pattern.toLowerCase())) {
          return entry.key;
        }
      }
    }
    
    return null;
  }
  
  /// Parses Save-On-Foods email receipt format.
  ReceiptParseResult _parseSaveOnFoods(List<String> lines) {
    String? storeName;
    double? total;
    DateTime? date;
    
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final lowerLine = line.toLowerCase();
      
      // Look for store name
      if (storeName == null && 
          (lowerLine.contains('save-on-foods') || 
           lowerLine.contains('save on foods'))) {
        storeName = 'Save-On-Foods';
      }
      
      // Look for date - various formats
      if (date == null) {
        date = _extractDate(line);
      }
      
      // Look for total - Save-On-Foods uses various formats
      if (total == null) {
        if (lowerLine.contains('total') || 
            lowerLine.contains('balance') ||
            lowerLine.contains('amount')) {
          total = _extractAmount(line);
        }
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
    
    return ReceiptParseResult(success: false);
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
          (lowerLine.contains('walmart') || 
           lowerLine.contains('wal-mart'))) {
        storeName = 'Walmart';
      }
      
      // Look for date
      if (date == null) {
        date = _extractDate(line);
      }
      
      // Look for total - Walmart often uses "Order Total" or "Total"
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
    
    return ReceiptParseResult(success: false);
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
      if (date == null) {
        date = _extractDate(line);
      }
      
      // Look for total
      if (total == null && 
          (lowerLine.contains('total') || 
           lowerLine.contains('charged') ||
           lowerLine.contains('amount'))) {
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
    
    return ReceiptParseResult(success: false);
  }
  
  /// Parses Tim Hortons receipt format.
  ReceiptParseResult _parseTimHortons(List<String> lines) {
    String? storeName;
    double? total;
    DateTime? date;
    
    for (final line in lines) {
      final lowerLine = line.toLowerCase().trim();
      
      if (storeName == null && 
          (lowerLine.contains('tim hortons') || 
           lowerLine.contains('timhortons'))) {
        storeName = 'Tim Hortons';
      }
      
      if (date == null) {
        date = _extractDate(line);
      }
      
      if (total == null && 
          (lowerLine.contains('total') || lowerLine.contains('balance'))) {
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
    
    return ReceiptParseResult(success: false);
  }
  
  /// Parses McDonald's receipt format.
  ReceiptParseResult _parseMcDonalds(List<String> lines) {
    String? storeName;
    double? total;
    DateTime? date;
    
    for (final line in lines) {
      final lowerLine = line.toLowerCase().trim();
      
      if (storeName == null && 
          (lowerLine.contains('mcdonald') || 
           lowerLine.contains('mc donald'))) {
        storeName = "McDonald's";
      }
      
      if (date == null) {
        date = _extractDate(line);
      }
      
      if (total == null && 
          (lowerLine.contains('total') || 
           lowerLine.contains('order total'))) {
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
    
    return ReceiptParseResult(success: false);
  }
  
  /// Parses Costco receipt format.
  ReceiptParseResult _parseCostco(List<String> lines) {
    String? storeName;
    double? total;
    DateTime? date;
    
    for (final line in lines) {
      final lowerLine = line.toLowerCase().trim();
      
      if (storeName == null && lowerLine.contains('costco')) {
        storeName = 'Costco';
      }
      
      if (date == null) {
        date = _extractDate(line);
      }
      
      if (total == null && 
          (lowerLine.contains('order total') || 
           lowerLine.contains('total') ||
           lowerLine.contains('amount'))) {
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
    
    return ReceiptParseResult(success: false);
  }
  
  /// Parses Amazon receipt format.
  ReceiptParseResult _parseAmazon(List<String> lines) {
    String? storeName;
    double? total;
    DateTime? date;
    
    for (final line in lines) {
      final lowerLine = line.toLowerCase().trim();
      
      if (storeName == null && 
          (lowerLine.contains('amazon') || 
           lowerLine.contains('amazon.com'))) {
        storeName = 'Amazon';
      }
      
      if (date == null) {
        date = _extractDate(line);
      }
      
      if (total == null && 
          (lowerLine.contains('order total') || 
           lowerLine.contains('grand total') ||
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
    
    return ReceiptParseResult(success: false);
  }
  
  /// Generic parser for unknown receipt formats.
  ReceiptParseResult _parseGeneric(List<String> lines, String normalizedText) {
    // Try to detect retailer first
    final detectedRetailer = detectRetailer(normalizedText);
    
    String? storeName = detectedRetailer;
    double? total;
    DateTime? date;
    
    // Look for store name in first few lines if not detected
    if (storeName == null) {
      for (var i = 0; i < lines.length && i < 5; i++) {
        final line = lines[i].trim();
        if (line.isNotEmpty && 
            line.length > 2 && 
            line.length < 50 &&
            !line.contains(RegExp(r'^\d+')) && 
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
      if (date == null) {
        date = _extractDate(line);
      }
      
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
          // Skip if it looks like a year
          if (amount < 10000) {
            maxAmount = amount;
          }
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
    
    return ReceiptParseResult(
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
      RegExp(r'amount[:\s]*\$?([0-9,]+\.\d{2})', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final amountStr = match.group(1)?.replaceAll(',', '');
        if (amountStr != null) {
          final amount = double.tryParse(amountStr);
          if (amount != null && amount > 0 && amount < 100000) {
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
    // Common date patterns
    final patterns = [
      // MM/DD/YYYY or MM-DD-YYYY
      RegExp(r'(\d{1,2})[/-](\d{1,2})[/-](\d{4})'),
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
          // Try common date formats
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
