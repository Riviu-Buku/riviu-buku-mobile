import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riviu_buku/models/user.dart';
import 'package:profile/screens/profilepage.dart';
import 'package:riviu_buku/left_drawer.dart';
import 'dart:convert';

class CompleteProfileFormPage extends StatefulWidget {
  final User user;

  const CompleteProfileFormPage({super.key, required this.user});

  @override
  State<CompleteProfileFormPage> createState() =>
      _CompleteProfileFormPageState();
}

class _CompleteProfileFormPageState extends State<CompleteProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _avatar = '';
  String _bio = '';
  String _email = '';
  String _handphone = '';
  String _address = '';
  late Map<String, String> userMap;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Edit Profile'),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context);
          },
        ),
      ),
      drawer: LeftDrawer(
        user: user,
      ),
       body: Container(
        decoration: BoxDecoration (
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
        // color: Color.fromRGBO(184, 184, 255, 1.0),
        child: Center(
          child: Card(
            color: Colors.white.withOpacity(1), 
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Name",
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      // NOTE: Tambahkan variabel yang sesuai
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String>(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar1.jpeg',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      value: 'one',
                    ),
                    DropdownMenuItem<String>(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar2.jpeg',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      value: 'two',
                    ),
                    DropdownMenuItem<String>(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar3.jpeg',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      value: 'three',
                    ),
                    DropdownMenuItem<String>(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar4.jpeg',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      value: 'four',
                    ),
                    DropdownMenuItem<String>(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar5.jpeg',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      value: 'five',
                    ),
                    DropdownMenuItem<String>(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar6.jpeg',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      value: 'six',
                    ),
                    DropdownMenuItem<String>(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar7.jpeg',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      value: 'seven',
                    ),
                    DropdownMenuItem<String>(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar-default.jpeg',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      value: 'eight',
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value == 'one') {
                      setState(() {
                        _avatar = 'avatar1.jpeg';
                      });
                    } else if (value == 'two') {
                      setState(() {
                        _avatar = 'avatar2.jpeg';
                      });
                    } else if (value == 'three') {
                      setState(() {
                        _avatar = 'avatar3.jpeg';
                      });
                    } else if (value == 'four') {
                      setState(() {
                        _avatar = 'avatar4.jpeg';
                      });
                    } else if (value == 'five') {
                      setState(() {
                        _avatar = 'avatar5.jpeg';
                      });
                    } else if (value == 'six') {
                      setState(() {
                        _avatar = 'avatar6.jpeg';
                      });
                    } else if (value == 'seven') {
                      setState(() {
                        _avatar = 'avatar7.jpeg';
                      });
                    } else if (value == 'eight') {
                      setState(() {
                        _avatar = 'avatar-default.jpeg';
                      });
                    }
                  },
                  validator: (String? value) {
                    if (value == null) {
                      return "Please select your avatar";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Bio",
                    labelText: "Bio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      // NOTE: Tambahkan variabel yang sesuai
                      _bio = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Bio tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _email = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Email tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      // NOTE: Tambahkan variabel yang sesuai
                      _handphone = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nomor HP tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Address",
                    labelText: "Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      // NOTE: Tambahkan variabel yang sesuai
                      _address = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Alamat tidak boleh kosong!";
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
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(147,129,255,1.000)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await http.post(
                            Uri.parse(
                                'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/profile/complete-profile-flutter/${widget.user.id}/'),
                            body: jsonEncode(<String, String>{
                              'username': widget.user.username,
                              'name': _name,
                              'avatar': _avatar,
                              'bio': _bio,
                              'email': _email,
                              'handphone': _handphone,
                              'address': _address,
                            }));
                        final responseData = jsonDecode(response.body);
                        if (responseData['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Profilemu berhasil dilengkapi!"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ProfilePage(
                                user: widget.user,
                              );
                            }),
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
          ),
        ),
      ),
       )
    );
  }
}
