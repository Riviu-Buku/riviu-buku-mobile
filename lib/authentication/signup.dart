import 'dart:convert';
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';
import 'package:riviu_buku/components/background.dart';
import 'package:riviu_buku/authentication/login.dart';

void main() {
    runApp(const SignUpApp());
}

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          title: 'Login',
          theme: ThemeData(
              primarySwatch: Colors.indigo,
      ),
      home:  SignUpPage(),
      );
    }
}

class SignUpPage extends ConsumerStatefulWidget {
     SignUpPage({super.key});
    

    @override
    _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _passwordConfirmController = TextEditingController();

    Future<User?> signUp(String username, String password1, String password2) async {
        var res = await http.post(Uri.parse(
          // 'http://127.0.0.1:8000/auth/register-flutter/'
          'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/auth/register-flutter/'
          ), body: jsonEncode({
            'username': username,
            'password1': password1,
            'password2': password2,
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
                "REGISTER",
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

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _passwordConfirmController,
                decoration: InputDecoration(
                  labelText: "Confirm Password"
                ),
                obscureText: true,
              ),
            ),


            SizedBox(height: size.height * 0.05),

            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                    String username = _usernameController.text;
                    String password1 = _passwordController.text;
                    String password2 = _passwordConfirmController.text;
                    if(password2 != password1){
                      showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: const Text('Sign Up Gagal'),
                                content:
                                    Text('Sign Up failed, cek password anda'),
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
                    else{
                      final user = await signUp(username, password1, password2);
                      if(user != null){
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                          ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                  SnackBar(content: Text("Coba login user yang sudah di Sign Up")));
                      }
                      else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: const Text('Sign Up Gagal'),
                                  content:
                                      Text('Sign Up failed'),
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
                    }
                },
                child: const Text('Sign Up'),
            ),

            ),

            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))
                },
                child: Text(
                  "Already Have an Account? Log in",
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
 

