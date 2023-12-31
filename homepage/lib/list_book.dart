// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riviu_buku/models/book.dart';
import 'package:review/reviewpage.dart';
import 'package:riviu_buku/left_drawer.dart';

import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';

class Homepage extends StatefulWidget {
    final User user;
    const Homepage({Key? key, required this.user}) : super(key: key);

    @override
    _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<Homepage> {
Future<List<Book>> fetchBook() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        // 'http://127.0.0.1:8000/json/'
        // TODO: 
        'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/json/'
        );
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    // print("fetch gitu 3");
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // print("fetch gitu 2");

    // melakukan konversi data json menjadi object Product
    List<Book> list_book = [];
    //TODO: Comment line dibawah (hanya nampilin 1 buku)

    //TODO: Uncomment line dibawah buat nampilin semua data buku (berat 100>)
    // var i = 100;
    for (var d in data) {
        if (d != null) {
            list_book.add(Book.fromJson(d));
        }
    }
    return list_book;
}

@override
Widget build(BuildContext context) {
  User user = widget.user;
    return Scaffold(
        appBar: AppBar(
            title: Text('Daftar Buku',
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
        drawer: LeftDrawer(user: user),
        body: FutureBuilder(
            future: fetchBook(),
            builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                } else {
                    if (!snapshot.hasData) {
                    return const Column(
                        children: [
                        Text(
                            "Tidak ada data buku.",
                            style:
                                TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        ],
                    );
                } else {
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of items in each row
                          crossAxisSpacing: 16.0, // Spacing between items horizontally
                          mainAxisSpacing: 16.0, // Spacing between items vertically
                        ),
                        itemCount: snapshot.data!.length,
                        // itemCount: 5,
                        itemBuilder: (_, index) => GestureDetector(
                                onTap: () {
                                  // Navigate to the detail item page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context){
                                        return ReviewPage(
                                          book: snapshot.data![index], user: user,
                                        );
                                      }
                                    ),
                                  );
                                },
                              
                                child: Card(
                                  //margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  //padding: const EdgeInsets.all(20.0),
                                  elevation: 5,
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /*
                                  SizedBox(height: 20),
                                  Image.network(
                                    snapshot.data![index].fields?.coverImg ?? "",
                                    height: 200,
                                    width: 150,
                                  ),
                                  Text(
                                    "${snapshot.data![index].fields.title}",
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  */
                                  Expanded(
                                    child: Image.network(
                                      snapshot.data![index].fields?.coverImg ?? "",
                                      //fit: BoxFit.cover,
                                    ),
                                  ),
                                  /*
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot.data![index].fields?.coverImg ?? "",
                                        ),
                                        //fit: BoxFit.cover
                                      )
                                    ),
                                  ),
                                  */
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${snapshot.data![index].fields.title}",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                ),
                            )));
                    }
              }
            }));
    }
}