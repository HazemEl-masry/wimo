import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/core/di/injection_container.dart';
import 'package:wimo/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:wimo/features/contacts/presentation/widgets/add_contact_bottom_sheet.dart';
import 'package:wimo/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:wimo/features/contacts/presentation/widgets/contacts_empty_state.dart';
import 'package:wimo/features/contacts/presentation/widgets/contacts_error_state.dart';

/// Main contacts screen - clean and focused
class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContactsCubit>()..loadContacts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: _buildBody(),
        floatingActionButton: _buildFAB(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Contacts',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            if (state is ContactsRefreshing) {
              return _buildRefreshingIndicator();
            }
            return _buildPopupMenu(context);
          },
        ),
      ],
    );
  }

  Widget _buildRefreshingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        onSelected: (value) => _handleMenuAction(context, value),
        itemBuilder: (context) => [
          _buildMenuItem('add', Icons.person_add, 'Add Contact', [
            const Color(0xFF667EEA),
            const Color(0xFF764BA2),
          ]),
          _buildMenuItem('refresh', Icons.refresh, 'Refresh', [
            const Color(0xFF11998E),
            const Color(0xFF38EF7D),
          ]),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text,
    List<Color> gradientColors,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    if (value == 'add') {
      _showAddContactBottomSheet(context);
    } else if (value == 'refresh') {
      context.read<ContactsCubit>().refreshContacts();
    }
  }

  Widget _buildBody() {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        if (state is ContactsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContactsRefreshing) {
          return _buildContactsList(context, state.currentContacts);
        } else if (state is ContactsError) {
          return ContactsErrorState(
            errorMessage: state.errorMessage,
            onRetry: () => context.read<ContactsCubit>().loadContacts(),
          );
        } else if (state is ContactsLoaded) {
          if (state.contacts.isEmpty) {
            return ContactsEmptyState(
              onAddContact: () => _showAddContactBottomSheet(context),
            );
          }
          return _buildContactsList(context, state.contacts);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildContactsList(BuildContext context, List contacts) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ContactsCubit>().refreshContacts();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 100,
          bottom: 20,
          left: 16,
          right: 16,
        ),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ContactListItem(
            contact: contact,
            onTap: () {
              // TODO: Navigate to chat or contact details
            },
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _showAddContactBottomSheet(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.person_add, size: 28),
          ),
        );
      },
    );
  }

  void _showAddContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<ContactsCubit>(),
        child: const AddContactBottomSheet(),
      ),
    );
  }
}
