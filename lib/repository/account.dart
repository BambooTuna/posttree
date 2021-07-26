import 'package:flutter/cupertino.dart';
import 'package:posttree/model/account.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/authentication_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/utils/event.dart';

final accountRepositoryProvider = Provider((ref) => AccountRepositoryImpl(
    authenticationProvider: ref.read(authenticationProvider)));

abstract class AccountRepository {
  Stream<Event> get authState;

  Future<void> signInWithGoogle();
  Future<void> signInWithTwitter();

  Future<void> signUp(ServiceId serviceId, UserId userId);
  Future<User> verifyUser(ServiceId serviceId);
  Future<void> deleteUser(ServiceId serviceId);
  Future<void> signOut();
}

class AccountRepositoryImpl implements AccountRepository {
  final AuthenticationProvider authenticationProvider;
  AccountRepositoryImpl({required this.authenticationProvider});

  Stream<Event> get authState => authenticationProvider.authState
      .map((event) => event != null ? EventSuccess() : EventFailed());

  @override
  Future<User> verifyUser(ServiceId serviceId) async {
    final idToken = await authenticationProvider.getIdToken();
    // TODO: check idToken and get
    return User(
        userId: UserId(id: "takeo"),
        userName: UserName(value: "たけちゃ"),
        userIconImage: UserIconImage(
            value:
                "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg"));
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
