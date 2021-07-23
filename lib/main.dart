import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/style/colors.dart';
import 'package:posttree/style/text_style.dart';
import 'package:posttree/ui/home.dart';
import 'package:posttree/ui/login.dart';
import 'package:posttree/utils/authentication_provider.dart';
import 'package:posttree/view_model/authenticate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AccountRepository>(
            create: (_) => AccountRepositoryImpl(
                authenticationProvider: AuthenticationProvider(
                    firebaseAuth: FirebaseAuth.instance))),
        ChangeNotifierProvider<AuthenticateViewModel>(
            create: (context) => AuthenticateViewModel(
                accountRepository:
                    Provider.of<AccountRepository>(context, listen: false))),
      ],
      child: MaterialApp(
          title: 'Flutter example',
          theme: CustomThemeData.light,
          initialRoute: "/home",
          routes: <String, WidgetBuilder>{
            "/home": (BuildContext context) => Home(),
            "/login": (BuildContext context) => Login(),
          }),
    );
  }
}
