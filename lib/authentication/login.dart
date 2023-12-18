import 'dart:convert';
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riviu_buku/authentication/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';
import 'package:riviu_buku/components/background.dart';
import 'package:riviu_buku/authentication/signup.dart';

void main() {
    runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          title: 'Login',
          theme: ThemeData(
              primarySwatch: Colors.indigo,
      ),
      home:  LoginPage(),
      );
    }
}

class LoginPage extends ConsumerStatefulWidget {
     LoginPage({super.key});
    

    @override
    _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    Future<User?> loginBangIsa(String username, String password) async {
        var res = await http.post(Uri.parse(
          // 'http://127.0.0.1:8000/auth/login-flutter/'
          'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/auth/login-flutter/'
          ), body: jsonEncode({
            'username': username,
            'password': password,
        }));
        final responseData = jsonDecode(res.body);
        if(responseData["status"] == false){
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text(responseData['message'])));
        }
        final  userData = responseData['user'];
        User user = User.fromMap(userData);
        ref.read(userProvider.notifier).setUser(user);
        return user;
    }

    @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(147,129,255,1.000),
                  fontSize: 36
                ),
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username"
                ),
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password"
                ),
                obscureText: true,
              ),
            ),

            // Container(
            //   alignment: Alignment.centerRight,
            //   margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            //   child: Text(
            //     "Forgot your password?",
            //     style: TextStyle(
            //       fontSize: 12,
            //       color: Color.fromRGBO(147,129,255,1.000)
            //     ),
            //   ),
            // ),

            SizedBox(height: size.height * 0.05),

            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                            onPressed: () async {
                                String username = _usernameController.text;
                                String password = _passwordController.text;
                                final user = await loginBangIsa(username, password);
                                if(user != null){
                                  Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyHomePage(user)),
                                    );
                                    ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                            SnackBar(content: Text("Selamat datang, ${user.name}.")));
                                }
                                else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            title: const Text('Login Gagal'),
                                            content:
                                                Text('Username atau password salah'),
                                            actions: [
                                                TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                        Navigator.pop(context);
                                                    },
                                                ),
                                            ],
                                        ),
                                    );
                                }
                            },
                            child: const Text('Login'),
                        ),

            ),

            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()))
                },
                child: Text(
                  "Don't Have an Account? Sign up",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(147,129,255,1.000)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
 

