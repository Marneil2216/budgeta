import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Future<void> signIn({required String email, required String password}) =>
      _datasource.signIn(email: email, password: password);

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) =>
      _datasource.signUp(email: email, password: password, fullName: fullName);

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<void> signInWithGoogle() => _datasource.signInWithGoogle();

  @override
  Future<void> resetPassword(String email) =>
      _datasource.resetPassword(email);
}
