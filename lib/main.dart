import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moneyt/firebase_options.dart';
import 'home_page.dart';
import 'add_source_income_page.dart';
import 'profile_page.dart';
import 'statistics_page.dart';
import 'personalization_page.dart'; 
import 'landing_page.dart';
import 'signup_page.dart';
import 'login_page.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: {
        '/': (context) => const HomePage(),
        '/add_income': (context) => AddSourceIncomePage(),
        // '/statistics': (context) => StatisticsPage(),
        '/personalization': (context) => PersonalizationPage(), 
        '/profile': (context) => ProfilePage(),
        '/landing': (context) => LandingPage(),
        '/signup' : (context) => SignUpPage(),
        '/login' : (context) => LoginPage(),
      },
    );
  }
}
