
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/client.dart';
import '../../data/providers.dart';
import '../../core/theme/app_theme.dart';

class ClientsScreen extends ConsumerWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('All Clients', style: AppTheme.headingStyle.copyWith(fontSize: 24)),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Client'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.slate900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showAddEditClientDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(flex: 30, child: Text('Name', style: AppTheme.labelStyle)),
                        Expanded(flex: 30, child: Text('Email', style: AppTheme.labelStyle)),
                        Expanded(flex: 40, child: Text('Address', style: AppTheme.labelStyle)),
                        SizedBox(width: 80, child: Text('Actions', style: AppTheme.labelStyle, textAlign: TextAlign.end)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // List
                  Expanded(
                    child: ListView.separated(
                      itemCount: clients.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final client = clients[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(flex: 30, child: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 30, child: Text(client.email)),
                              Expanded(flex: 40, child: Text(client.address)),
                              SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () => _showAddEditClientDialog(context, ref, client: client),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                      onPressed: () => ref.read(clientsProvider.notifier).delete(client.id),
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

  void _showAddEditClientDialog(BuildContext context, WidgetRef ref, {Client? client}) {
    final nameController = TextEditingController(text: client?.name ?? '');
    final emailController = TextEditingController(text: client?.email ?? '');
    final addressController = TextEditingController(text: client?.address ?? '');
    final isEditing = client != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Client' : 'Add New Client', style: AppTheme.headingStyle),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
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
              final newClient = Client(
                id: client?.id ?? const Uuid().v4(),
                name: nameController.text,
                email: emailController.text,
                address: addressController.text,
              );

              if (isEditing) {
                ref.read(clientsProvider.notifier).update(newClient);
              } else {
                ref.read(clientsProvider.notifier).add(newClient);
              }
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }
}
