import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/user_profile.dart';

class ProfileRemoteDatasource {
  const ProfileRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<UserProfile?> getProfile(String userId) async {
    final response = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    return UserProfile.fromMap(response);
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await _client.from('user_profiles').update(data).eq('id', userId);
  }
}
