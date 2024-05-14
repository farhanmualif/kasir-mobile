import 'package:flutter/material.dart';
import 'package:kasir_mobile/interface/check_auth_interface.dart';
import 'package:kasir_mobile/pages/auth/login_page.dart';
import 'package:kasir_mobile/pages/home/home_app.dart';
import 'package:kasir_mobile/provider/auth.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  checkAuth() async {
    try {
      var auth = await Auth.checkAuth();
      return auth;
    } catch (e) {
      rethrow;
    }
  }

  _navigateToHome() async {
    await Future.delayed(
      const Duration(seconds: 3),
      () {},
    );
    CheckAuthResponse auth = await checkAuth();
    if (mounted) {
      if (auth.status == false && auth.message == 'uauthenticated') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeApp()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff076A68),
      child: Center(
        child: Image.asset(
          'assets/images/icon_head.png',
          height: 300,
          width: 300,
        ),
      ),
    );
  }
}
