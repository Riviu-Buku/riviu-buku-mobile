import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:riviu_buku/left_drawer.dart';
import 'package:riviu_buku/models/user.dart';
import 'mybooks.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io' show File, kIsWeb;

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
    File? _image;
    String _coverImgUrl = "https://res.cloudinary.com/dcf91ipuo/image/upload/v1702620170/defaultCoverImg_pvks08.jpg";
    Uint8List webImage = Uint8List(8);
     
    Future<void> _pickImage() async {
      if(!kIsWeb){
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if(image != null){
          var selected = File(image.path);
          setState(() {
            _image = selected;
          });
        }else{
          print("No Image Selected");
        }
      }else if(kIsWeb){
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if(image != null){
          var f = await image.readAsBytes();
          setState(() {
            webImage = f;
            _image = File('a');
          });
        }else{
          print("No Image Selected");
        }
      }
  
    }


   
  
    @override
    Widget build(BuildContext context) {
      User user = widget.user;
      
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
        return "Nama penulis tidak boleh kosong!";
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
        return "Kasih deskripsi singkat lah boss!";
      }
      return null;
    },
  ),
),
Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: kIsWeb ? null : _pickImage,
    child: Text("Pick Image"),
    style: ButtonStyle(
      backgroundColor: kIsWeb
          ? MaterialStateProperty.all(Colors.grey) // Set a disabled color
          : MaterialStateProperty.all(
              Color.fromARGB(255, 177, 132, 255), // Set your active color
            ),
      foregroundColor: MaterialStateProperty.all(
        kIsWeb ? Colors.black : Colors.white, // Set text color based on platform
      ),
    ),
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
      if(!kIsWeb && _image != null){
         List<int> imageBytes = await _image!.readAsBytes();
        _coverImgUrl = base64Encode(imageBytes);

      }
        
        // Kirim ke Django dan tunggu respons
        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
        final response = await http.post(
        Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/upload/create-flutter/'),
        body: jsonEncode(<String, String>{
            'title': _name,
            'rating': _penulis,
            'description': _description,
            'coverImg': _coverImgUrl,
            'user': user.username,

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