import 'dart:developer';

import 'package:posttree/model/account.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/authentication_provider.dart';

abstract class AccountRepository {
  Future<void> signInWithGoogle();
  Future<void> signInWithTwitter();

  Future<void> signUp(ServiceId serviceId, UserId userId);
  Future<UserId?> verifyUser(ServiceId serviceId);
  Future<void> deleteUser(ServiceId serviceId);
  Future<void> signOut();
}

class AccountRepositoryImpl implements AccountRepository {
  final AuthenticationProvider authenticationProvider;
  AccountRepositoryImpl({required this.authenticationProvider});

  @override
  Future<UserId?> verifyUser(ServiceId serviceId) async {
    final idToken = await authenticationProvider.getIdToken();
    // TODO: check idToken and get
    if (idToken == null) {
      return null;
    } else {
      return UserId(id: "takeo");
    }
  }

  @override
  Future<void> deleteUser(ServiceId serviceId) async {
    await this.signOut();
    // TODO: delete user from database
    return this.signOut();
  }

  @override
  Future<void> signOut() {
    return authenticationProvider.signOut();
  }

  @override
  Future<void> signInWithGoogle() async {
    await authenticationProvider.signInWithGoogle();
  }

  @override
  Future<void> signInWithTwitter() async {
    await authenticationProvider.signInWithTwitter();
  }

  @override
  Future<void> signUp(ServiceId serviceId, UserId userId) {
    // TODO: create user by serviceId and userId
    throw UnimplementedError();
  }
}
