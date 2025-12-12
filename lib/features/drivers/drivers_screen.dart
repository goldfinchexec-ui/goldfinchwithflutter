
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/driver.dart';
import '../../data/providers.dart';
import '../../core/theme/app_theme.dart';

class DriversScreen extends ConsumerWidget {
  const DriversScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drivers = ref.watch(driversProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('All Drivers', style: AppTheme.headingStyle.copyWith(fontSize: 24)),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Driver'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.slate900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showAddEditDriverDialog(context, ref),
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
                        Expanded(flex: 20, child: Text('Code', style: AppTheme.labelStyle)),
                        Expanded(flex: 30, child: Text('Email', style: AppTheme.labelStyle)),
                        Expanded(flex: 20, child: Text('Vehicle Reg', style: AppTheme.labelStyle)),
                        SizedBox(width: 80, child: Text('Actions', style: AppTheme.labelStyle, textAlign: TextAlign.end)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // List
                  Expanded(
                    child: ListView.separated(
                      itemCount: drivers.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final driver = drivers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(flex: 30, child: Text(driver.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 20, child: Text(driver.code)),
                              Expanded(flex: 30, child: Text(driver.email)),
                              Expanded(flex: 20, child: Text(driver.vehicleReg)),
                              SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () => _showAddEditDriverDialog(context, ref, driver: driver),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                      onPressed: () => ref.read(driversProvider.notifier).delete(driver.id),
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

  void _showAddEditDriverDialog(BuildContext context, WidgetRef ref, {Driver? driver}) {
    final nameController = TextEditingController(text: driver?.name ?? '');
    final codeController = TextEditingController(text: driver?.code ?? '');
    final emailController = TextEditingController(text: driver?.email ?? '');
    final regController = TextEditingController(text: driver?.vehicleReg ?? '');
    final isEditing = driver != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Driver' : 'Add New Driver', style: AppTheme.headingStyle),
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
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: regController,
                decoration: const InputDecoration(labelText: 'Vehicle Registration'),
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
              final newDriver = Driver(
                id: driver?.id ?? const Uuid().v4(),
                name: nameController.text,
                code: codeController.text,
                email: emailController.text,
                vehicleReg: regController.text,
              );

              if (isEditing) {
                ref.read(driversProvider.notifier).update(newDriver);
              } else {
                ref.read(driversProvider.notifier).add(newDriver);
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
