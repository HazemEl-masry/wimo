import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/features/contacts/domain/entities/contact_entity.dart';

abstract class ContactsRepository {
  Future<Either<Failure, List<ContactEntity>>> getContacts();
  Future<Either<Failure, List<ContactEntity>>> syncContacts({
    required List<String> phones,
  });
  Future<Either<Failure, ContactEntity?>> verifyAndAddContact({
    required String name,
    required String phone,
  });
}
