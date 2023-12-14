import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riviu_buku/models/user.dart';
import 'package:profile/screens/profilepage.dart';
import 'dart:convert';

class EditProfileFormPage extends StatefulWidget {
  // You can pass any necessary parameters here
  final User user;

  EditProfileFormPage({required this.user});

  @override
  _EditProfileFormPageState createState() => _EditProfileFormPageState();
}

class _EditProfileFormPageState extends State<EditProfileFormPage> {}