import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/style/colors.dart';
import 'package:posttree/style/text_style.dart';
import 'package:posttree/ui/home.dart';
import 'package:posttree/ui/login.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/utils/authentication_provider.dart';
import 'package:posttree/view_model/authenticate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configLoading();
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
        title: "posttree",
        theme: CustomThemeData.light,
        initialRoute: "/home",
        routes: <String, WidgetBuilder>{
          "/home": (BuildContext context) => Home(),
          "/login": (BuildContext context) => Login(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/profile') {
            final args = settings.arguments as UserPageArguments;
            return MaterialPageRoute(
              builder: (context) => UserPage(userId: UserId(id: args.userId)),
            );
          }
          return null;
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}

void configLoading() {
  // https://github.com/jogboms/flutter_spinkit#-showcase
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 128.0
    ..radius = 24.0
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
