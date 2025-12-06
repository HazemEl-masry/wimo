import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/core/di/injection_container.dart';
import 'package:wimo/features/contacts/presentation/cubit/contacts_cubit.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContactsCubit>()..loadContacts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          actions: [
            BlocBuilder<ContactsCubit, ContactsState>(
              builder: (context, state) {
                if (state is ContactsLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'add') {
                      _showAddContactBottomSheet(context);
                    } else if (value == 'refresh') {
                      context.read<ContactsCubit>().loadContacts();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'add',
                      child: Text('Add Contact'),
                    ),
                    const PopupMenuItem(
                      value: 'refresh',
                      child: Text('Refresh'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ContactsCubit>().loadContacts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is ContactsLoaded) {
              if (state.contacts.isEmpty) {
                return const Center(child: Text('No contacts found'));
              }
              return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(contact.name[0].toUpperCase()),
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.contactPhone),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _showAddContactBottomSheet(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Contact',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter contact name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number (e.g. +123...)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final phone = phoneController.text.trim();
                  if (phone.isNotEmpty) {
                    // Note: Backend currently only uses phone number for sync.
                    // Name from input is not cached locally yet as per current architecture.
                    context.read<ContactsCubit>().syncContacts([phone]);
                    Navigator.pop(sheetContext);
                  }
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
