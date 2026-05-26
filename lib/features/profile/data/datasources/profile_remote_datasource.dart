import 'dart:typed_data';
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

  // Requires a public 'avatars' bucket in Supabase Storage.
  // SQL: ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS avatar_url TEXT;
  Future<String> uploadAvatar(
      String userId, Uint8List bytes, String extension) async {
    final path = '$userId/avatar.$extension';
    await _client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$extension',
          ),
        );
    final url = _client.storage.from('avatars').getPublicUrl(path);
    await _client
        .from('user_profiles')
        .update({'avatar_url': url}).eq('id', userId);
    return url;
  }
}
