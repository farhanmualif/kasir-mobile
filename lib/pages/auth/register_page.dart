import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/register_result_interface.dart';
import 'package:kasir_mobile/provider/auth_provider.dart';
import 'package:kasir_mobile/themes/AppColors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final _formKey = GlobalKey<FormState>();
  bool _paswordVisibility = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed. //
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context, String name, String email,
      String password, String confirmPassword, String address) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      if (passwordController.text != confirmPasswordController.text) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("password dan konformasi password tidak sesuai")));
        return;
      }
      ApiResponse<RegisterResult> response =
          await Auth.register(name, email, password, confirmPassword, address);

      if (response != null) {
        if (response.status == true) {
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, '/login').then((_) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Berhasil register. Silakan login."),
              backgroundColor: Colors.green,
            ));
          });
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(json.decode(response.message.toString())),
            backgroundColor: Colors.red,
          ));
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("terjadi kesalahan ${e.toString()}")));
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : Material(
              child: Container(
                margin: const EdgeInsets.all(40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ragister Akun",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w900),
                      ),
                      Row(
                        children: [
                          const Text("Sudah memiliki akun? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Color(0xff076A68)),
                            ),
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
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 20),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "name tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                  controller: nameController,
                                  cursorColor: const Color(0xff076A68),
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff076A68),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: Text('Name'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 20),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "email tidak boleh kosong";
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
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
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 20),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "alamat tidak boleh kosong";
                                    } else if (!value.contains('@')) {
                                      return "alamat tidak valid";
                                    }
                                    return null;
                                  },
                                  controller: addressController,
                                  cursorColor: AppColors.primary,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: Text('Address'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 20),
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
                                          _paswordVisibility =
                                              !_paswordVisibility;
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: const Text('Password'),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 20),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "konfirmasi password tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                  obscureText: _paswordVisibility,
                                  controller: confirmPasswordController,
                                  cursorColor: const Color(0xff076A68),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _paswordVisibility =
                                              !_paswordVisibility;
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: const Text('Konfirmasi Password'),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _register(
                                        context,
                                        nameController.text,
                                        emailController.text,
                                        passwordController.text,
                                        confirmPasswordController.text,
                                        addressController.text);
                                  }
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xff076A68),
                                    padding: const EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: 10,
                                        bottom: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Ubah nilai ini sesuai kebutuhan Anda
                                    )),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
