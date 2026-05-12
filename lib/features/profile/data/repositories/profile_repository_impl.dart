import '../../domain/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._datasource);

  final ProfileRemoteDatasource _datasource;

  @override
  Future<UserProfile?> getProfile(String userId) => _datasource.getProfile(userId);

  @override
  Future<void> updateProfile(String userId, Map<String, dynamic> data) =>
      _datasource.updateProfile(userId, data);
}
