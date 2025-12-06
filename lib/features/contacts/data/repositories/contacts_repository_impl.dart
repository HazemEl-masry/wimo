import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/features/contacts/data/datasources/contact_remote_data_source.dart';
import 'package:wimo/features/contacts/domain/entities/contact_entity.dart';
import 'package:wimo/features/contacts/domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ContactEntity>>> getContacts() async {
    try {
      final models = await remoteDataSource.getContacts();
      // Filter to only include contacts using the app
      final entities = models
          .where((model) => model.isChatAppUser)
          .map(
            (model) => ContactEntity(
              id: model.id,
              userId: model.userId,
              contactPhone: model.contactPhone,
              contactUserId: model.contactUserId,
              name: model.name,
              isChatAppUser: model.isChatAppUser,
              createdAt: model.createdAt,
              updatedAt: model.updatedAt,
              user: model.userInfo != null
                  ? UserParams(
                      id: model.userInfo!.id,
                      name: model.userInfo!.name,
                      bio: model.userInfo!.bio,
                      avatar: model.userInfo!.avatar,
                      isOnline: model.userInfo!.isOnline,
                      lastSeen: model.userInfo!.lastSeen,
                    )
                  : null,
            ),
          )
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ContactEntity>>> syncContacts({
    required List<String> phones,
  }) async {
    try {
      final models = await remoteDataSource.syncContacts(phoneNumbers: phones);
      // Filter to only include contacts using the app
      final entities = models
          .where((model) => model.isChatAppUser)
          .map(
            (model) => ContactEntity(
              id: model.id,
              userId: model.userId,
              contactPhone: model.contactPhone,
              contactUserId: model.contactUserId,
              name: model.name,
              isChatAppUser: model.isChatAppUser,
              createdAt: model.createdAt,
              updatedAt: model.updatedAt,
              user: model.userInfo != null
                  ? UserParams(
                      id: model.userInfo!.id,
                      name: model.userInfo!.name,
                      bio: model.userInfo!.bio,
                      avatar: model.userInfo!.avatar,
                      isOnline: model.userInfo!.isOnline,
                      lastSeen: model.userInfo!.lastSeen,
                    )
                  : null,
            ),
          )
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContactEntity?>> verifyAndAddContact({
    required String name,
    required String phone,
  }) async {
    try {
      final model = await remoteDataSource.verifyPhoneNumber(phone);

      if (model == null) {
        // Phone number not found in backend
        return const Right(null);
      }

      // Check if the contact is using the app
      if (!model.isChatAppUser) {
        // Contact exists in backend but not using the app
        return const Right(null);
      }

      final entity = ContactEntity(
        id: model.id,
        userId: model.userId,
        contactPhone: model.contactPhone,
        contactUserId: model.contactUserId,
        name: model.name,
        isChatAppUser: model.isChatAppUser,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        user: model.userInfo != null
            ? UserParams(
                id: model.userInfo!.id,
                name: model.userInfo!.name,
                bio: model.userInfo!.bio,
                avatar: model.userInfo!.avatar,
                isOnline: model.userInfo!.isOnline,
                lastSeen: model.userInfo!.lastSeen,
              )
            : null,
      );
      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
