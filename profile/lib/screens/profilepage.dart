import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController handphoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 238, 221, 1.000),
      appBar: AppBar(
        title: Text(
          'Riviu Buku',
          style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile section
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),

                  // Username
                  TextFormField(
                    controller: usernameController,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                      labelText: 'Username:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // Handphone
                  TextFormField(
                    controller: handphoneController,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                      labelText: 'Handphone:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // Bio
                  TextFormField(
                    controller: bioController,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                      labelText: 'Bio:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // Address
                  TextFormField(
                    controller: addressController,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                      labelText: 'Address:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            // Liked Books section
            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '❤️ Liked Books ❤️',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  // Add your liked books widgets here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
