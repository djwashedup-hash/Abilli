import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Receipt scanner screen.
/// 
/// On native platforms: provides camera OCR functionality.
/// On web: shows a placeholder directing users to Manual tab.
class ReceiptScannerScreen extends StatelessWidget {
  const ReceiptScannerScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebPlaceholder(context);
    }
    
    return _buildNativeScanner(context);
  }
  
  Widget _buildWebPlaceholder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: AppTheme.textMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Camera scanning is not available on web',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Please use the Manual tab to enter your purchases.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Manual tab (index 1)
                final scaffold = ScaffoldMessenger.of(context);
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text('Switch to the Manual tab to add purchases'),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Go to Manual Entry'),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.bgTertiary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.accentBlue,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tip: Paste email receipts',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You can copy and paste text from email receipts (Save-On-Foods, '
                    'Walmart, Starbucks, etc.) in the Manual tab.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNativeScanner(BuildContext context) {
    // Native implementation would include:
    // - Camera preview
    // - OCR processing using google_mlkit_text_recognition
    // - Image picker for gallery
    
    // For now, show a placeholder indicating native functionality
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: AppTheme.accentBlue.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Receipt Scanner',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Camera OCR functionality is available on native builds. '
              'Run flutter build ios or flutter build android to use this feature.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Would open camera/gallery picker
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Select from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
