import 'package:flutter/material.dart';
import 'package:homepage/list_book.dart';
import 'package:profile/screens/profilepage.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:album/albumspage.dart';
import 'package:mybooks/mybooks.dart';
import 'package:riviu_buku/left_drawer.dart';
import 'package:riviu_buku/authentication/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatelessWidget {
  final User user;
  MyHomePage(this.user);

  final List<ShopItem> items = [
    ShopItem("Daftar Buku", Icons.checklist, Color.fromARGB(137, 160, 73, 214)),
    ShopItem("Buku Saya", Icons.person, Color.fromARGB(255, 201, 123, 226)),
    ShopItem("Logout", Icons.logout, Color.fromARGB(255, 224, 97, 97)),
    ShopItem("Albums", Icons.collections_bookmark, const Color.fromARGB(255, 112, 165, 208)),
    ShopItem("Profile", Icons.account_circle, Color.fromARGB(255, 255, 195, 98)),
  ];

  void _navigateToPage(String itemName, BuildContext context) {
    Future<User?> logout(User userIn) async {
        var res = await http.post(Uri.parse(
          // 'http://127.0.0.1:8000/auth/logout/'
          'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/auth/logout/'
          ), body: jsonEncode({
            'user': userIn,
        }));
        final responseData = jsonDecode(res.body);
        if(responseData["status"] == false){
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text(responseData["message"])));
          return null;
        }
        final  userData = responseData['user'];
        User user = User.fromMap(userData);
        return user;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text("Kamu telah menekan tombol $itemName!"),
      ));

    switch (itemName) {
      case "Daftar Buku":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage(user: user)),
        );
        break;
      case "Profile":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
        );
        break;
        case "Buku Saya":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyBookPage(user: user)),
        );
        break;
      // Add more cases for other items if needed
      case "Albums":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlbumsPage(user: user)),
        );
        break;

      case "Logout":
        final userout = logout(user);
          if(userout != null){
            Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
              );
              ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      SnackBar(content: Text("Berhasil log out")));
          }
          else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: const Text('Log out Gagal'),
                      content:
                          Text('Log out failed'),
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
        break;  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Riviu Buku'),
            SizedBox(width: 16),
          ],
        ),
        backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(user: user),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    'Welcome to Riviu Buku!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: <Shadow> [Shadow(
                          // offset: Offset(10.0, 10.0),
                          blurRadius: 8.0,
                          color: Color.fromARGB(255, 212, 194, 219),
                      ),]
                    ),
                  ),
                ),
                GridView.count(
                  primary: true,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: [
                    ...items.map((ShopItem item) {
                      return ShopCard(item, onTap: () {
                        _navigateToPage(item.name, context);
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShopItem {
  final String name;
  final IconData icon;
  final Color iconColor;

  ShopItem(this.name, this.icon, this.iconColor);
}

class ShopCard extends StatelessWidget {
  final ShopItem item;
  final VoidCallback onTap;

  const ShopCard(this.item, {Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
        color: Colors.white.withOpacity(0.8),
        elevation: 2, 
        shadowColor: Colors.black.withOpacity(0.3), 
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: item.iconColor,
                    size: 30.0,
                  ),
                  const Padding(padding: EdgeInsets.all(3)),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color.fromARGB(255, 107, 66, 117)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}