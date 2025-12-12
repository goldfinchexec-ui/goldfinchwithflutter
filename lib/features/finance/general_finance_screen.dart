
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/transaction.dart';
import '../../data/providers.dart';
import '../../core/theme/app_theme.dart';

class GeneralFinanceScreen extends ConsumerWidget {
  const GeneralFinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    // Filter for General Finance (Income/Expense)
    final generalTransactions = transactions.where((t) =>
      t.category == TransactionCategory.GENERAL_INCOME ||
      t.category == TransactionCategory.GENERAL_EXPENSE
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('General Finance', style: AppTheme.headingStyle.copyWith(fontSize: 24)),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.slate900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showAddTransactionDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              child: Column(
                children: [
                  // Table Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(flex: 35, child: Text('Description', style: AppTheme.labelStyle)),
                        Expanded(flex: 25, child: Text('Date', style: AppTheme.labelStyle)),
                        Expanded(flex: 15, child: Text('Category', style: AppTheme.labelStyle)),
                        Expanded(flex: 15, child: Text('Amount', style: AppTheme.labelStyle, textAlign: TextAlign.right)),
                        SizedBox(width: 80, child: Text('Actions', style: AppTheme.labelStyle, textAlign: TextAlign.end)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // List
                  Expanded(
                    child: ListView.separated(
                      itemCount: generalTransactions.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final tx = generalTransactions[index];
                        final currencyFormat = NumberFormat.simpleCurrency(name: 'GBP');
                        final dateFormat = DateFormat('dd MMM yyyy');
                        final isExpense = tx.type == TransactionType.EXPENSE;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 35,
                                child: Text(tx.description, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              ),
                              Expanded(
                                flex: 25,
                                child: Text(dateFormat.format(tx.date)),
                              ),
                              Expanded(
                                flex: 15,
                                child: Text(tx.category.toString().split('.').last.replaceAll('_', ' '), style: TextStyle(fontSize: 12, color: AppTheme.slate500)),
                              ),
                              Expanded(
                                flex: 15,
                                child: Text(
                                  currencyFormat.format(tx.amount),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: isExpense ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () {
                                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature not implemented for transactions yet.')));
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                      onPressed: () => ref.read(transactionsProvider.notifier).delete(tx.id),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, WidgetRef ref) {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    TransactionType selectedType = TransactionType.EXPENSE;
    TransactionCategory selectedCategory = TransactionCategory.GENERAL_EXPENSE;
    TransactionStatus selectedStatus = TransactionStatus.PAID;
    DateTime selectedDate = DateTime.now();
    bool hasFile = false; // Mock file upload

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add General Transaction', style: AppTheme.headingStyle),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<TransactionType>(
                      decoration: const InputDecoration(labelText: 'Type'),
                      value: selectedType,
                      items: TransactionType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.toString().split('.').last))).toList(),
                      onChanged: (v) {
                         setState(() {
                           selectedType = v!;
                           if (selectedType == TransactionType.INCOME) {
                             selectedCategory = TransactionCategory.GENERAL_INCOME;
                           } else {
                             selectedCategory = TransactionCategory.GENERAL_EXPENSE;
                           }
                         });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description (e.g., Fuel, Rent, Rebate)'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: 'Amount (£)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    // Show file upload only for expenses
                    if (selectedType == TransactionType.EXPENSE)
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() => hasFile = !hasFile);
                        },
                        icon: Icon(hasFile ? Icons.check : Icons.upload_file),
                        label: Text(hasFile ? 'File Attached (Mock)' : 'Upload Receipt'),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: AppTheme.slate500)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.slate900,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (descriptionController.text.isNotEmpty && amountController.text.isNotEmpty) {
                    final newTx = TransactionModel(
                      id: const Uuid().v4(),
                      type: selectedType,
                      category: selectedCategory,
                      status: selectedStatus,
                      fileUrls: hasFile ? ['http://mock.url/receipt.pdf'] : [],
                      date: selectedDate,
                      amount: double.tryParse(amountController.text) ?? 0.0,
                      description: descriptionController.text,
                    );
                    ref.read(transactionsProvider.notifier).add(newTx);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Transaction'),
              ),
            ],
          );
        }
      ),
    );
  }
}
