
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/providers.dart';
import '../../core/theme/app_theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(monthlySummaryProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial Dashboard', style: AppTheme.headingStyle.copyWith(fontSize: 24)),
          const SizedBox(height: 24),
          Row(
            children: [
              _SummaryCard(
                title: 'Total Income',
                amount: summary['income']!,
                color: Colors.green,
                icon: Icons.arrow_upward,
              ),
              const SizedBox(width: 24),
              _SummaryCard(
                title: 'Total Expense',
                amount: summary['expense']!,
                color: Colors.red,
                icon: Icons.arrow_downward,
              ),
              const SizedBox(width: 24),
              _SummaryCard(
                title: 'Net Profit',
                amount: summary['net']!,
                color: Colors.black,
                icon: Icons.account_balance,
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text('Recent Transactions', style: AppTheme.headingStyle.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          Expanded(child: _RecentTransactionsList()),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(name: 'GBP');
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(title, style: AppTheme.labelStyle, overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Icon(icon, color: color, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                currencyFormat.format(amount),
                style: AppTheme.headingStyle.copyWith(fontSize: 28, color: color),
              ),
              const SizedBox(height: 4),
              Text('This month', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactionsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    // Show last 5
    final recent = transactions.reversed.take(5).toList();

    return Card(
      child: ListView.separated(
        itemCount: recent.length,
        separatorBuilder: (c, i) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final t = recent[index];
          final isExpense = t.type.toString().contains('EXPENSE');
          final currencyFormat = NumberFormat.simpleCurrency(name: 'GBP');
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            title: Text(t.description.isNotEmpty ? t.description : t.category.toString().split('.').last),
            subtitle: Text(DateFormat('dd MMM yyyy').format(t.date)),
            trailing: Text(
              currencyFormat.format(t.amount),
              style: TextStyle(
                color: isExpense ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
