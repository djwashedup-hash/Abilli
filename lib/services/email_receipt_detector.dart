// lib/services/email_receipt_detector.dart
// Email receipt detection framework


/// Result of parsing a receipt email
class ReceiptParseResult {
  final bool success;
  final double? totalAmount;
  final String? retailer;
  final DateTime? purchaseDate;
  final String? errorMessage;
  final double confidence;

  const ReceiptParseResult({
    required this.success,
    this.totalAmount,
    this.retailer,
    this.purchaseDate,
    this.errorMessage,
    required this.confidence,
  });

  factory ReceiptParseResult.error(String message) => ReceiptParseResult(
    success: false,
    errorMessage: message,
    confidence: 0,
  );
}

/// Email metadata for analysis
class EmailMetadata {
  final String from;
  final String subject;
  final DateTime receivedDate;

  const EmailMetadata({
    required this.from,
    required this.subject,
    required this.receivedDate,
  });
}

/// Service for detecting and parsing email receipts
class EmailReceiptDetector {
  static final EmailReceiptDetector _instance = EmailReceiptDetector._internal();
  factory EmailReceiptDetector() => _instance;
  EmailReceiptDetector._internal();

  /// Known receipt sender domains
  static const List<String> receiptDomains = [
    'saveonfoods.com',
    'walmart.com',
    'amazon.com',
    'starbucks.com',
    'costco.com',
    'safeway.com',
    'wholefoods.com',
    'instacart.com',
    'doordash.com',
    'ubereats.com',
    'skipthedishes.com',
    'square.com',
    'squareup.com',
    'stripe.com',
    'paypal.com',
    'shopify.com',
    'toasttab.com',
    'target.com',
    'bestbuy.com',
    'homedepot.com',
    'shoppersdrugmart.ca',
    'cvs.com',
    'walgreens.com',
    'shell.com',
    'esso.ca',
    'aircanada.com',
    'westjet.com',
  ];

  /// Keywords that indicate a receipt email
  static const List<String> receiptKeywords = [
    'receipt',
    'order confirmation',
    'purchase confirmation',
    'payment confirmation',
    'your order',
    'order #',
    'order number',
    'invoice',
    'payment received',
    'thank you for your purchase',
  ];

  /// Keywords that indicate NOT a receipt
  static const List<String> exclusionKeywords = [
    'shipping confirmation',
    'your item has shipped',
    'delivery confirmation',
    'package delivered',
    'tracking number',
    'order cancelled',
    'refund',
    'return',
    'promotional',
    'newsletter',
  ];

  /// Retailer patterns for extracting names
  static final Map<String, String> retailerPatterns = {
    'saveonfoods': 'Save-On-Foods',
    'safeway': 'Safeway',
    'walmart': 'Walmart',
    'costco': 'Costco',
    'wholefoods': 'Whole Foods',
    'amazon': 'Amazon',
    'starbucks': 'Starbucks',
    'mcdonalds': 'McDonald\'s',
    'subway': 'Subway',
    'doordash': 'DoorDash',
    'ubereats': 'Uber Eats',
    'target': 'Target',
    'bestbuy': 'Best Buy',
    'homedepot': 'Home Depot',
    'square': 'Square',
    'stripe': 'Stripe',
    'paypal': 'PayPal',
  };

  /// Analyze an email to determine if it's likely a receipt
  ({double confidence, String? retailer}) analyzeEmail({
    required EmailMetadata metadata,
    String? bodyPreview,
  }) {
    double score = 0;
    String? detectedRetailer;

    final fromDomain = _extractDomain(metadata.from);
    if (receiptDomains.any((d) => fromDomain.contains(d))) {
      score += 0.4;
      
      for (final entry in retailerPatterns.entries) {
        if (fromDomain.contains(entry.key)) {
          detectedRetailer = entry.value;
          break;
        }
      }
    }

    final subjectLower = metadata.subject.toLowerCase();
    for (final keyword in receiptKeywords) {
      if (subjectLower.contains(keyword)) {
        score += 0.3;
        break;
      }
    }

    for (final keyword in exclusionKeywords) {
      if (subjectLower.contains(keyword)) {
        score -= 0.3;
        break;
      }
    }

    if (bodyPreview != null) {
      final bodyLower = bodyPreview.toLowerCase();
      
      if (bodyLower.contains('total') || 
          bodyLower.contains(r'\$\d+\.\d{2}') ||
          bodyLower.contains('subtotal')) {
        score += 0.2;
      }

      if (bodyLower.contains('receipt #') ||
          bodyLower.contains('transaction #') ||
          bodyLower.contains('order #')) {
        score += 0.2;
      }

      if (detectedRetailer == null) {
        for (final entry in retailerPatterns.entries) {
          if (bodyPreview.toLowerCase().contains(entry.key)) {
            detectedRetailer = entry.value;
            score += 0.1;
            break;
          }
        }
      }
    }

    score = score.clamp(0.0, 1.0);
    return (confidence: score, retailer: detectedRetailer);
  }

  ReceiptParseResult parseEmailReceipt(String emailBody, {String? retailer}) {
    try {
      String? detectedRetailer = retailer;
      if (detectedRetailer == null) {
        for (final entry in retailerPatterns.entries) {
          if (emailBody.toLowerCase().contains(entry.key)) {
            detectedRetailer = entry.value;
            break;
          }
        }
      }

      if (detectedRetailer == null) {
        return ReceiptParseResult.error('Could not identify retailer');
      }

      final totalAmount = _extractTotalAmount(emailBody);
      if (totalAmount == null) {
        return ReceiptParseResult.error('Could not extract total amount');
      }

      final purchaseDate = _extractPurchaseDate(emailBody);

      return ReceiptParseResult(
        success: true,
        totalAmount: totalAmount,
        retailer: detectedRetailer,
        purchaseDate: purchaseDate ?? DateTime.now(),
        confidence: 0.8,
      );

    } catch (e) {
      return ReceiptParseResult.error('Parse error: $e');
    }
  }

  String _extractDomain(String email) {
    final match = RegExp(r'@([^>\s]+)').firstMatch(email);
    return match?.group(1)?.toLowerCase() ?? '';
  }

  double? _extractTotalAmount(String text) {
    final patterns = [
      r'[Tt]otal[:\s]*\$?([0-9,]+\.\d{2})',
      r'[Aa]mount[:\s]*\$?([0-9,]+\.\d{2})',
      r'[Tt]otal\s+[Dd]ue[:\s]*\$?([0-9,]+\.\d{2})',
      r'[Gg]rand\s+[Tt]otal[:\s]*\$?([0-9,]+\.\d{2})',
      r'[Pp]aid[:\s]*\$?([0-9,]+\.\d{2})',
    ];

    for (final pattern in patterns) {
      final match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        final amountStr = match.group(1)?.replaceAll(',', '');
        if (amountStr != null) {
          return double.tryParse(amountStr);
        }
      }
    }

    return null;
  }

  DateTime? _extractPurchaseDate(String text) {
    final patterns = [
      r'(\d{1,2})[/-](\d{1,2})[/-](\d{4})',
      r'(\d{4})[/-](\d{1,2})[/-](\d{1,2})',
    ];

    for (final pattern in patterns) {
      final match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        try {
          final day = int.parse(match.group(1)!);
          final month = int.parse(match.group(2)!);
          final year = int.parse(match.group(3)!);
          
          // Try to determine if it's MM/DD/YYYY or DD/MM/YYYY
          if (year > 2000 && year < 2100) {
            if (day <= 12 && month > 12) {
              // Likely DD/MM/YYYY
              return DateTime(year, day, month);
            } else {
              // Likely MM/DD/YYYY
              return DateTime(year, month, day);
            }
          }
        } catch (_) {
          continue;
        }
      }
    }

    return null;
  }
}
