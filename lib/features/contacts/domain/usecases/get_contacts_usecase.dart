import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/core/usecase/usecase.dart';
import 'package:wimo/features/contacts/domain/entities/contact_entity.dart';
import 'package:wimo/features/contacts/domain/repositories/contacts_repository.dart';

class GetContactsUseCase implements UseCase<List<ContactEntity>, NoParams> {
  final ContactsRepository repository;

  GetContactsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ContactEntity>>> call(NoParams params) async {
    return await repository.getContacts();
  }
}
