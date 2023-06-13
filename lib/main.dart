import 'package:chat/helper/helper_function.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Constant.apiKey,
          appId: Constant.appId,
          messagingSenderId: Constant.messagingSenderId,
          projectId: Constant.projectId),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoginStatus();
  }

  getUserLoginStatus() async {
    await HelperFunction.getUserloggedInStatus().then(
      (value) {
        if (value != null) {
          setState(() {
            _isSignedIn = value;
          });
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Constant.primaryColor,
          scaffoldBackgroundColor: Colors.white),
      home: _isSignedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
