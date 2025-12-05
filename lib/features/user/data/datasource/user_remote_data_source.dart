import 'package:dio/dio.dart';
import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({String? name, String? bio});
  Future<String> uploadAvatar({required String filePath});
  Future<void> blockUser({required String userId});
  Future<void> unblockUser({required String userId});
  Future<void> updatePrivacy({required PrivacySettings privacy});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiServices apiServices;

  UserRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await apiServices.getRequest(endPoint: 'users/profile');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to get profile: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile({String? name, String? bio}) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (bio != null) data['bio'] = bio;

      final response = await apiServices.patchRequest(
        endPoint: 'users/profile',
        data: data,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadAvatar({required String filePath}) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await apiServices.uploadFile(
        endPoint: 'users/avatar',
        formData: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data']['avatarUrl'];
      } else {
        throw Exception('Failed to upload avatar: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to upload avatar: ${e.toString()}');
    }
  }

  @override
  Future<void> blockUser({required String userId}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'users/block',
        data: {'userId': userId},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to block user: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to block user: ${e.toString()}');
    }
  }

  @override
  Future<void> unblockUser({required String userId}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'users/unblock',
        data: {'userId': userId},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to unblock user: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to unblock user: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePrivacy({required PrivacySettings privacy}) async {
    try {
      final response = await apiServices.patchRequest(
        endPoint: 'users/privacy',
        data: privacy.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update privacy: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to update privacy: ${e.toString()}');
    }
  }
}
