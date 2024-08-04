import 'package:flutter/material.dart';
import 'package:kasir_mobile/provider/auth_provider.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                              _isLoading = true;
                            });
                            setState(() {
                              Auth.logout(context);
                            });
                            setState(() {
                              _isLoading = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
