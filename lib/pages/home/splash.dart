import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasir_mobile/interface/check_auth_interface.dart';
import 'package:kasir_mobile/provider/auth_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Connectivity connectivity = Connectivity();
  bool isOffline = true;
  bool isChecking = true;
  late StreamSubscription<ConnectivityResult> connectionSubscription;

  @override
  void initState() {
    super.initState();
    connectionSubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
    checkConnectivity();
  }

  @override
  void dispose() {
    connectionSubscription.cancel();
    super.dispose();
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      isOffline = result == ConnectivityResult.none;
      isChecking = false;
    });

    if (!isOffline) {
      _navigateToHome();
    } else {
      showOfflineSnackbar();
    }
  }

  Future<void> checkConnectivity() async {
    try {
      final result = await connectivity.checkConnectivity();
      await updateConnectionStatus(result);
    } on PlatformException catch (e) {
      setState(() {
        isChecking = false;
      });
      showErrorSnackbar('Couldn\'t check connectivity status: $e');
    }
  }

  void showOfflineSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection. Please check your network.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<CheckAuthResponse> checkAuth() async {
    try {
      var auth = await Auth.authenticated();
      return auth;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    try {
      CheckAuthResponse auth = await checkAuth();
      if (auth.status == false && auth.message == 'uauthenticated') {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      showErrorSnackbar('Authentication error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff076A68),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon_head.png',
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 20),
              if (isChecking || !isOffline)
                const CircularProgressIndicator(color: Colors.white)
              else
                const Text(
                  'No internet connection',
                  style: TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
