import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quotesapp/ui/common/theme.dart';
import 'package:quotesapp/ui/pages/splash_screen.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme(context),
      home: SplashScreen(),
    );
  }
}
