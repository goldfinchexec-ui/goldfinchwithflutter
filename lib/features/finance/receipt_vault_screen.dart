
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/providers.dart';
import '../../core/theme/app_theme.dart';

class ReceiptVaultScreen extends ConsumerWidget {
  const ReceiptVaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // "The Receipt Vault is simply a filtered view of ALL transactions that have an attachment."
    final transactions = ref.watch(receiptVaultProvider);
    final drivers = ref.watch(driversProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Receipt Vault', style: AppTheme.headingStyle.copyWith(fontSize: 24)),
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
                        Expanded(flex: 25, child: Text('Date', style: AppTheme.labelStyle)),
                        Expanded(flex: 35, child: Text('Expense Name / Driver', style: AppTheme.labelStyle)),
                        Expanded(flex: 15, child: Text('Amount', style: AppTheme.labelStyle, textAlign: TextAlign.right)),
                        Expanded(flex: 15, child: Text('Uploaded By', style: AppTheme.labelStyle)),
                        SizedBox(width: 80, child: Text('Actions', style: AppTheme.labelStyle, textAlign: TextAlign.end)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // List
                  Expanded(
                    child: transactions.isEmpty
                      ? const Center(child: Text('No receipts found'))
                      : ListView.separated(
                      itemCount: transactions.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final currencyFormat = NumberFormat.simpleCurrency(name: 'GBP');
                        final dateFormat = DateFormat('dd MMM yyyy');

                        // Determine name
                        String name = tx.description;
                        if (name.isEmpty && tx.relatedId != null) {
                          final driverMatches = drivers.where((d) => d.id == tx.relatedId);
                          final driver = driverMatches.isNotEmpty ? driverMatches.first : null;
                          if (driver != null) {
                            name = '${driver.name} Invoice';
                          }
                        }
                        if (name.isEmpty) name = 'Expense';

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              // 1. Date (Sortable logic not impl in UI but col exists)
                              Expanded(
                                flex: 25,
                                child: Text(dateFormat.format(tx.date)),
                              ),
                              // 2. Expense Name / Driver
                              Expanded(
                                flex: 35,
                                child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              ),
                              // 3. Amount (Red text)
                              Expanded(
                                flex: 15,
                                child: Text(
                                  currencyFormat.format(tx.amount),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                              // 4. Uploaded By (Staff Profile Chip)
                              Expanded(
                                flex: 15,
                                child: Chip(
                                  label: const Text('Admin', style: TextStyle(fontSize: 10)),
                                  backgroundColor: AppTheme.slate100,
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              // 5. Actions (Eye + Download)
                              SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.visibility, size: 18),
                                      onPressed: () => _showFilePreview(context, tx.fileUrls.first),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.download, size: 18),
                                      onPressed: () {
                                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download started (Mock)')));
                                      },
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

  void _showFilePreview(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 500,
          height: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('File Preview', style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.insert_drive_file, size: 64, color: AppTheme.slate500),
                      const SizedBox(height: 16),
                      Text(url),
                      const SizedBox(height: 8),
                      const Text('(Mock Preview)', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
