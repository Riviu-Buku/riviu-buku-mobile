// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riviu_buku/models/book.dart';
import 'package:review/reviewpage.dart';
import 'package:riviu_buku/left_drawer.dart';


class Homepage extends StatefulWidget {
    const Homepage({Key? key}) : super(key: key);

    @override
    _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<Homepage> {
Future<List<Book>> fetchBook() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://127.0.0.1:8000/json/'
        // TODO: 
        // 'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/json/'
        );
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    print("fetch gitu 3");
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print("fetch gitu 2");

    // melakukan konversi data json menjadi object Product
    List<Book> list_book = [];
    //TODO: Comment line dibawah (hanya nampilin 1 buku)
    print("fetch gitu 1");
    //print(data[0]);
    list_book.add(Book.fromJson(data[103]));
    //list_book.add(Book.fromJson(data[1]));
    //list_book.add(Book.fromJson(data[2]));
    //list_book.add(Book.fromJson(data[3]));

    print("fetch gitu");
    //TODO: Uncomment line dibawah buat nampilin semua data buku (berat 100>)
    // for (var d in data) {
    //     if (d != null) {
    //         list_book.add(Book.fromJson(d));
    //     }
    // }
    return list_book;
}

@override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Book'),
        ),
        drawer: LeftDrawer(),
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
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        //itemCount: 1,
                        itemBuilder: (_, index) => GestureDetector(
                                onTap: () {
                                  // Navigate to the detail item page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReviewPage(
                                        book: snapshot.data![index],
                                      ),
                                    ),
                                  );
                                },
                        
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                      "${snapshot.data![index].fields.title}",
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                      ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text("${snapshot.data![index].fields.author}"),
                                      const SizedBox(height: 10),
                                      Text(
                                          "${snapshot.data![index].fields.description}")
                                ],
                                ),
                            )));
                    }
              }
            }));
    }
}
