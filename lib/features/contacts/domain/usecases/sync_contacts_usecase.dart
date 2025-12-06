import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/core/usecase/usecase.dart';
import 'package:wimo/features/contacts/domain/entities/contact_entity.dart';
import 'package:wimo/features/contacts/domain/repositories/contacts_repository.dart';

class SyncContactsUseCase
    implements UseCase<List<ContactEntity>, SyncContactsParams> {
  final ContactsRepository repository;

  SyncContactsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ContactEntity>>> call(
    SyncContactsParams params,
  ) async {
    return await repository.syncContacts(phones: params.phones);
  }
}

class SyncContactsParams extends Equatable {
  final List<String> phones;

  const SyncContactsParams({required this.phones});

  @override
  List<Object> get props => [phones];
}
