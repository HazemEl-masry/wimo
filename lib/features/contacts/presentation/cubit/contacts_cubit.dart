import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wimo/core/usecase/usecase.dart';
import 'package:wimo/features/contacts/domain/entities/contact_entity.dart';
import 'package:wimo/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:wimo/features/contacts/domain/usecases/sync_contacts_usecase.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase getContactsUseCase;
  final SyncContactsUseCase syncContactsUseCase;

  ContactsCubit({
    required this.getContactsUseCase,
    required this.syncContactsUseCase,
  }) : super(ContactsInitial());

  Future<void> loadContacts() async {
    emit(ContactsLoading());
    final result = await getContactsUseCase.call(NoParams());
    result.fold(
      (failure) => emit(ContactsError(errorMessage: failure.errorMessage)),
      (contacts) => emit(ContactsLoaded(contacts: contacts)),
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
