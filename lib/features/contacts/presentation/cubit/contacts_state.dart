part of 'contacts_cubit.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsRefreshing extends ContactsState {
  final List<ContactEntity> currentContacts;

  const ContactsRefreshing({required this.currentContacts});

  @override
  List<Object> get props => [currentContacts];
}

class ContactsAddingContact extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> contacts;

  const ContactsLoaded({required this.contacts});

  @override
  List<Object> get props => [contacts];
}

class ContactsError extends ContactsState {
  final String errorMessage;

  const ContactsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ContactNotFound extends ContactsState {
  final String message;

  const ContactNotFound({required this.message});

  @override
  List<Object> get props => [message];
}
