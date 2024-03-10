import 'package:flutter/material.dart';
import 'package:kasir_mobile/provider/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _paswordVisibility = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Create storage
  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context, String email, String password) async {
    var respons = await Auth.login(email, password);
    var res = await respons;
    if (res.status == false) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(res.data),
        backgroundColor: Colors.red,
      );

      print(res.data);
      // await storage.write(key: "token", value: res.t);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Login",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
          ),
          const Row(
            children: [
              Text("Don`t have an account?"),
              Text(
                "Create Now",
                style: TextStyle(color: Color(0xff076A68)),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "email tidak boleh kosong";
                        } else if (!value.contains('@')) {
                          return "email tidak valid";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      cursorColor: const Color(0xff076A68),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff076A68),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        label: Text('Email'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "password tidak boleh kosong";
                        }
                        return null;
                      },
                      obscureText: _paswordVisibility,
                      controller: passwordController,
                      cursorColor: const Color(0xff076A68),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _paswordVisibility = !_paswordVisibility;
                            });
                          },
                          icon: Icon(_paswordVisibility
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff076A68),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        label: const Text('Password'),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // use the email provided here
                      }

                      _login(context, emailController.text,
                          passwordController.text);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff076A68),
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Ubah nilai ini sesuai kebutuhan Anda
                        )),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
