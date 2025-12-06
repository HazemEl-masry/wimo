import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/core/usecase/usecase.dart';
import 'package:wimo/features/contacts/domain/entities/contact_entity.dart';
import 'package:wimo/features/contacts/domain/repositories/contacts_repository.dart';

class VerifyAddContactUseCase
    implements UseCase<ContactEntity?, VerifyAddContactParams> {
  final ContactsRepository repository;

  VerifyAddContactUseCase({required this.repository});

  @override
  Future<Either<Failure, ContactEntity?>> call(
    VerifyAddContactParams params,
  ) async {
    return await repository.verifyAndAddContact(
      name: params.name,
      phone: params.phone,
    );
  }
}

class VerifyAddContactParams {
  final String name;
  final String phone;

  VerifyAddContactParams({required this.name, required this.phone});
}
