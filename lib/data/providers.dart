
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/driver.dart';
import 'models/client.dart';
import 'models/transaction.dart';
import 'services/database_service.dart';

// Drivers Provider
final driversProvider = NotifierProvider<DriversNotifier, List<Driver>>(DriversNotifier.new);

class DriversNotifier extends Notifier<List<Driver>> {
  @override
  List<Driver> build() {
    return ref.watch(databaseServiceProvider).getDrivers();
  }

  void add(Driver driver) {
    ref.read(databaseServiceProvider).addDriver(driver);
    state = ref.read(databaseServiceProvider).getDrivers();
  }

  void update(Driver driver) {
    ref.read(databaseServiceProvider).updateDriver(driver);
    state = ref.read(databaseServiceProvider).getDrivers();
  }

  void delete(String id) {
    ref.read(databaseServiceProvider).deleteDriver(id);
    state = ref.read(databaseServiceProvider).getDrivers();
  }
}

// Clients Provider
final clientsProvider = NotifierProvider<ClientsNotifier, List<Client>>(ClientsNotifier.new);

class ClientsNotifier extends Notifier<List<Client>> {
  @override
  List<Client> build() {
    return ref.watch(databaseServiceProvider).getClients();
  }

  void add(Client client) {
    ref.read(databaseServiceProvider).addClient(client);
    state = ref.read(databaseServiceProvider).getClients();
  }

  void update(Client client) {
    ref.read(databaseServiceProvider).updateClient(client);
    state = ref.read(databaseServiceProvider).getClients();
  }

  void delete(String id) {
    ref.read(databaseServiceProvider).deleteClient(id);
    state = ref.read(databaseServiceProvider).getClients();
  }
}

// Transactions Provider
final transactionsProvider = NotifierProvider<TransactionsNotifier, List<TransactionModel>>(TransactionsNotifier.new);

class TransactionsNotifier extends Notifier<List<TransactionModel>> {
  @override
  List<TransactionModel> build() {
    return ref.watch(databaseServiceProvider).getTransactions();
  }

  void add(TransactionModel transaction) {
    ref.read(databaseServiceProvider).addTransaction(transaction);
    state = ref.read(databaseServiceProvider).getTransactions();
  }

  void update(TransactionModel transaction) {
    ref.read(databaseServiceProvider).updateTransaction(transaction);
    state = ref.read(databaseServiceProvider).getTransactions();
  }

  void delete(String id) {
    ref.read(databaseServiceProvider).deleteTransaction(id);
    state = ref.read(databaseServiceProvider).getTransactions();
  }
}

// Filtered Transactions
final receiptVaultProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.where((t) => t.fileUrls.isNotEmpty).toList();
});

final monthlySummaryProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final now = DateTime.now();

  final currentMonthTransactions = transactions.where((t) {
    return t.date.year == now.year && t.date.month == now.month;
  });

  double totalIncome = 0;
  double totalExpense = 0;

  for (var t in currentMonthTransactions) {
    if (t.type == TransactionType.INCOME) {
      totalIncome += t.amount;
    } else {
      totalExpense += t.amount;
    }
  }

  return {
    'income': totalIncome,
    'expense': totalExpense,
    'net': totalIncome - totalExpense,
  };
});
