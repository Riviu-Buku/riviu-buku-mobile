import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:homepage/list_book.dart';
import 'package:riviu_buku/models/user.dart';

class RecommendedBookForm extends StatefulWidget {
  final User user;

  const RecommendedBookForm({Key? key, required this.user}) : super(key: key);

  @override
  _RecommendedBookFormState createState() => _RecommendedBookFormState();
}

class _RecommendedBookFormState extends State<RecommendedBookForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  String _title = "";
  String _author = "";

    @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Berikan Rekomendasi Buku'),
      ),
      body: Form(
        key: _formKey,
        //padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Judul Buku",
              labelText: "Judul Buku",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                _title = value!;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Judul Buku tidak boleh kosong!";
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Penulis Buku",
              labelText: "Penulis Buku",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                _author = value!;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Penulis Buku tidak boleh kosong!";
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
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim ke Django dan tunggu respons
                        // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                        final response = await http.post(Uri.parse(
                          "https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/add_recommended_book_flutter/",
                          ),
                          body: jsonEncode(<String, String>{
                            'title': _title,
                            'author': _author,
                            //'user': widget.user.username,
                          })
                        );
                        final responseData = jsonDecode(response.body);
                        if (responseData['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                            content: Text("Rekomendasi baru berhasil disimpan!"),
                          ));
                          Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Homepage(
                                        user: user,
                                      );
                                    },
                                  ),
                                );
                        } else {
                          ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                            content: Text("Terdapat kesalahan, silakan coba lagi."),
                          ));
                        }
                        _formKey.currentState!.reset();
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
      ],

        ),
      ),
      ),
    );
  }
}