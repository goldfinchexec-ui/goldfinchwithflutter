
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/driver.dart';
import '../models/client.dart';
import '../models/transaction.dart';

class DatabaseService {
  final List<Driver> _drivers = [];
  final List<Client> _clients = [];
  final List<TransactionModel> _transactions = [];

  // Initialize with some dummy data
  DatabaseService() {
    _seedData();
  }

  void _seedData() {
    // Drivers
    _drivers.add(Driver(id: 'd1', name: 'John Doe', code: 'D001', email: 'john@example.com', vehicleReg: 'AB12 CDE'));
    _drivers.add(Driver(id: 'd2', name: 'Jane Smith', code: 'D002', email: 'jane@example.com', vehicleReg: 'XY98 ZYW'));

    // Clients
    _clients.add(Client(id: 'c1', name: 'Acme Corp', email: 'contact@acme.com', address: '123 Acme Way'));
    _clients.add(Client(id: 'c2', name: 'Globex', email: 'info@globex.com', address: '456 Globex St'));

    // Transactions
    _transactions.add(TransactionModel(
      id: 't1',
      type: TransactionType.EXPENSE,
      category: TransactionCategory.DRIVER_PAYOUT,
      relatedId: 'd1',
      status: TransactionStatus.PAID,
      fileUrls: ['http://example.com/receipt1.pdf'],
      date: DateTime.now().subtract(const Duration(days: 5)),
      amount: 500.0,
      description: 'Monthly Payout',
    ));

    _transactions.add(TransactionModel(
      id: 't2',
      type: TransactionType.INCOME,
      category: TransactionCategory.CLIENT_INVOICE,
      relatedId: 'c1',
      status: TransactionStatus.RECEIVED,
      fileUrls: [],
      date: DateTime.now().subtract(const Duration(days: 2)),
      amount: 1200.0,
      description: 'Consulting Services',
    ));
  }

  // Drivers
  List<Driver> getDrivers() => List.unmodifiable(_drivers);
  void addDriver(Driver driver) { _drivers.add(driver); }
  void updateDriver(Driver driver) {
    int index = _drivers.indexWhere((d) => d.id == driver.id);
    if (index != -1) _drivers[index] = driver;
  }
  void deleteDriver(String id) { _drivers.removeWhere((d) => d.id == id); }

  // Clients
  List<Client> getClients() => List.unmodifiable(_clients);
  void addClient(Client client) { _clients.add(client); }
  void updateClient(Client client) {
    int index = _clients.indexWhere((c) => c.id == client.id);
    if (index != -1) _clients[index] = client;
  }
  void deleteClient(String id) { _clients.removeWhere((c) => c.id == id); }

  // Transactions
  List<TransactionModel> getTransactions() => List.unmodifiable(_transactions);
  void addTransaction(TransactionModel transaction) { _transactions.add(transaction); }
  void updateTransaction(TransactionModel transaction) {
    int index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) _transactions[index] = transaction;
  }
  void deleteTransaction(String id) { _transactions.removeWhere((t) => t.id == id); }

  // Helpers
  Driver? getDriver(String? id) {
    if (id == null) return null;
    final found = _drivers.where((d) => d.id == id);
    return found.isNotEmpty ? found.first : null;
  }

  Client? getClient(String? id) {
    if (id == null) return null;
    final found = _clients.where((c) => c.id == id);
    return found.isNotEmpty ? found.first : null;
  }
}

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});
