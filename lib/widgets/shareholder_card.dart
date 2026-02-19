import 'package:flutter/material.dart';
import '../models/monthly_report.dart';
import '../models/public_action.dart';
import '../theme/app_theme.dart';

/// Expandable card displaying shareholder information.
/// 
/// Shows: name, ownership percentage, illustrative amount, and
/// expandable public actions section.
class ShareholderCard extends StatefulWidget {
  final ReportSlice slice;
  final bool showIllustrativeNote;
  
  const ShareholderCard({
    super.key,
    required this.slice,
    this.showIllustrativeNote = true,
  });
  
  @override
  State<ShareholderCard> createState() => _ShareholderCardState();
}

class _ShareholderCardState extends State<ShareholderCard> {
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    final shareholder = widget.slice.shareholder;
    final hasActions = shareholder.publicActions.isNotEmpty;
    
    return Card(
      child: Column(
        children: [
          // Main content (always visible)
          InkWell(
            onTap: hasActions ? _toggleExpanded : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Shareholder avatar/icon
                      CircleAvatar(
                        backgroundColor: AppTheme.accentBlue.withValues(alpha: 0.2),
                        child: Text(
                          shareholder.name.substring(0, 1),
                          style: const TextStyle(
                            color: AppTheme.accentBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Name and title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shareholder.name,
                              style: AppTheme.cardTitle,
                            ),
                            if (shareholder.title != null)
                              Text(
                                shareholder.title!,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Ownership percentage
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.slice.formattedOwnership,
                            style: const TextStyle(
                              color: AppTheme.accentBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'ownership',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      
                      // Expand icon (if has actions)
                      if (hasActions)
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.expand_more,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Illustrative amount
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.bgTertiary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Illustrative amount',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              widget.slice.formattedAmount,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (widget.showIllustrativeNote)
                          const Tooltip(
                            message: 'This is an illustrative calculation '
                                '(purchase × ownership %) and does not represent '
                                'actual cash flow.',
                            child: Icon(
                              Icons.info_outline,
                              color: AppTheme.textMuted,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable public actions section
          if (hasActions)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildActionsSection(shareholder.publicActions),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
        ],
      ),
    );
  }
  
  Widget _buildActionsSection(List<PublicAction> actions) {
    // Group actions by category
    final actionsByCategory = <ActionCategory, List<PublicAction>>{};
    for (final action in actions) {
      actionsByCategory.putIfAbsent(action.category, () => []).add(action);
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppTheme.border),
          const SizedBox(height: 8),
          
          const Text(
            'PUBLIC ACTIONS (SOURCED)',
            style: AppTheme.sectionHeader,
          ),
          
          const SizedBox(height: 12),
          
          ...actionsByCategory.entries.map((entry) {
            return _buildCategorySection(entry.key, entry.value);
          }),
        ],
      ),
    );
  }
  
  Widget _buildCategorySection(ActionCategory category, List<PublicAction> actions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header with icon
          Row(
            children: [
              Icon(
                _getCategoryIcon(category),
                size: 16,
                color: AppTheme.accentBlue,
              ),
              const SizedBox(width: 8),
              Text(
                category.label.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.accentBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Actions in this category
          ...actions.map((action) {
            return Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.description,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.source_outlined,
                        size: 12,
                        color: AppTheme.textMuted.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${action.source} • ${action.formattedDate}',
                          style: TextStyle(
                            color: AppTheme.textMuted.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (action.additionalContext != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        action.additionalContext!,
                        style: TextStyle(
                          color: AppTheme.textMuted.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  IconData _getCategoryIcon(ActionCategory category) {
    switch (category) {
      case ActionCategory.politicalDonation:
        return Icons.account_balance_outlined;
      case ActionCategory.laborRelations:
        return Icons.people_outline;
      case ActionCategory.regulatoryAction:
        return Icons.gavel_outlined;
      case ActionCategory.lobbying:
        return Icons.record_voice_over_outlined;
      case ActionCategory.philanthropy:
        return Icons.favorite_outline;
      case ActionCategory.legalProceeding:
        return Icons.balance_outlined;
      case ActionCategory.environmental:
        return Icons.eco_outlined;
      case ActionCategory.other:
        return Icons.info_outline;
    }
  }
  
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
