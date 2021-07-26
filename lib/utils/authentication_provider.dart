import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:posttree/model/account.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationProvider = Provider(
    (ref) => AuthenticationProvider(firebaseAuth: FirebaseAuth.instance));

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  AuthenticationProvider({required this.firebaseAuth});

  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  Future<User?> currentUser() async {
    return firebaseAuth.currentUser;
  }

  Future<IdToken> getIdToken() async {
    final user = await currentUser();
    final idToken = await user?.getIdToken();
    return IdToken(id: idToken!);
  }

  Future<UserCredential> signInWithGoogle() async {
    if (UniversalPlatform.isWeb) {
      return await firebaseAuth.signInWithPopup(GoogleAuthProvider());
    }
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithTwitter() async {
    if (UniversalPlatform.isWeb) {
      return await firebaseAuth.signInWithPopup(TwitterAuthProvider());
    }
    final twitterLogin = TwitterLogin(
      apiKey: dotenv.env['TWITTER_API_KEY']!,
      apiSecretKey: dotenv.env['TWITTER_API_SECRET_KEY']!,
      redirectURI: 'twitterkit-CxLT5om5C1lfxvzQxVZPzrahB://',
    );
    final authResult = await twitterLogin.login();
    final credential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );
    return await firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() {
    return firebaseAuth.signOut();
  }
}
