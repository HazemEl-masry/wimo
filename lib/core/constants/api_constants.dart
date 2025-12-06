/// API endpoint constants
class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl = 'http://192.168.1.5:3000';
  static const String socketUrl = 'http://192.168.1.5:3000';

  // Auth Endpoints
  static const String auth = '/auth';
  static const String sendOtp = '$auth/send-otp';
  static const String verifyOtp = '$auth/verify-otp';
  static const String refreshToken = '$auth/refresh-token';
  static const String logout = '$auth/logout';

  // User Endpoints
  static const String users = '/users';
  static const String currentUser = '$users/me';
  static const String updateProfile = '$users/profile';

  // Contacts Endpoints
  static const String contacts = '/contacts';
  static const String syncContacts = '$contacts/sync';

  // Chats Endpoints
  static const String chats = '/chats';
  static const String createChat = chats;
  static const String getChatById = '$chats/:id';

  // Messages Endpoints
  static const String messages = '/messages';
  static const String sendMessage = messages;
  // Messages are accessed as a nested resource under chats
  static String getChatMessages(String chatId) => '/chats/$chatId/messages';

  // Socket Events
  static const String socketConnect = 'connect';
  static const String socketDisconnect = 'disconnect';
  static const String socketNewMessage = 'newMessage';
  static const String socketChatUpdate = 'chatUpdate';
  static const String socketTyping = 'typing';
  static const String socketStopTyping = 'stopTyping';
  static const String socketReadMessage = 'readMessage';
}
