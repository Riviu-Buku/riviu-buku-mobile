import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:riviu_buku/left_drawer.dart';
import 'package:riviu_buku/models/user.dart';
import 'mybooks.dart';
class ShopFormPage extends StatefulWidget {
    final User user;
    const ShopFormPage({Key? key, required this.user}) : super(key: key);

    @override
    State<ShopFormPage> createState() => _ShopFormPageState(user);
}

class _ShopFormPageState extends State<ShopFormPage> {
  final User user;
  _ShopFormPageState(this.user);
  final _formKey = GlobalKey<FormState>();
    String _name = "";
    String _penulis = "";
    String _description = "";
    @override
    Widget build(BuildContext context) {
      
        return Scaffold(
  appBar: AppBar(
    title: const Center(
      child: Text(
        'Form Tambah Produk',
      ),
    ),
    backgroundColor: Color.fromARGB(255, 177, 132, 255),
    foregroundColor: Colors.white,
  ),
  // TODO: Tambahkan drawer yang sudah dibuat di sini
  drawer: LeftDrawer(user: user),

  body: Form(
    key: _formKey,
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
                _name = value!;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Judul tidak boleh kosong!";
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
    // TODO: Tambahkan variabel yang sesuai
    onChanged: (String? value) {
      setState(() {
        _penulis = value!;
      });
    },
    validator: (String? value) {
      if (value == null || value.isEmpty) {
        return "Harga tidak boleh kosong!";
      }
      if (int.tryParse(value) == null) {
        return "Harga harus berupa angka!";
      }
      return null;
    },
  ),
),
Padding(
  padding: const EdgeInsets.all(8.0),
  child: TextFormField(
    maxLines: 5,
    decoration: InputDecoration(
      hintText: "Deskripsi",
      labelText: "Deskripsi",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    onChanged: (String? value) {
      setState(() {
        // TODO: Tambahkan variabel yang sesuai
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
                MaterialStateProperty.all(Color.fromARGB(255, 177, 132, 255)),
          ),
          onPressed: () async {
    if (_formKey.currentState!.validate()) {
        // Kirim ke Django dan tunggu respons
        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
        final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/upload_buku/upload-flutter/'),
        body: jsonEncode(<String, String>{
            'movie_name': _name,
            'rating': _penulis,
            'description': _description,
            // TODO: Sesuaikan field data sesuai dengan aplikasimu
        }));
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
            content: Text("Buku baru berhasil disimpan!"),
            ));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyBookPage(user: user)),
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
            "Upload Buku",
            style: TextStyle(color: Colors.white),
          ),
        ),
  ),
),
      ]
          
        )
      ),
  ),
);
    }
}