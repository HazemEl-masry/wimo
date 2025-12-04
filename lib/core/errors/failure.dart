import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;

  Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});
  factory ServerFailure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errorMessage: "Connection Timeout with ApiServer");
      case DioExceptionType.sendTimeout:
        return ServerFailure(errorMessage: "Send Timeout with ApiServer");
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errorMessage: "Receive Timeout with ApiServer");
      case DioExceptionType.badCertificate:
        return ServerFailure(errorMessage: "Bad Certificate with ApiServer");
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response!.statusCode!,
          dioException.response!.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(
          errorMessage: "Request to ApiServer was Cancelled",
        );
      case DioExceptionType.connectionError:
        return ServerFailure(errorMessage: "Connection Error with ApiServer");
      case DioExceptionType.unknown:
        if (dioException.message?.contains("SocketException") ?? false) {
          return ServerFailure(
            errorMessage:
                "No Internet Connection, Please check your connection",
          );
        }
        return ServerFailure(
          errorMessage: "Unexpected Error, Please try later",
        );
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errorMessage: response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure(
        errorMessage: "Your request not found, Please try later",
      );
    } else if (statusCode == 500) {
      return ServerFailure(
        errorMessage: "Internal Server error, Please try later",
      );
    } else {
      return ServerFailure(
        errorMessage: "Something went wrong, Please try later",
      );
    }
  }
}
