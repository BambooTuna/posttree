import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:posttree/model/account.dart';

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  AuthenticationProvider({required this.firebaseAuth});

  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  Future<User?> currentUser() async {
    return firebaseAuth.currentUser;
  }

  Future<IdToken?> getIdToken() async {
    final user = await currentUser();
    final idToken = await user?.getIdToken();
    if (idToken == null) {
      return null;
    } else {
      return IdToken(id: idToken);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() {
    return firebaseAuth.signOut();
  }
}
