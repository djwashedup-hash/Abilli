import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/receipt_parser.dart';

/// Receipt scanner screen.
/// 
/// On web: Provides paste text functionality for email receipts.
/// On native: Full camera OCR with ML Kit + gallery picker + paste text.
class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  final _receiptTextController = TextEditingController();
  final _receiptParser = ReceiptParser();
  final _imagePicker = ImagePicker();
  final _textRecognizer = TextRecognizer();
  
  bool _isProcessing = false;
  String? _parsedResult;
  
  @override
  void dispose() {
    _receiptTextController.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Paste Receipt Section (Works on ALL platforms)
          _buildPasteSection(),
          
          const SizedBox(height: 24),
          
          // Native-only camera options
          if (!kIsWeb) ...[
            _buildCameraSection(),
            const SizedBox(height: 24),
          ],
          
          // Tips section
          _buildTipsSection(),
        ],
      ),
    );
  }
  
  Widget _buildPasteSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.content_paste,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Paste Email Receipt',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Copy and paste text from email receipts (Save-On-Foods, Walmart, Starbucks, etc.)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _receiptTextController,
              decoration: InputDecoration(
                hintText: 'Paste your receipt text here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 8,
              minLines: 4,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _parsePastedText,
                icon: _isProcessing 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_fix_high),
                label: Text(_isProcessing ? 'Parsing...' : 'Parse Receipt'),
              ),
            ),
            if (_parsedResult != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _parsedResult!.contains('Error') 
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_parsedResult!),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildCameraSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Scan with Camera',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Take a photo of your paper receipt',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _scanWithCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isProcessing ? null : _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTipsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Supported Receipts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('Save-On-Foods email receipts'),
            _buildTipItem('Walmart digital receipts'),
            _buildTipItem('Starbucks purchase confirmations'),
            _buildTipItem('Generic "Your order from X" emails'),
            _buildTipItem('Paper receipts (camera on native)'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _parsePastedText() async {
    final text = _receiptTextController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _parsedResult = 'Error: Please paste receipt text first';
      });
      return;
    }
    
    setState(() {
      _isProcessing = true;
      _parsedResult = null;
    });
    
    try {
      final result = _receiptParser.parse(text);
      
      if (result.success) {
        setState(() {
          _parsedResult = '✓ Parsed: ${result.storeName} - \$${result.total?.toStringAsFixed(2)}';
        });
        
        // Show confirmation dialog
        if (mounted) {
          _showParsedResultDialog(result);
        }
      } else {
        setState(() {
          _parsedResult = 'Error: ${result.error ?? 'Could not parse receipt'}';
        });
      }
    } catch (e) {
      setState(() {
        _parsedResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
  
  Future<void> _scanWithCamera() async {
    if (kIsWeb) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      
      if (image != null) {
        await _processImage(image);
      }
    } catch (e) {
      setState(() {
        _parsedResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
  
  Future<void> _pickFromGallery() async {
    if (kIsWeb) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        await _processImage(image);
      }
    } catch (e) {
      setState(() {
        _parsedResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
  
  Future<void> _processImage(XFile image) async {
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      if (recognizedText.text.isNotEmpty) {
        final result = _receiptParser.parse(recognizedText.text);
        
        if (result.success && mounted) {
          _showParsedResultDialog(result);
        } else {
          setState(() {
            _parsedResult = 'Could not parse receipt. Try pasting text manually.';
          });
        }
      } else {
        setState(() {
          _parsedResult = 'No text found in image';
        });
      }
    } catch (e) {
      setState(() {
        _parsedResult = 'Error processing image: $e';
      });
    }
  }
  
  void _showParsedResultDialog(ReceiptParseResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receipt Parsed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Store: ${result.storeName}'),
            Text('Total: \$${result.total?.toStringAsFixed(2)}'),
            if (result.date != null)
              Text('Date: ${result.date}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to add purchase screen with parsed data
              // This would need to be implemented with navigation
            },
            child: const Text('Add Purchase'),
          ),
        ],
      ),
    );
  }
}
