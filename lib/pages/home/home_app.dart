import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/home/home_body.dart';

import 'package:kasir_mobile/provider/auth.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0EC),
      appBar: AppBar(
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 20),
          child: const Image(
            image: AssetImage(
              "assets/images/icon_head.png",
            ),
          ),
        ),
        backgroundColor: const Color(0xff076A68),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xff076A68),
        child: Column(
          children: [
            const Spacer(),
            Expanded(
              flex: -3,
              child: Column(
                children: [
                  ListTile(
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account',
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        Auth.logout(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: const HomeBody(),
    );
  }
}
