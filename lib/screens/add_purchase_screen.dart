import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/purchase.dart';
import '../data/ownership_database.dart';
import '../services/purchase_service.dart';
import '../services/receipt_parser.dart';
import '../theme/app_theme.dart';

/// Screen for manually adding purchases.
/// 
/// Features:
/// - Live merchant matching as user types
/// - Amount and date entry
/// - Email receipt text parsing
class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({super.key});
  
  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  final _productController = TextEditingController();
  final _receiptTextController = TextEditingController();
  final _notesController = TextEditingController();
  
  final _database = OwnershipDatabase();
  final _receiptParser = ReceiptParser();
  
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _merchantSuggestions = [];
  String? _matchedCompanyId;
  bool _showReceiptParser = false;
  
  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    _productController.dispose();
    _receiptTextController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Receipt parser toggle
          _buildReceiptParserSection(),
          
          const SizedBox(height: 24),
          
          // Manual entry form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PURCHASE DETAILS',
                  style: AppTheme.sectionHeader,
                ),
                
                const SizedBox(height: 16),
                
                // Merchant name with live matching
                _buildMerchantField(),
                
                const SizedBox(height: 16),
                
                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Product name (optional)
                TextFormField(
                  controller: _productController,
                  decoration: const InputDecoration(
                    labelText: 'Product/Description (optional)',
                    hintText: 'e.g., Groceries, Coffee, etc.',
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Date picker
                _buildDatePicker(),
                
                const SizedBox(height: 16),
                
                // Notes (optional)
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  maxLines: 2,
                ),
                
                const SizedBox(height: 32),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitPurchase,
                    child: const Text('Add Purchase'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReceiptParserSection() {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          ListTile(
            title: const Text('Parse Email Receipt'),
            subtitle: const Text('Paste receipt text to auto-fill'),
            trailing: Icon(
              _showReceiptParser ? Icons.expand_less : Icons.expand_more,
              color: AppTheme.textSecondary,
            ),
            onTap: () {
              setState(() {
                _showReceiptParser = !_showReceiptParser;
              });
            },
          ),
          
          if (_showReceiptParser)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(color: AppTheme.border),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _receiptTextController,
                    decoration: const InputDecoration(
                      hintText: 'Paste your email receipt text here...',
                    ),
                    maxLines: 6,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _parseReceipt,
                      child: const Text('Parse Receipt'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildMerchantField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _merchantController,
          decoration: const InputDecoration(
            labelText: 'Store/Merchant',
            hintText: 'e.g., Save-On-Foods, Walmart, Starbucks',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a merchant name';
            }
            return null;
          },
          onChanged: _onMerchantChanged,
        ),
        
        // Merchant suggestions
        if (_merchantSuggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppTheme.bgTertiary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              children: _merchantSuggestions.map((suggestion) {
                return ListTile(
                  dense: true,
                  title: Text(
                    suggestion['companyName'] as String,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Match: ${((suggestion['score'] as double) * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _merchantController.text = suggestion['companyName'] as String;
                      _matchedCompanyId = suggestion['companyId'] as String;
                      _merchantSuggestions = [];
                    });
                  },
                );
              }).toList(),
            ),
          ),
        
        // Matched indicator
        if (_matchedCompanyId != null && _merchantSuggestions.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.accentGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Matched to database',
                  style: TextStyle(
                    color: AppTheme.accentGreen.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date',
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            const Icon(
              Icons.calendar_today,
              color: AppTheme.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
  
  void _onMerchantChanged(String value) {
    if (value.length < 2) {
      setState(() {
        _merchantSuggestions = [];
        _matchedCompanyId = null;
      });
      return;
    }
    
    final suggestions = _database.findPossibleMatches(value, limit: 3);
    
    setState(() {
      _merchantSuggestions = suggestions;
      _matchedCompanyId = _database.matchMerchant(value);
    });
  }
  
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  void _parseReceipt() {
    final text = _receiptTextController.text;
    if (text.isEmpty) return;
    
    final result = _receiptParser.parse(text);
    
    if (result.success) {
      setState(() {
        _merchantController.text = result.storeName ?? '';
        _amountController.text = result.total?.toStringAsFixed(2) ?? '';
        if (result.date != null) {
          _selectedDate = result.date!;
        }
        _matchedCompanyId = _database.matchMerchant(result.storeName ?? '');
        _merchantSuggestions = [];
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receipt parsed successfully'),
          backgroundColor: AppTheme.accentGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Could not parse receipt'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }
  
  void _submitPurchase() {
    if (!_formKey.currentState!.validate()) return;
    
    final amount = double.parse(_amountController.text);
    final merchant = _merchantController.text;
    final product = _productController.text.isEmpty 
        ? 'Purchase' 
        : _productController.text;
    
    final purchase = Purchase.create(
      productName: product,
      amount: amount,
      date: _selectedDate,
      companyName: merchant,
      merchantAlias: _matchedCompanyId,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
    
    context.read<PurchaseService>().addPurchase(purchase);
    
    // Clear form
    _merchantController.clear();
    _amountController.clear();
    _productController.clear();
    _notesController.clear();
    _receiptTextController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _matchedCompanyId = null;
      _merchantSuggestions = [];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase added successfully'),
        backgroundColor: AppTheme.accentGreen,
      ),
    );
  }
}
