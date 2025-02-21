import 'package:basic_chats_app/chatapp_provider.dart';
import 'package:basic_chats_app/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCVBQH98_TA0xEw3NsnmfKUhQwzfF5L8lY",
          authDomain: "chat-app-demo-21324.firebaseapp.com",
          databaseURL:
              "https://chat-app-demo-21324-default-rtdb.firebaseio.com",
          projectId: "chat-app-demo-21324",
          storageBucket: "chat-app-demo-21324.firebasestorage.app",
          messagingSenderId: "668206893114",
          appId: "1:668206893114:web:de602dc242a26d812e0d03",
          measurementId: "G-0E9TZGNZ2D"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatappProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        // home: LoginPage(),
        home: SigninPage(),
      ),
    );
  }
}
