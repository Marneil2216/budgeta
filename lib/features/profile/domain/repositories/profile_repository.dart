import '../models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String userId);
  Future<void> updateProfile(String userId, Map<String, dynamic> data);
}
