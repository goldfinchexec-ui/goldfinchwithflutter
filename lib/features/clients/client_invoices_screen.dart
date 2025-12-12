
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/client.dart';
import '../../data/models/transaction.dart';
import '../../data/providers.dart';
import '../../core/theme/app_theme.dart';

class ClientInvoicesScreen extends ConsumerWidget {
  const ClientInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final clients = ref.watch(clientsProvider);

    // Filter for Client Invoices (Income)
    final clientInvoices = transactions.where((t) =>
      t.type == TransactionType.INCOME &&
      t.category == TransactionCategory.CLIENT_INVOICE
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Client Invoices', style: AppTheme.headingStyle.copyWith(fontSize: 24)),
              Row(
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text('Filter'),
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
                    label: const Text('Create Invoice'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.slate900,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _showAddInvoiceDialog(context, ref, clients),
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
                        Expanded(flex: 35, child: Text('Client Name', style: AppTheme.labelStyle)),
                        Expanded(flex: 25, child: Text('Service Month', style: AppTheme.labelStyle)),
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
                      itemCount: clientInvoices.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final invoice = clientInvoices[index];
                        final clientMatches = clients.where((c) => c.id == invoice.relatedId);
                        final client = clientMatches.isNotEmpty ? clientMatches.first : null;
                        final clientName = client?.name ?? 'Unknown Client';
                        final currencyFormat = NumberFormat.simpleCurrency(name: 'GBP');
                        final dateFormat = DateFormat('MMMM yyyy');

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              // 1. Name Column: Takes 35%
                              Expanded(
                                flex: 35,
                                child: Text(clientName, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              ),
                              // 2. Date Column: Takes 25%
                              Expanded(
                                flex: 25,
                                child: Text(dateFormat.format(invoice.date)),
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
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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

  void _showAddInvoiceDialog(BuildContext context, WidgetRef ref, List<Client> clients) {
    String? selectedClientId;
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    TransactionStatus selectedStatus = TransactionStatus.OUTSTANDING;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Client Invoice', style: AppTheme.headingStyle),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Client'),
                    items: clients.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                    onChanged: (v) => setState(() => selectedClientId = v),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Invoice Description / #'),
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
                  if (selectedClientId != null && amountController.text.isNotEmpty) {
                    final newTx = TransactionModel(
                      id: const Uuid().v4(),
                      type: TransactionType.INCOME,
                      category: TransactionCategory.CLIENT_INVOICE,
                      relatedId: selectedClientId,
                      status: selectedStatus,
                      fileUrls: [], // No file upload for client invoice
                      date: selectedDate,
                      amount: double.tryParse(amountController.text) ?? 0.0,
                      description: descriptionController.text,
                    );
                    ref.read(transactionsProvider.notifier).add(newTx);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create Invoice'),
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
