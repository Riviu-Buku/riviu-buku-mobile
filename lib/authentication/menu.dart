import 'package:flutter/material.dart';
import 'package:homepage/list_book.dart';
import 'package:profile/screens/profilepage.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:album/albumspage.dart';
import 'package:mybooks/mybooks.dart';
import 'package:riviu_buku/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  final User user;
  MyHomePage(this.user);

  final List<ShopItem> items = [
    ShopItem("Lihat Produk", Icons.checklist),
    ShopItem("Tambah Produk", Icons.add_shopping_cart),
    ShopItem("Buku Saya", Icons.person),
    ShopItem("Logout", Icons.logout),
    ShopItem("Albums", Icons.collections_bookmark),
  ];

  void _navigateToPage(String itemName, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text("Kamu telah menekan tombol $itemName!"),
      ));

    switch (itemName) {
      case "Lihat Produk":
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Riviu Buku',
            ),
            SizedBox(width: 16),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(user: user),
      body: SingleChildScrollView(
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
                  ProfileCard(
                    onTap: () {
                      _navigateToPage("Profile", context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopItem {
  final String name;
  final IconData icon;

  ShopItem(this.name, this.icon);
}

class ShopCard extends StatelessWidget {
  final ShopItem item;
  final VoidCallback onTap;

  const ShopCard(this.item, {Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(147, 129, 255, 1.000),
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
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(147, 129, 255, 1.000),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
