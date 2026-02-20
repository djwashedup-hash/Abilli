// lib/services/email_receipt_detector.dart
// Email receipt detection framework

import 'dart:async';
import 'package:flutter/foundation.dart';

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
    r'save[-\s]?on[-\s]?foods': 'Save-On-Foods',
    r'safeway': 'Safeway',
    r'walmart': 'Walmart',
    r'costco': 'Costco',
    r'whole\s*foods': 'Whole Foods',
    r'amazon': 'Amazon',
    r'starbucks': 'Starbucks',
    r'mcdonald\'s': 'McDonald\'s',
    r'subway': 'Subway',
    r'door[d]?ash': 'DoorDash',
    r'uber\s*eats': 'Uber Eats',
    r'target': 'Target',
    r'best\s*buy': 'Best Buy',
    r'home\s*depot': 'Home Depot',
    r'square': 'Square',
    r'stripe': 'Stripe',
    r'paypal': 'PayPal',
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
        if (fromDomain.contains(entry.key.replaceAll(r'\s*', '').replaceAll(r'[-\s]?', ''))) {
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
          final regex = RegExp(entry.key, caseSensitive: false);
          if (regex.hasMatch(bodyPreview)) {
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
          final regex = RegExp(entry.key, caseSensitive: false);
          if (regex.hasMatch(emailBody)) {
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
    final match = RegExp(r'@([^>]+)').firstMatch(email);
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
      r'([A-Za-z]+)\s+(\d{1,2}),?\s+(\d{4})',
    ];

    for (final pattern in patterns) {
      final match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        try {
          final parts = match.group(0)!;
          return DateTime.tryParse(parts.replaceAll('/', '-'));
        } catch (_) {
          continue;
        }
      }
    }

    return null;
  }
}
