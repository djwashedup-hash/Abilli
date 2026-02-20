// lib/screens/alternatives_screen.dart
// Alternatives with independence/local scoring and filters

import 'package:flutter/material.dart';
import '../models/alternative.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';

class AlternativesScreen extends StatefulWidget {
  final String? forProduct;
  final String? forBrand;
  
  const AlternativesScreen({
    super.key,
    this.forProduct,
    this.forBrand,
  });

  @override
  State<AlternativesScreen> createState() => _AlternativesScreenState();
}

class _AlternativesScreenState extends State<AlternativesScreen> {
  final TextEditingController _searchController = TextEditingController();
  AlternativeFilter _filter = AlternativeFilter();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final accentColor = themeProvider.accentColor;
    
    final bgPrimary = isDark ? const Color(0xFF0D1117) : Colors.white;
    final bgSecondary = isDark ? const Color(0xFF161B22) : Colors.grey[100];
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.grey[400] : Colors.grey[600];
    final borderColor = isDark ? const Color(0xFF30363D) : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: bgPrimary,
      appBar: AppBar(
        backgroundColor: bgSecondary,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alternatives',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.forProduct != null)
              Text(
                'for ${widget.forProduct}',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: textSecondary,
            ),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(bgSecondary, textPrimary, textSecondary, borderColor),
          if (_showFilters) _buildFilterPanel(isDark, textPrimary, textSecondary, accentColor, borderColor),
          if (_hasActiveFilters) _buildFilterChips(accentColor, isDark),
          Expanded(
            child: _buildAlternativesList(isDark, textPrimary, textSecondary, borderColor, accentColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Color? bgSecondary, Color textPrimary, Color? textSecondary, Color borderColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: textPrimary),
        decoration: InputDecoration(
          hintText: 'Search alternatives...',
          hintStyle: TextStyle(color: textSecondary),
          prefixIcon: Icon(Icons.search, color: textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: textSecondary),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _filter = _filter.copyWith(searchQuery: null);
                  });
                },
              )
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) {
          setState(() {
            _filter = _filter.copyWith(searchQuery: value.isEmpty ? null : value);
          });
        },
      ),
    );
  }

  Widget _buildFilterPanel(bool isDark, Color textPrimary, Color? textSecondary, Color accentColor, Color borderColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Minimum Independence Score: ${_filter.minIndependenceScore}',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Slider(
            value: _filter.minIndependenceScore.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: accentColor,
            inactiveColor: borderColor,
            label: '${_filter.minIndependenceScore}',
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(minIndependenceScore: value.round());
              });
            },
          ),
          const SizedBox(height: 16),
          
          Text(
            'Minimum Local Score: ${_filter.minLocalScore}',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Slider(
            value: _filter.minLocalScore.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: accentColor,
            inactiveColor: borderColor,
            label: '${_filter.minLocalScore}',
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(minLocalScore: value.round());
              });
            },
          ),
          const SizedBox(height: 16),
          
          Text(
            'Prioritize',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPriorityChip('Co-ops', _filter.prioritizeCoops, 
                (v) => _filter = _filter.copyWith(prioritizeCoops: v), accentColor, isDark),
              _buildPriorityChip('B-Corps', _filter.prioritizeBCorps, 
                (v) => _filter = _filter.copyWith(prioritizeBCorps: v), accentColor, isDark),
              _buildPriorityChip('Employee-Owned', _filter.prioritizeEmployeeOwned, 
                (v) => _filter = _filter.copyWith(prioritizeEmployeeOwned: v), accentColor, isDark),
              _buildPriorityChip('Family-Owned', _filter.prioritizeFamilyOwned, 
                (v) => _filter = _filter.copyWith(prioritizeFamilyOwned: v), accentColor, isDark),
            ],
          ),
          
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _filter = AlternativeFilter();
                  _searchController.clear();
                });
              },
              icon: Icon(Icons.refresh, color: textSecondary, size: 18),
              label: Text('Reset Filters', style: TextStyle(color: textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String label, bool selected, Function(bool) onChanged, Color accentColor, bool isDark) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (value) => setState(() => onChanged(value)),
      selectedColor: accentColor,
      checkmarkColor: isDark ? Colors.black : Colors.white,
      labelStyle: TextStyle(
        color: selected ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.grey[400] : Colors.grey[600]),
        fontSize: 12,
      ),
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.white,
      side: BorderSide(color: isDark ? const Color(0xFF30363D) : Colors.grey[300]!),
    );
  }

  bool get _hasActiveFilters {
    return _filter.minIndependenceScore > 0 ||
           _filter.minLocalScore > 0 ||
           _filter.prioritizeCoops ||
           _filter.prioritizeBCorps ||
           _filter.prioritizeEmployeeOwned ||
           _filter.prioritizeFamilyOwned;
  }

  Widget _buildFilterChips(Color accentColor, bool isDark) {
    final chips = <Widget>[];

    if (_filter.minIndependenceScore > 0) {
      chips.add(_buildActiveFilterChip('Independence ≥${_filter.minIndependenceScore}', 
        () => setState(() => _filter = _filter.copyWith(minIndependenceScore: 0)), accentColor, isDark));
    }
    if (_filter.minLocalScore > 0) {
      chips.add(_buildActiveFilterChip('Local ≥${_filter.minLocalScore}', 
        () => setState(() => _filter = _filter.copyWith(minLocalScore: 0)), accentColor, isDark));
    }
    if (_filter.prioritizeCoops) {
      chips.add(_buildActiveFilterChip('Co-ops', 
        () => setState(() => _filter = _filter.copyWith(prioritizeCoops: false)), accentColor, isDark));
    }
    if (_filter.prioritizeBCorps) {
      chips.add(_buildActiveFilterChip('B-Corps', 
        () => setState(() => _filter = _filter.copyWith(prioritizeBCorps: false)), accentColor, isDark));
    }
    if (_filter.prioritizeEmployeeOwned) {
      chips.add(_buildActiveFilterChip('Employee-Owned', 
        () => setState(() => _filter = _filter.copyWith(prioritizeEmployeeOwned: false)), accentColor, isDark));
    }
    if (_filter.prioritizeFamilyOwned) {
      chips.add(_buildActiveFilterChip('Family-Owned', 
        () => setState(() => _filter = _filter.copyWith(prioritizeFamilyOwned: false)), accentColor, isDark));
    }

    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: chips,
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove, Color accentColor, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.black : Colors.white,
            fontSize: 12,
          ),
        ),
        backgroundColor: accentColor,
        deleteIcon: Icon(Icons.close, size: 16, color: isDark ? Colors.black : Colors.white),
        onDeleted: onRemove,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildAlternativesList(bool isDark, Color textPrimary, Color? textSecondary, Color borderColor, Color accentColor) {
    final sampleAlternatives = _getSampleAlternatives();
    final filtered = _filter.apply(sampleAlternatives);

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 64,
              color: (isDark ? Colors.grey[600] : Colors.grey[400])?.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No alternatives found',
              style: TextStyle(
                color: textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                color: isDark ? Colors.grey[600] : Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final alternative = filtered[index];
        return _buildAlternativeCard(alternative, isDark, textPrimary, textSecondary, borderColor, accentColor);
      },
    );
  }

  Widget _buildAlternativeCard(Alternative alt, bool isDark, Color textPrimary, Color? textSecondary, Color borderColor, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _buildScoreBadge(alt.independenceScore.value.toString(), 
                      alt.independenceScore.color, 'Ind.', isDark),
                    const SizedBox(height: 4),
                    _buildScoreBadge(alt.localScore.value.toString(), 
                      alt.localScore.color, 'Local', isDark),
                  ],
                ),
                const SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alt.name,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alt.category,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (alt.independenceScore.isCooperative)
                      _buildTypeBadge('Co-op', accentColor, isDark),
                    if (alt.independenceScore.isBCorp)
                      _buildTypeBadge('B-Corp', accentColor, isDark),
                    if (alt.independenceScore.isEmployeeOwned)
                      _buildTypeBadge('Employee-Owned', accentColor, isDark),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              alt.description,
              style: TextStyle(
                color: textSecondary,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 16, color: accentColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alt.valueProposition,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 12,
                      ),
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

  Widget _buildScoreBadge(String score, Color color, String label, bool isDark) {
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            score,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String label, Color accentColor, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: accentColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<Alternative> _getSampleAlternatives() {
    return [
      Alternative(
        id: '1',
        name: 'Root Cellar',
        description: 'Victoria-based organic grocery store focused on local, seasonal produce from Vancouver Island farms.',
        category: 'Grocery',
        tags: ['Organic', 'Local Produce', 'Seasonal'],
        independenceScore: const IndependenceScore(
          value: 92,
          explanation: 'Locally owned, sources primarily from Vancouver Island farms',
          factors: ['Family owned', 'Local sourcing', 'Independent'],
          isFamilyOwned: true,
        ),
        localScore: const LocalScore(
          value: 95,
          location: 'Victoria, BC',
          distanceKm: 2.5,
          city: 'Victoria',
          state: 'BC',
          sourcesLocally: true,
          percentLocalSourcing: 85,
        ),
        replacesBrands: ['Save-On-Foods', 'Thrifty Foods'],
        address: '1286 McKenzie Ave, Victoria, BC',
        website: 'rootcellar.ca',
      ),
      Alternative(
        id: '2',
        name: 'The Market Garden',
        description: 'Worker-owned cooperative grocery store with emphasis on organic and fair-trade products.',
        category: 'Grocery',
        tags: ['Co-op', 'Organic', 'Fair Trade'],
        independenceScore: const IndependenceScore(
          value: 98,
          explanation: 'Worker-owned cooperative with democratic governance',
          factors: ['Worker cooperative', 'Democratic ownership', 'Community-focused'],
          isCooperative: true,
        ),
        localScore: const LocalScore(
          value: 78,
          location: 'Victoria, BC',
          distanceKm: 4.2,
          city: 'Victoria',
          state: 'BC',
          sourcesLocally: true,
          percentLocalSourcing: 60,
        ),
        replacesBrands: ['Save-On-Foods', 'Whole Foods'],
        address: '1590 Fairfield Rd, Victoria, BC',
      ),
      Alternative(
        id: '3',
        name: 'Fernwood Coffee',
        description: 'Small-batch coffee roaster in the heart of Fernwood, roasted fresh weekly.',
        category: 'Coffee',
        tags: ['Local Roaster', 'Small Batch', 'Organic'],
        independenceScore: const IndependenceScore(
          value: 88,
          explanation: 'Independent local roaster, family operated',
          factors: ['Family owned', 'Local roasting', 'Small batch'],
          isFamilyOwned: true,
        ),
        localScore: const LocalScore(
          value: 92,
          location: 'Victoria, BC',
          distanceKm: 1.8,
          city: 'Victoria',
          state: 'BC',
          sourcesLocally: false,
        ),
        replacesBrands: ['Starbucks', 'Tim Hortons'],
        address: '1201 Fort St, Victoria, BC',
        website: 'fernwoodcoffee.com',
      ),
      Alternative(
        id: '4',
        name: 'Island Natural Markets',
        description: 'Employee-owned natural food store with extensive organic selection.',
        category: 'Grocery',
        tags: ['Employee-Owned', 'Organic', 'Natural Foods'],
        independenceScore: const IndependenceScore(
          value: 85,
          explanation: 'Employee-owned through ESOP program',
          factors: ['Employee ownership', 'ESOP', 'Local business'],
          isEmployeeOwned: true,
        ),
        localScore: const LocalScore(
          value: 72,
          location: 'Victoria, BC',
          distanceKm: 5.5,
          city: 'Victoria',
          state: 'BC',
          sourcesLocally: true,
          percentLocalSourcing: 45,
        ),
        replacesBrands: ['Whole Foods', 'Safeway'],
        address: '791 Goldstream Ave, Victoria, BC',
      ),
    ];
  }
}
