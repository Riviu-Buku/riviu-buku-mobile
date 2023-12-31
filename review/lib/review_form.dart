import 'package:flutter/material.dart';
import 'package:riviu_buku/left_drawer.dart';

import 'package:riviu_buku/authentication/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:review/reviewpage.dart';
import 'package:http/http.dart' as http;

import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';
import 'dart:convert';
// NOTE: Impor drawer yang sudah dibuat sebelumnya

class ReviewFormPage extends StatefulWidget {
    final User user;
    final Book book;
    const ReviewFormPage({super.key, required this.user, required this.book});

    @override
    State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();
    // ignore: no_leading_underscores_for_local_identifiers
    int _price = 0;
    // ignore: no_leading_underscores_for_local_identifiers
    int _stars = 1;
    // ignore: no_leading_underscores_for_local_identifiers
    String _description = "";
    
    @override
    Widget build(BuildContext context) {
        User user = widget.user;

        return Scaffold(
          appBar: AppBar(
            title: Text('Form Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Pop the navigator when the back button is pressed
              },
            ),
          ),
          // NOTE: Tambahkan drawer yang sudah dibuat di sini
        drawer: LeftDrawer(user: user,),
        body: Container(
        decoration: BoxDecoration (
            gradient: LinearGradient(
              colors: [
              Color.fromARGB(255, 191, 156, 239),
              Color.fromARGB(255, 216, 191, 247),
              Color.fromARGB(255, 255, 223, 182),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        ),
        // color: Color.fromRGBO(184, 184, 255, 1.0),
        child: Center(
          child: Card(
            color: Colors.white.withOpacity(1), 
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<int>(
                      value: _stars,
                      onChanged: (int? value) {
                        setState(() {
                          _stars = value!;
                        });
                      },
                      items: List.generate(5, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1} Star'),
                        );
                      }),
                      decoration: InputDecoration(
                        hintText: "Stars",
                        labelText: "Stars",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (int? value) {
                        if (value == null) {
                          return "Please select a star rating!";
                        }
                        return null;
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Deskripsi",
                      labelText: "Deskripsi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        // NOTE: Tambahkan variabel yang sesuai
                        _description = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Deskripsi tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color.fromRGBO(254, 231, 192, 1)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                            // Kirim ke Django dan tunggu respons
                            // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                            final response = await http.post(Uri.parse(
                              'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/book-detail/create-review-flutter/'
                              )
                            ,body: jsonEncode(<String, String>{
                                'bookId': widget.book.pk.toString(),
                                'user': widget.user.username,
                                'stars': _stars.toString(),
                                'description': _description,
                            }));
                            final responseData = jsonDecode(response.body);
                            if (responseData['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                content: Text("Produk baru berhasil disimpan!"),
                                ));
                                // Pop the current route from the stack
                                Navigator.pop(context);

                                // Push the new replacement route
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ReviewPage(
                                        book: widget.book,
                                        user: user,
                                      );
                                    },
                                  ),
                                );
                            } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content:
                                        Text("Terdapat kesalahan, silakan coba lagi."),
                                ));
                            }
                        }
                    },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        
      )
      
      ),
          ),
        ),
        )
        );
    }
}

