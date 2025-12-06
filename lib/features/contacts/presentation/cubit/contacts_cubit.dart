import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wimo/core/usecase/usecase.dart';
import 'package:wimo/features/contacts/domain/entities/contact_entity.dart';
import 'package:wimo/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:wimo/features/contacts/domain/usecases/sync_contacts_usecase.dart';
import 'package:wimo/features/contacts/domain/usecases/verify_add_contact_usecase.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase getContactsUseCase;
  final SyncContactsUseCase syncContactsUseCase;
  final VerifyAddContactUseCase verifyAddContactUseCase;

  ContactsCubit({
    required this.getContactsUseCase,
    required this.syncContactsUseCase,
    required this.verifyAddContactUseCase,
  }) : super(ContactsInitial());

  Future<void> loadContacts() async {
    emit(ContactsLoading());
    final result = await getContactsUseCase.call(NoParams());
    result.fold(
      (failure) => emit(ContactsError(errorMessage: failure.errorMessage)),
      (contacts) => emit(ContactsLoaded(contacts: contacts)),
    );
  }

  Future<void> refreshContacts() async {
    // Get current contacts to show while refreshing
    final currentState = state;
    final currentContacts = currentState is ContactsLoaded
        ? currentState.contacts
        : <ContactEntity>[];

    emit(ContactsRefreshing(currentContacts: currentContacts));

    final result = await getContactsUseCase.call(NoParams());
    result.fold(
      (failure) => emit(ContactsError(errorMessage: failure.errorMessage)),
      (contacts) => emit(ContactsLoaded(contacts: contacts)),
    );
  }

  Future<void> addContact({required String name, required String phone}) async {
    emit(ContactsAddingContact());

    final result = await verifyAddContactUseCase.call(
      VerifyAddContactParams(name: name, phone: phone),
    );

    result.fold(
      (failure) => emit(ContactsError(errorMessage: failure.errorMessage)),
      (contact) {
        if (contact == null) {
          // Phone number not found in the app
          emit(
            const ContactNotFound(
              message: 'This phone number is not registered in the app',
            ),
          );
        } else {
          // Contact found, refresh the list to show updated contacts
          loadContacts();
        }
      },
    );
  }

  Future<void> syncContacts(List<String> phones) async {
    emit(ContactsLoading());
    final result = await syncContactsUseCase.call(
      SyncContactsParams(phones: phones),
    );
    result.fold(
      (failure) => emit(ContactsError(errorMessage: failure.errorMessage)),
      (contacts) => emit(ContactsLoaded(contacts: contacts)),
    );
  }
}
