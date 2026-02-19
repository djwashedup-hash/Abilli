import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/monthly_report.dart';
import '../theme/app_theme.dart';

/// Custom painted donut chart showing spending distribution.
/// 
/// Displays shareholder slices with a legend below.
class SpendingPieChart extends StatelessWidget {
  final SpendingReport report;
  final double height;
  final bool showLegend;
  final int maxSlices;
  
  const SpendingPieChart({
    super.key,
    required this.report,
    this.height = 280,
    this.showLegend = true,
    this.maxSlices = 5,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart
        SizedBox(
          height: height * 0.6,
          child: CustomPaint(
            size: Size.infinite,
            painter: _DonutChartPainter(
              slices: report.slices,
              maxSlices: maxSlices,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Spending',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    report.formattedTotal,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Legend
        if (showLegend)
          _buildLegend(),
      ],
    );
  }
  
  Widget _buildLegend() {
    final topSlices = report.slices.take(maxSlices).toList();
    final otherAmount = report.slices.skip(maxSlices).fold<double>(
      0.0,
      (sum, slice) => sum + slice.illustrativeAmount,
    );
    
    return Column(
      children: [
        ...topSlices.asMap().entries.map((entry) {
          final index = entry.key;
          final slice = entry.value;
          return _LegendItem(
            color: _getSliceColor(index),
            label: slice.shareholder.name,
            value: slice.formattedAmount,
            percentage: '${(slice.illustrativeAmount / report.totalSpending * 100).toStringAsFixed(1)}%',
          );
        }),
        
        if (otherAmount > 0)
          _LegendItem(
            color: AppTheme.textMuted,
            label: 'Others',
            value: '\$${otherAmount.toStringAsFixed(2)}',
            percentage: '${(otherAmount / report.totalSpending * 100).toStringAsFixed(1)}%',
          ),
      ],
    );
  }
  
  Color _getSliceColor(int index) {
    final colors = [
      AppTheme.accentBlue,
      AppTheme.accentGreen,
      AppTheme.accentPurple,
      AppTheme.accentYellow,
      AppTheme.accentRed,
    ];
    return colors[index % colors.length];
  }
}

/// Legend item widget.
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String percentage;
  
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
    required this.percentage,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          
          // Label
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Value
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Percentage
          SizedBox(
            width: 45,
            child: Text(
              percentage,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the donut chart.
class _DonutChartPainter extends CustomPainter {
  final List<ReportSlice> slices;
  final int maxSlices;
  
  _DonutChartPainter({
    required this.slices,
    required this.maxSlices,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final innerRadius = radius * 0.6;
    
    // Calculate total for proportions
    final total = slices.fold<double>(
      0.0,
      (sum, slice) => sum + slice.illustrativeAmount,
    );
    
    if (total <= 0) {
      _drawEmptyChart(canvas, center, radius, innerRadius);
      return;
    }
    
    // Draw slices
    var startAngle = -math.pi / 2; // Start at top
    
    final topSlices = slices.take(maxSlices).toList();
    final otherAmount = slices.skip(maxSlices).fold<double>(
      0.0,
      (sum, slice) => sum + slice.illustrativeAmount,
    );
    
    for (var i = 0; i < topSlices.length; i++) {
      final slice = topSlices[i];
      final sweepAngle = (slice.illustrativeAmount / total) * 2 * math.pi;
      
      _drawSlice(
        canvas,
        center,
        radius,
        innerRadius,
        startAngle,
        sweepAngle,
        _getSliceColor(i),
      );
      
      startAngle += sweepAngle;
    }
    
    // Draw "others" slice if needed
    if (otherAmount > 0) {
      final sweepAngle = (otherAmount / total) * 2 * math.pi;
      _drawSlice(
        canvas,
        center,
        radius,
        innerRadius,
        startAngle,
        sweepAngle,
        AppTheme.textMuted,
      );
    }
  }
  
  void _drawSlice(
    Canvas canvas,
    Offset center,
    double radius,
    double innerRadius,
    double startAngle,
    double sweepAngle,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Draw outer arc
    final outerRect = Rect.fromCircle(center: center, radius: radius);
    final path = Path()
      ..moveTo(
        center.dx + innerRadius * math.cos(startAngle),
        center.dy + innerRadius * math.sin(startAngle),
      )
      ..lineTo(
        center.dx + radius * math.cos(startAngle),
        center.dy + radius * math.sin(startAngle),
      )
      ..arcTo(outerRect, startAngle, sweepAngle, false)
      ..lineTo(
        center.dx + innerRadius * math.cos(startAngle + sweepAngle),
        center.dy + innerRadius * math.sin(startAngle + sweepAngle),
      );
    
    // Draw inner arc (in reverse)
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);
    path.arcTo(innerRect, startAngle + sweepAngle, -sweepAngle, false);
    
    path.close();
    canvas.drawPath(path, paint);
    
    // Draw border
    final borderPaint = Paint()
      ..color = AppTheme.bgPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, borderPaint);
  }
  
  void _drawEmptyChart(
    Canvas canvas,
    Offset center,
    double radius,
    double innerRadius,
  ) {
    final paint = Paint()
      ..color = AppTheme.bgTertiary
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius - innerRadius;
    
    canvas.drawCircle(center, (radius + innerRadius) / 2, paint);
  }
  
  Color _getSliceColor(int index) {
    final colors = [
      AppTheme.accentBlue,
      AppTheme.accentGreen,
      AppTheme.accentPurple,
      AppTheme.accentYellow,
      AppTheme.accentRed,
    ];
    return colors[index % colors.length];
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
