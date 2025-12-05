import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/models/contact_model.dart';

abstract class ContactRemoteDataSource {
  Future<List<ContactModel>> getContacts();
  Future<List<ContactModel>> syncContacts({required List<String> phoneNumbers});
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final ApiServices apiServices;

  ContactRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<List<ContactModel>> getContacts() async {
    try {
      final response = await apiServices.getRequest(endPoint: 'contacts');

      if (response.statusCode == 200) {
        final List contacts = response.data['data']['contacts'];
        return contacts.map((json) => ContactModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get contacts: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get contacts: ${e.toString()}');
    }
  }

  @override
  Future<List<ContactModel>> syncContacts({
    required List<String> phoneNumbers,
  }) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'contacts/sync',
        data: {'phoneNumbers': phoneNumbers},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List contacts = response.data['data']['contacts'];
        return contacts.map((json) => ContactModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to sync contacts: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to sync contacts: ${e.toString()}');
    }
  }
}
