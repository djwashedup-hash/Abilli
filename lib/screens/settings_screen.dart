import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/purchase_service.dart';
import '../theme/app_theme.dart';

/// Settings screen.
/// 
/// Features:
/// - Data management (clear all purchases)
/// - About information
/// - Privacy policy link
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseService>(
      builder: (context, service, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data section
              const Text(
                'DATA',
                style: AppTheme.sectionHeader,
              ),
              
              const SizedBox(height: 16),
              
              Card(
                child: Column(
                  children: [
                    // Purchase count
                    ListTile(
                      leading: const Icon(
                        Icons.receipt_outlined,
                        color: AppTheme.accentBlue,
                      ),
                      title: const Text('Total Purchases'),
                      trailing: Text(
                        '${service.purchaseCount}',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const Divider(color: AppTheme.border, height: 1),
                    
                    // Total spending
                    ListTile(
                      leading: const Icon(
                        Icons.attach_money,
                        color: AppTheme.accentGreen,
                      ),
                      title: const Text('Total Tracked Spending'),
                      trailing: Text(
                        '\$${service.totalSpending.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const Divider(color: AppTheme.border, height: 1),
                    
                    // Clear data
                    ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: AppTheme.accentRed,
                      ),
                      title: const Text(
                        'Clear All Purchases',
                        style: TextStyle(color: AppTheme.accentRed),
                      ),
                      onTap: () => _showClearDataDialog(context, service),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // About section
              const Text(
                'ABOUT',
                style: AppTheme.sectionHeader,
              ),
              
              const SizedBox(height: 16),
              
              const Card(
                child: Column(
                  children: [
                    // App info
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: AppTheme.accentBlue,
                      ),
                      title: Text('Economic Influence'),
                      subtitle: Text('Version 1.0.0'),
                    ),
                    Divider(color: AppTheme.border, height: 1),
                    // Description
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Economic Influence maps your purchases to corporate ownership '
                        'chains and major shareholders. All data is stored locally on '
                        'your device.',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Privacy section
              const Text(
                'PRIVACY & LEGAL',
                style: AppTheme.sectionHeader,
              ),
              
              const SizedBox(height: 16),
              
              Card(
                child: Column(
                  children: [
                    // Privacy policy
                    ListTile(
                      leading: const Icon(
                        Icons.privacy_tip_outlined,
                        color: AppTheme.accentPurple,
                      ),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.textMuted,
                      ),
                      onTap: () => _showPrivacyPolicy(context),
                    ),
                    
                    const Divider(color: AppTheme.border, height: 1),
                    
                    // Data usage
                    const ListTile(
                      leading: Icon(
                        Icons.storage_outlined,
                        color: AppTheme.accentGreen,
                      ),
                      title: Text('How Your Data Is Used'),
                      subtitle: Text(
                        'All data stays on your device. No servers, no tracking.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    
                    const Divider(color: AppTheme.border, height: 1),
                    
                    // Sources
                    const ListTile(
                      leading: Icon(
                        Icons.source_outlined,
                        color: AppTheme.accentYellow,
                      ),
                      title: Text('Data Sources'),
                      subtitle: Text(
                        'Ownership data from SEC EDGAR and SEDAR filings. '
                        'Public actions sourced from FEC, NLRB, FTC, and court records.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.bgTertiary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.textMuted,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Important Disclaimer',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This app provides structural analysis of corporate ownership. '
                      'Illustrative amounts shown are calculations (purchase × ownership %) '
                      'and do not represent actual cash flows. Ownership percentages are '
                      'based on public filings and may not reflect current holdings.',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showClearDataDialog(BuildContext context, PurchaseService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Purchases?'),
        content: const Text(
          'This will permanently delete all your purchase history. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await service.clearAllPurchases();
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All purchases cleared'),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentRed,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
  
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Economic Influence Privacy Policy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. Data Storage',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'All data is stored locally on your device. We do not operate '
                'any servers or cloud infrastructure.',
              ),
              SizedBox(height: 12),
              Text(
                '2. No Data Collection',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'We do not collect, transmit, or share any personal data. '
                'Your purchase history never leaves your device.',
              ),
              SizedBox(height: 12),
              Text(
                '3. Camera Usage',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'The camera is used only for receipt scanning. Images are '
                'processed on-device and are not transmitted anywhere.',
              ),
              SizedBox(height: 12),
              Text(
                '4. No Account Required',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'No account, email, or personal information is required to use this app.',
              ),
              SizedBox(height: 12),
              Text(
                '5. No Tracking',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'We do not use analytics, tracking, or advertising services.',
              ),
              SizedBox(height: 12),
              Text(
                '6. Contact',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'For questions about this privacy policy, contact the developer '
                'through the App Store.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
