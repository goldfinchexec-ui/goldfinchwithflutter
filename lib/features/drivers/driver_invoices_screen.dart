
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/driver.dart';
import '../../data/models/transaction.dart';
import '../../data/providers.dart';
import '../../core/theme/app_theme.dart';

class DriverInvoicesScreen extends ConsumerWidget {
  const DriverInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final drivers = ref.watch(driversProvider);

    // Filter for Driver Invoices (Expenses)
    final driverInvoices = transactions.where((t) =>
      t.type == TransactionType.EXPENSE &&
      (t.category == TransactionCategory.DRIVER_PAYOUT)
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Driver Invoices', style: AppTheme.headingStyle.copyWith(fontSize: 24)),
              Row(
                children: [
                  // Month Picker placeholder
                  OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: const Text('This Month'),
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.slate900,
                      side: const BorderSide(color: AppTheme.borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Invoice'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.slate900,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _showAddInvoiceDialog(context, ref, drivers),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              child: Column(
                children: [
                  // Table Header - Using the "Perfect Layout" rules
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(flex: 35, child: Text('Driver Name', style: AppTheme.labelStyle)),
                        Expanded(flex: 25, child: Text('Date Range', style: AppTheme.labelStyle)),
                        Expanded(flex: 15, child: Text('Status', style: AppTheme.labelStyle)),
                        Expanded(flex: 15, child: Text('Amount', style: AppTheme.labelStyle, textAlign: TextAlign.right)),
                        SizedBox(width: 80, child: Text('Actions', style: AppTheme.labelStyle, textAlign: TextAlign.end)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // List
                  Expanded(
                    child: ListView.separated(
                      itemCount: driverInvoices.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final invoice = driverInvoices[index];
                        final driverMatches = drivers.where((d) => d.id == invoice.relatedId);
                        final driver = driverMatches.isNotEmpty ? driverMatches.first : null;
                        final driverName = driver?.name ?? 'Unknown Driver';
                        final currencyFormat = NumberFormat.simpleCurrency(name: 'GBP');
                        final dateFormat = DateFormat('dd MMM');

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              // 1. Name Column: Takes 35%
                              Expanded(
                                flex: 35,
                                child: Text(driverName, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              ),
                              // 2. Date Column: Takes 25%
                              Expanded(
                                flex: 25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dateFormat.format(invoice.date)),
                                    if (invoice.endDate != null) Text(dateFormat.format(invoice.endDate!)),
                                  ],
                                ),
                              ),
                              // 3. Status Column: Takes 15%
                              Expanded(
                                flex: 15,
                                child: _StatusBadge(status: invoice.status),
                              ),
                              // 4. Amount Column: Takes 15% (Aligned Right)
                              Expanded(
                                flex: 15,
                                child: Text(
                                  currencyFormat.format(invoice.amount),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                              // 5. Actions: Fixed Width
                              SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () {
                                         // Mock edit - just show a snackbar for now or reuse dialog
                                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature not implemented for invoices yet.')));
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                      onPressed: () => ref.read(transactionsProvider.notifier).delete(invoice.id),
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

  void _showAddInvoiceDialog(BuildContext context, WidgetRef ref, List<Driver> drivers) {
    String? selectedDriverId;
    final amountController = TextEditingController();
    TransactionStatus selectedStatus = TransactionStatus.PENDING;
    DateTime selectedDate = DateTime.now();
    // Simplified for MVP - File upload logic would go here

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Driver Invoice', style: AppTheme.headingStyle),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Driver'),
                    items: drivers.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                    onChanged: (v) => setState(() => selectedDriverId = v),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount (£)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TransactionStatus>(
                    decoration: const InputDecoration(labelText: 'Status'),
                    value: selectedStatus,
                    items: TransactionStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.toString().split('.').last))).toList(),
                    onChanged: (v) => setState(() => selectedStatus = v!),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      // Mock file picker
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload PDF/Image'),
                  ),
                ],
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
                  if (selectedDriverId != null && amountController.text.isNotEmpty) {
                    final newTx = TransactionModel(
                      id: const Uuid().v4(),
                      type: TransactionType.EXPENSE,
                      category: TransactionCategory.DRIVER_PAYOUT,
                      relatedId: selectedDriverId,
                      status: selectedStatus,
                      fileUrls: [], // TODO: Add file url
                      date: selectedDate,
                      amount: double.tryParse(amountController.text) ?? 0.0,
                      description: 'Driver Payout',
                    );
                    ref.read(transactionsProvider.notifier).add(newTx);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Invoice'),
              ),
            ],
          );
        }
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case TransactionStatus.PAID:
      case TransactionStatus.RECEIVED:
        color = Colors.green;
        break;
      case TransactionStatus.PENDING:
      case TransactionStatus.OUTSTANDING:
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toString().split('.').last,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
