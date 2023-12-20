// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:profile/screens/profilepage.dart';
import 'package:riviu_buku/authentication/menu.dart';
import 'package:homepage/list_book.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:mybooks/mybooks.dart';
import 'package:album/albumspage.dart';

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
                color: Color.fromRGBO(255,238,221,1.000),
              ),
              child: Column(
                children: [
                  Text(
                    'Riviu Buku',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text("Explore Riviu Buku",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
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
          ListTile(
            leading: const Icon(Icons.person_pin_rounded),
            title: const Text('Buku Saya'),
            onTap: () {
                // Route menu ke halaman produk
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyBookPage(user: user)),
                );
              },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
                // Route menu ke halaman produk
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: user)),
                );
              },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Album'),
            onTap: () {
                // Route menu ke halaman produk
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlbumsPage(user: user)),
                );
              },
          ),
        ],
      ),
    );
  }
}