import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/authentication_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/utils/event.dart';

final accountRepositoryProvider = Provider((ref) => AccountRepositoryImpl(
    authenticationProvider: ref.read(authenticationProvider)));

enum AuthProvider {
  Google,
  Twitter
}

abstract class AccountRepository {
  Stream<Event> get authState;

  Future<User> signUp(AuthProvider provider);
  Future<User> signIn(AuthProvider provider);
  Future<User> currentUser();

  Future<void> deleteUser();
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
  Future<User> signUp(AuthProvider provider) async {
    switch (provider) {
      case AuthProvider.Google:
        await authenticationProvider.signInWithGoogle();
        break;
      case AuthProvider.Twitter:
        await authenticationProvider.signInWithTwitter();
        break;
      default:
        throw Error();
    }
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
  Future<User> signIn(AuthProvider provider) async {
    return await this.signUp(provider);
    // switch (provider) {
    //   case AuthProvider.Google:
    //     await authenticationProvider.signInWithGoogle();
    //     break;
    //   case AuthProvider.Twitter:
    //     await authenticationProvider.signInWithTwitter();
    //     break;
    //   default:
    //     throw Error();
    // }
    // final currentUser = await authenticationProvider.currentUser();
    // final userDoc =
    //     await firestore.collection("users").doc(currentUser!.uid).get();
    // return newUser(userDoc.data()!);
  }

  @override
  Future<User> currentUser() async {
    final currentUser = await authenticationProvider.currentUser();
    final userDoc =
        await firestore.collection("users").doc(currentUser!.uid).get();
    return newUser(userDoc.data()!);
  }

  @override
  Future<void> deleteUser() async {
    final currentUser = await authenticationProvider.currentUser();
    await firestore.collection("users").doc(currentUser!.uid).delete();
    return await this.signOut();
  }

  @override
  Future<void> signOut() {
    return authenticationProvider.signOut();
  }

  @override
  Future<User> findUserById(String userId) async {
    final userDoc =
        await firestore.collection("users").doc(userId).get();
    var document = userDoc.data() as Map<String, dynamic>;
    return newUser(document);
  }
}
