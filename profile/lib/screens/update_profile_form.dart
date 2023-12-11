import 'package:flutter/material.dart';
import 'package:flutter/riviu-buku/user_provider.dart';

class UpdateProfileForm extends StatefulWidget {
  final UserProvider userProvider;

  UpdateProfileForm({required this.userProvider});

  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.userProvider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            onSaved: (value) => widget.userProvider.name = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Avatar'),
            onSaved: (value) => widget.userProvider.avatar = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            onSaved: (value) => widget.userProvider.email = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Handphone'),
            onSaved: (value) => widget.userProvider.handphone = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Bio'),
            onSaved: (value) => widget.userProvider.bio = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Address'),
            onSaved: (value) => widget.userProvider.address = value!,
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.userProvider.formKey.currentState?.validate() ?? false) {
                widget.userProvider.formKey.currentState?.save();
                widget.userProvider.updateDetails();
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
