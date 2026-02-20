// lib/screens/shopping_list_screen.dart
// Shopping list with urgency indicators

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shopping_item.dart';
import '../services/shopping_list_service.dart';
import '../theme/theme_provider.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showChecked = false;

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
    final textMuted = isDark ? Colors.grey[600] : Colors.grey[400];
    final borderColor = isDark ? const Color(0xFF30363D) : Colors.grey[300]!;
    
    final shoppingService = context.watch<ShoppingListService>();
    
    final items = _searchQuery.isEmpty
      ? (_showChecked ? shoppingService.checkedItems : shoppingService.itemsByUrgency)
      : shoppingService.search(_searchQuery)
          .where((i) => _showChecked ? i.isChecked : !i.isChecked)
          .toList();

    final stats = shoppingService.stats;

    return Scaffold(
      backgroundColor: bgPrimary,
      appBar: AppBar(
        backgroundColor: bgSecondary,
        elevation: 0,
        title: Text(
          'Shopping List',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${stats.checked}/${stats.total}',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (shoppingService.checkedItems.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep, color: textSecondary),
              onPressed: () => _showClearConfirmation(context),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(bgSecondary, textPrimary, textSecondary, textMuted, borderColor),
          _buildToggleBar(isDark, textPrimary, textSecondary, accentColor),
          
          if (!_showChecked && shoppingService.predictedItems.isNotEmpty)
            _buildPredictedBanner(shoppingService.predictedItems, accentColor, bgSecondary, textPrimary, textSecondary),
          
          if (!_showChecked && shoppingService.urgentItems.isNotEmpty)
            _buildUrgentBanner(shoppingService.urgentItems, bgSecondary, textPrimary, textSecondary),
          
          Expanded(
            child: items.isEmpty
              ? _buildEmptyState(isDark, textPrimary, textSecondary, textMuted, accentColor)
              : _buildItemList(items, isDark, textPrimary, textSecondary, textMuted, borderColor, accentColor),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        backgroundColor: accentColor,
        icon: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
        label: Text(
          'Add Item',
          style: TextStyle(color: isDark ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color? bgSecondary, Color textPrimary, Color? textSecondary, Color? textMuted, Color borderColor) {
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
          hintText: 'Search items...',
          hintStyle: TextStyle(color: textMuted),
          prefixIcon: Icon(Icons.search, color: textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: textSecondary),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildToggleBar(bool isDark, Color textPrimary, Color? textSecondary, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SegmentedButton<bool>(
        segments: const [
          ButtonSegment(
            value: false,
            label: Text('To Buy'),
            icon: Icon(Icons.shopping_cart_outlined),
          ),
          ButtonSegment(
            value: true,
            label: Text('Purchased'),
            icon: Icon(Icons.check_circle_outline),
          ),
        ],
        selected: {_showChecked},
        onSelectionChanged: (selected) {
          setState(() => _showChecked = selected.first);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return accentColor;
            }
            return isDark ? const Color(0xFF161B22) : Colors.grey[100];
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return isDark ? Colors.black : Colors.white;
            }
            return textSecondary;
          }),
        ),
      ),
    );
  }

  Widget _buildPredictedBanner(List<ShoppingItem> items, Color accentColor, Color? bgSecondary, Color textPrimary, Color? textSecondary) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.2), accentColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Predicted Items',
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${items.length} item(s) you might need soon',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.read<ShoppingListService>().addPredictions(),
            child: Text('Add All', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentBanner(List<ShoppingItem> items, Color? bgSecondary, Color textPrimary, Color? textSecondary) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B6B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.priority_high, color: Color(0xFFFF6B6B)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Urgent Items',
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${items.length} item(s) need attention',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List<ShoppingItem> items, bool isDark, Color textPrimary, Color? textSecondary, Color? textMuted, Color borderColor, Color accentColor) {
    if (!_showChecked) {
      final grouped = <UrgencyLevel, List<ShoppingItem>>{};
      for (final level in UrgencyLevel.values) {
        grouped[level] = items.where((i) => i.urgency == level).toList();
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: UrgencyLevel.values.length,
        itemBuilder: (context, index) {
          final level = UrgencyLevel.values[index];
          final levelItems = grouped[level]!;
          
          if (levelItems.isEmpty) return const SizedBox.shrink();
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  children: [
                    Text(
                      level.emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      level.label,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161B22) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${levelItems.length}',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...levelItems.map((item) => _buildItemCard(item, isDark, textPrimary, textSecondary, borderColor, accentColor)),
            ],
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItemCard(items[index], isDark, textPrimary, textSecondary, borderColor, accentColor),
    );
  }

  Widget _buildItemCard(ShoppingItem item, bool isDark, Color textPrimary, Color? textSecondary, Color borderColor, Color accentColor) {
    final bgSecondary = isDark ? const Color(0xFF161B22) : Colors.grey[100];

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => context.read<ShoppingListService>().removeItem(item.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: ListTile(
          leading: Checkbox(
            value: item.isChecked,
            onChanged: (checked) {
              if (checked == true) {
                context.read<ShoppingListService>().checkItem(item.id);
              } else {
                context.read<ShoppingListService>().uncheckItem(item.id);
              }
            },
            activeColor: accentColor,
            side: BorderSide(color: borderColor),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w500,
              decoration: item.isChecked ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                item.category,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                ),
              ),
              if (!item.isChecked && item.urgency != UrgencyLevel.unknown)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item.urgencyDisplay,
                    style: TextStyle(
                      color: _getUrgencyColor(item.urgency),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color textPrimary, Color? textSecondary, Color? textMuted, Color accentColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _showChecked ? Icons.check_circle_outline : Icons.shopping_basket_outlined,
            size: 64,
            color: textMuted?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _showChecked ? 'No purchased items' : 'Your list is empty',
            style: TextStyle(
              color: textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _showChecked 
              ? 'Items you check off will appear here'
              : 'Add items to get started with smart shopping',
            style: TextStyle(
              color: textMuted,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (!_showChecked) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddItemDialog(context),
              icon: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
              label: Text('Add Your First Item', style: TextStyle(color: isDark ? Colors.black : Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getUrgencyColor(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.overdue:
        return const Color(0xFFFF6B6B);
      case UrgencyLevel.urgent:
        return const Color(0xFFFFA500);
      case UrgencyLevel.soon:
        return const Color(0xFFFFD700);
      case UrgencyLevel.later:
        return const Color(0xFF238636);
      case UrgencyLevel.unknown:
        return Colors.grey;
    }
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController(text: 'General');
    final notesController = TextEditingController();
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final accentColor = themeProvider.accentColor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        title: Text('Add Item', style: TextStyle(
          color: isDark ? Colors.white : Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'Item name',
                labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<ShoppingListService>().addItem(
                  name: nameController.text,
                  category: categoryController.text,
                  notes: notesController.text.isEmpty ? null : notesController.text,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: isDark ? Colors.black : Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        title: Text('Clear Checked Items?', style: TextStyle(
          color: isDark ? Colors.white : Colors.black87)),
        content: Text(
          'This will remove all checked items from your list.',
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ShoppingListService>().clearCheckedItems();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
