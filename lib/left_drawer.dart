// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:riviu_buku/authentication/menu.dart';
// import 'package:shopping_list/screens/shoplist_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homepage/list_book.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';

class LeftDrawer extends StatelessWidget {
  final User user;
  LeftDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Column(
                children: [
                  Text(
                    'Shopping List',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text("Catat seluruh keperluan belanjamu di sini!",
                    // NOTE: Tambahkan gaya teks dengan center alignment, font ukuran 15, warna putih, dan weight biasa
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal, // This is the default weight, so you can omit it if you prefer.
                    ),
                  ),
                ],
              ),
            ),
          // NOTE: Bagian routing

          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(user),
                  ));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.add_shopping_cart),
          //   title: const Text('Tambah Produk'),
          //   // Bagian redirection ke ShopFormPage
          //   onTap: () {
          //     /*
          //     NOTE: Buatlah routing ke ShopFormPage di sini,
          //     setelah halaman ShopFormPage sudah dibuat.
          //     */
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ShopFormPage(),
          //         ));
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Daftar Buku'),
            onTap: () {
                // Route menu ke halaman produk
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(user: user)),
                );
              },
          ),
        ],
      ),
    );
  }
}