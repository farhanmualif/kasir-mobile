import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/pages/auth/login_page.dart';
import 'package:kasir_mobile/pages/home/home_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _getToken() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      return pref.getString('AccessToken');
    } catch (e) {
      rethrow;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: FutureBuilder<String?>(
          future: _getToken(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            // Your code here
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasError) {
                return const LoginPage();
              } else {
                return snapshot.data != null
                    ? const HomeApp()
                    : const LoginPage();
              }
            }
          },
        ),
      ),
    );
  }
}
