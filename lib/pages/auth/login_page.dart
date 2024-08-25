import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/login_result_interface.dart';
import 'package:kasir_mobile/main.dart';
import 'package:kasir_mobile/provider/auth_provider.dart';
import 'package:kasir_mobile/themes/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final _formKey = GlobalKey<FormState>();
  bool _paswordVisibility = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context, String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      ApiResponse<LoginResult> response = await Auth.login(email, password);
      if (response != null) {
        if (response.status == false) {
          const snackBar = SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Username atau Password salah"),
            backgroundColor: Colors.red,
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("UserEmail", response.data!.user.email);
          pref.setString("name", response.data!.user.name);
          pref.setString('AccessToken', response.data!.user.token);
          if (context.mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MyApp()));
          }
        }
      }
    } catch (e, stacktrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("terjadi kesalahan")));
      }
      debugPrint('$e $stacktrace');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
              ),
              Row(
                children: [
                  const Text("Belum memiliki akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Buat sekarang",
                      style: TextStyle(color: Color(0xff076A68)),
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? const Center( child:  CircularProgressIndicator(
                      color: AppColors.primary,
                    ),)
                  : Container(
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
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _login(context, emailController.text,
                                      passwordController.text);
                                }
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40, top: 10, bottom: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Ubah nilai ini sesuai kebutuhan Anda
                                  )),
                              child: const Text(
                                'Login',
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
    );
  }
}
