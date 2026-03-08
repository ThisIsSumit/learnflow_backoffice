import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final secureStorageProvider = Provider<SecureStorageNotifier>((ref) {
  return SecureStorageNotifier(ref, const FlutterSecureStorage());
});

class SecureStorageNotifier extends StateNotifier<String?> {
  SecureStorageNotifier(this.ref, this.secureStorage) : super(null);

  Ref ref;
  FlutterSecureStorage secureStorage;

  Future<String?> getApiToken() async {
    return await secureStorage.read(key: "api_token");
  }

  Future<void> setApiToken(String? token) async {
    await secureStorage.write(key: "api_token", value: token);
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: "refresh_token");
  }

  Future<void> setRefreshToken(String? token) async {
    await secureStorage.write(key: "refresh_token", value: token);
  }

  Future<String?> getEmailPayload() async {
    return await secureStorage.read(key: "email_payload");
  }

  Future<void> setEmailPayload(String? token) async {
    await secureStorage.write(key: "email_payload", value: token);
  }

  Future<void> deleteJwt() async {
    await _deleteApiToken();
    await _deleteApiPayload();
    await _deleteRefreshToken();
  }

  Future<void> _deleteApiToken() async {
    await secureStorage.delete(key: "api_token");
  }

  Future<void> _deleteApiPayload() async {
    await secureStorage.delete(key: "email_payload");
  }

  Future<void> _deleteRefreshToken() async {
    await secureStorage.delete(key: "refresh_token");
  }
}
