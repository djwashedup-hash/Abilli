import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/report_generator.dart';
import '../models/monthly_report.dart';
import '../models/purchase.dart';
import '../services/purchase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shareholder_card.dart';
import '../widgets/spending_pie_chart.dart';

/// Monthly report screen with daily/weekly/monthly toggle.
class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({super.key});
  
  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  ReportPeriod _selectedPeriod = ReportPeriod.monthly;
  DateTime _selectedDate = DateTime.now();
  
  final _reportGenerator = ReportGenerator();
  
  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseService>(
      builder: (context, service, child) {
        final report = _generateReport(service.purchases);
        
        return Column(
          children: [
            // Period selector
            _buildPeriodSelector(),
            
            // Date navigation
            _buildDateNavigation(),
            
            // Report content
            Expanded(
              child: report.purchases.isEmpty
                  ? _buildEmptyState()
                  : _buildReportContent(report),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SegmentedButton<ReportPeriod>(
        segments: const [
          ButtonSegment(
            value: ReportPeriod.daily,
            label: Text('Daily'),
          ),
          ButtonSegment(
            value: ReportPeriod.weekly,
            label: Text('Weekly'),
          ),
          ButtonSegment(
            value: ReportPeriod.monthly,
            label: Text('Monthly'),
          ),
        ],
        selected: {_selectedPeriod},
        onSelectionChanged: (selection) {
          setState(() {
            _selectedPeriod = selection.first;
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.accentBlue;
            }
            return AppTheme.bgTertiary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.bgPrimary;
            }
            return AppTheme.textPrimary;
          }),
        ),
      ),
    );
  }
  
  Widget _buildDateNavigation() {
    String dateText;
    
    switch (_selectedPeriod) {
      case ReportPeriod.daily:
        dateText = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
        break;
      case ReportPeriod.weekly:
        final weekEnd = _selectedDate.add(const Duration(days: 6));
        dateText = '${_selectedDate.month}/${_selectedDate.day} - ${weekEnd.month}/${weekEnd.day}';
        break;
      case ReportPeriod.monthly:
        dateText = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}';
        break;
      default:
        dateText = _selectedDate.toString();
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _goToPrevious,
            icon: const Icon(Icons.chevron_left),
            color: AppTheme.textSecondary,
          ),
          Text(
            dateText,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: _canGoNext() ? _goToNext : null,
            icon: const Icon(Icons.chevron_right),
            color: _canGoNext() ? AppTheme.textSecondary : AppTheme.textMuted,
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppTheme.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No purchases for this period',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add purchases in the Manual tab',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReportContent(SpendingReport report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pie chart
          SpendingPieChart(report: report),
          
          const SizedBox(height: 24),
          
          // Illustrative note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.accentBlue.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.accentBlue,
                  size: 18,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Amounts shown are illustrative calculations (purchase × ownership %) '
                    'and do not represent actual cash flows to shareholders.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Shareholder breakdown
          const Text(
            'SHAREHOLDER BREAKDOWN',
            style: AppTheme.sectionHeader,
          ),
          
          const SizedBox(height: 16),
          
          ...report.slices.map((slice) {
            return ShareholderCard(slice: slice);
          }),
          
          const SizedBox(height: 24),
          
          // Purchase summary
          _buildPurchaseSummary(report.purchases),
        ],
      ),
    );
  }
  
  Widget _buildPurchaseSummary(List<Purchase> purchases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PURCHASES',
          style: AppTheme.sectionHeader,
        ),
        
        const SizedBox(height: 16),
        
        ...purchases.map((purchase) {
          return Card(
            child: ListTile(
              title: Text(purchase.productName),
              subtitle: Text(
                '${purchase.companyName} • ${purchase.formattedDate}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Text(
                purchase.formattedAmount,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
  
  SpendingReport _generateReport(List<Purchase> purchases) {
    switch (_selectedPeriod) {
      case ReportPeriod.daily:
        return _reportGenerator.generateDaily(_selectedDate, purchases);
      case ReportPeriod.weekly:
        return _reportGenerator.generateWeekly(_selectedDate, purchases);
      case ReportPeriod.monthly:
        return _reportGenerator.generateMonthly(
          _selectedDate.year,
          _selectedDate.month,
          purchases,
        );
      default:
        return _reportGenerator.generateMonthly(
          _selectedDate.year,
          _selectedDate.month,
          purchases,
        );
    }
  }
  
  void _goToPrevious() {
    setState(() {
      switch (_selectedPeriod) {
        case ReportPeriod.daily:
          _selectedDate = _selectedDate.subtract(const Duration(days: 1));
          break;
        case ReportPeriod.weekly:
          _selectedDate = _selectedDate.subtract(const Duration(days: 7));
          break;
        case ReportPeriod.monthly:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month - 1,
            1,
          );
          break;
        default:
          break;
      }
    });
  }
  
  void _goToNext() {
    setState(() {
      switch (_selectedPeriod) {
        case ReportPeriod.daily:
          _selectedDate = _selectedDate.add(const Duration(days: 1));
          break;
        case ReportPeriod.weekly:
          _selectedDate = _selectedDate.add(const Duration(days: 7));
          break;
        case ReportPeriod.monthly:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month + 1,
            1,
          );
          break;
        default:
          break;
      }
    });
  }
  
  bool _canGoNext() {
    final now = DateTime.now();
    
    switch (_selectedPeriod) {
      case ReportPeriod.daily:
        return _selectedDate.isBefore(DateTime(now.year, now.month, now.day));
      case ReportPeriod.weekly:
        final weekEnd = _selectedDate.add(const Duration(days: 6));
        return weekEnd.isBefore(now);
      case ReportPeriod.monthly:
        return _selectedDate.year < now.year ||
            (_selectedDate.year == now.year && _selectedDate.month < now.month);
      default:
        return false;
    }
  }
}
