import 'dart:typed_data';
import '../models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String userId);
  Future<void> updateProfile(String userId, Map<String, dynamic> data);
  Future<String> uploadAvatar(String userId, Uint8List bytes, String extension);
}
