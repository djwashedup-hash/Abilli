export 'services/email_receipt_detector.dart';
/*
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
    export 'services/email_receipt_detector.dart';
        }
      }
    }

    return null;
  }
}
