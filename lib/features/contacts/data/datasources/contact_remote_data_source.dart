import 'package:wimo/core/constants/api_constants.dart';
import 'package:wimo/core/models/contact_model.dart';
import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/utils/logger.dart';

abstract class ContactRemoteDataSource {
  Future<List<ContactModel>> getContacts();
  Future<List<ContactModel>> syncContacts({required List<String> phoneNumbers});
  Future<ContactModel?> verifyPhoneNumber(String phone);
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final ApiServices apiServices;

  ContactRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<List<ContactModel>> getContacts() async {
    try {
      AppLogger.logRequest('GET', ApiConstants.contacts);
      final response = await apiServices.getRequest(
        endPoint: ApiConstants.contacts,
      );

      if (response.statusCode == 200) {
        final List contacts = response.data['data']['contacts'];
        AppLogger.logResponse(
          response.statusCode!,
          ApiConstants.contacts,
          'Found ${contacts.length} contacts',
        );
        return contacts.map((json) => ContactModel.fromJson(json)).toList();
      } else {
        AppLogger.error('Failed to get contacts', response.statusMessage);
        throw Exception('Failed to get contacts: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get contacts', e, stackTrace);
      throw Exception('Failed to get contacts: ${e.toString()}');
    }
  }

  @override
  Future<List<ContactModel>> syncContacts({
    required List<String> phoneNumbers,
  }) async {
    try {
      // Convert phone numbers to objects with phone and name
      final contactsData = phoneNumbers
          .map(
            (phone) => {
              'phone': phone,
              'name':
                  phone, // Using phone as name since we don't have names for sync
            },
          )
          .toList();

      AppLogger.logRequest('POST', ApiConstants.syncContacts, {
        'contacts': contactsData,
      });
      final response = await apiServices.postRequest(
        endPoint: ApiConstants.syncContacts,
        data: {'contacts': contactsData},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List contacts = response.data['data']['contacts'];
        AppLogger.logResponse(
          response.statusCode!,
          ApiConstants.syncContacts,
          'Synced ${contacts.length} contacts',
        );
        return contacts.map((json) => ContactModel.fromJson(json)).toList();
      } else {
        AppLogger.error('Failed to sync contacts', response.statusMessage);
        throw Exception('Failed to sync contacts: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to sync contacts', e, stackTrace);
      throw Exception('Failed to sync contacts: ${e.toString()}');
    }
  }

  @override
  Future<ContactModel?> verifyPhoneNumber(String phone) async {
    try {
      AppLogger.logRequest('POST', ApiConstants.syncContacts, {
        'contacts': [phone],
      });
      final response = await apiServices.postRequest(
        endPoint: ApiConstants.syncContacts,
        data: {
          'contacts': [
            {
              'phone': phone,
              'name': phone, // Using phone as name placeholder
            },
          ],
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List contacts = response.data['data']['contacts'];
        if (contacts.isNotEmpty) {
          AppLogger.info('Phone verified: $phone');
          return ContactModel.fromJson(contacts.first);
        }
        AppLogger.warning('Phone not found: $phone');
        return null; // Phone number not found
      } else {
        AppLogger.error('Failed to verify phone', response.statusMessage);
        throw Exception('Failed to verify phone: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to verify phone', e, stackTrace);
      throw Exception('Failed to verify phone: ${e.toString()}');
    }
  }
}
