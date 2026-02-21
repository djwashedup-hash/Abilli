import 'package:flutter/material.dart';
import '../data/ownership_seed_data.dart';
import '../models/alternative.dart';
import '../models/company.dart';
import '../theme/app_theme.dart';

/// Screen showing alternative products and stores.
/// 
/// The app never rates or judges alternatives - it simply
/// presents them as options for users to explore.
class AlternativesScreen extends StatelessWidget {
  const AlternativesScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final alternatives = getAlternatives();
    final companies = getCompanies();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'EXPLORE ALTERNATIVES',
            style: AppTheme.sectionHeader,
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'These are alternative options you might consider. '
            'The app does not rate or recommend any option over another.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Alternatives list
          ...alternatives.map((alternative) {
            return _AlternativeCard(
              alternative: alternative,
              companies: companies,
            );
          }),
          
          const SizedBox(height: 24),
          
          // Categories section
          _buildCategoriesSection(),
        ],
      ),
    );
  }
  
  Widget _buildCategoriesSection() {
    final categories = [
      _CategoryInfo(
        name: 'Local & Independent',
        icon: Icons.storefront,
        color: AppTheme.accentGreen,
        description: 'Locally owned businesses',
      ),
      _CategoryInfo(
        name: 'Cooperatives',
        icon: Icons.people,
        color: AppTheme.accentPurple,
        description: 'Member-owned organizations',
      ),
      _CategoryInfo(
        name: 'Farmers Markets',
        icon: Icons.agriculture,
        color: AppTheme.accentYellow,
        description: 'Buy directly from producers',
      ),
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ALTERNATIVE TYPES',
          style: AppTheme.sectionHeader,
        ),
        
        const SizedBox(height: 16),
        
        ...categories.map((category) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: category.color.withValues(alpha: 0.2),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 20,
                ),
              ),
              title: Text(category.name),
              subtitle: Text(
                category.description,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }),
      ],
    );
  }
}

/// Card displaying an alternative option.
class _AlternativeCard extends StatelessWidget {
  final Alternative alternative;
  final Map<String, Company> companies;
  
  const _AlternativeCard({
    required this.alternative,
    required this.companies,
  });
  
  @override
  Widget build(BuildContext context) {
    // Get alternative to company names
    final alternativeToNames = alternative.alternativeToCompanyIds
        .map((id) => companies[id]?.name)
        .where((name) => name != null)
        .cast<String>()
        .toList();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Type indicator
                if (alternative.isLocal)
                  _buildBadge('Local', AppTheme.accentGreen),
                if (alternative.isCooperative)
                  _buildBadge('Co-op', AppTheme.accentPurple),
                if (alternative.isIndependent)
                  _buildBadge('Independent', AppTheme.accentYellow),
                
                const Spacer(),
                
                // Category
                Text(
                  alternative.category,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Name
            Text(
              alternative.name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            // Description
            ...[
              const SizedBox(height: 4),
              Text(
                alternative.description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
            
            // Alternative to
            if (alternativeToNames.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.swap_horiz,
                    size: 16,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Alternative to: ${alternativeToNames.join(', ')}',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CategoryInfo {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  
  _CategoryInfo({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}
