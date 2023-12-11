import 'dart:convert';
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riviu_buku/authentication/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:riviu_buku/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';

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
              primarySwatch: Colors.blue,
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
        var res = await http.post(Uri.parse('http://127.0.0.1:8000/auth/login-flutter/'), body: jsonEncode({
            'username': username,
            'password': password,
        }));
        final responseData = jsonDecode(res.body);
        final  userData = responseData['user'];
        User user = User.fromMap(userData);
        ref.read(userProvider.notifier).setUser(user);
        return user;
    }

    @override
    Widget build(BuildContext context) {
      //  final request = context.watch<CookieRequest>();
        return Scaffold(
            appBar: AppBar(
                title: const Text('Login'),
            ),
            body: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                                labelText: 'Username',
                            ),
                        ),
                        const SizedBox(height: 12.0),
                        TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                            ),
                            obscureText: true,
                        ),
                        
                        const SizedBox(height: 24.0),
                        ElevatedButton(
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
                                            SnackBar(content: Text("Mantap Selamat datang, ${user.name}.")));
                                }
                                else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            title: const Text('Login Gagal'),
                                            content:
                                                Text('username atau password salah'),
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
                    ],
                ),
            ),
        );
    }
}

