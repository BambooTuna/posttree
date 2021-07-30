import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> signUp(ServiceId serviceId, String userId);
  Future<User> verifyUser(ServiceId serviceId);
  Future<void> deleteUser(ServiceId serviceId);
  Future<void> signOut();

  Future<User> findUserById(String userId);
}

class AccountRepositoryImpl implements AccountRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final AuthenticationProvider authenticationProvider;
  AccountRepositoryImpl({required this.authenticationProvider});

  Stream<Event> get authState => authenticationProvider.authState
      .map((event) => event != null ? EventSuccess() : EventFailed());

  @override
  Future<User> verifyUser(ServiceId serviceId) async {
    // final idToken = await authenticationProvider.getIdToken();
    final currentUser = await authenticationProvider.currentUser();
    final user = User(DateTime.now(),
        userId: currentUser!.uid,
        userName: currentUser.displayName ?? "ぽんちゃん",
        userIconImage: currentUser.photoURL ??
            "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg");
    final userDoc =
        await firestore.collection("users").doc(currentUser.uid).get();
    if (!userDoc.exists) {
      await userDoc.reference.set(user.toMap());
    }
    return user;
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
  Future<void> signUp(ServiceId serviceId, String userId) {
    // TODO: create user by serviceId and userId
    throw UnimplementedError();
  }

  @override
  Future<User> findUserById(String userId) async {
    final userDoc =
        await firestore.collection("users").doc(userId).get();
    var document = userDoc.data() as Map<String, dynamic>;
    return newUser(document);
  }
}
