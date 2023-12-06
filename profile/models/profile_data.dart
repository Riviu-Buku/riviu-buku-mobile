import 'package:equatable/equatable.dart';

class ProfileUser extends Equatable {
  final int id; // Use appropriate data type for ID
  final String name;
  final String avatar;
  final String email;
  final String handphone;
  final String bio;
  final String address;

  ProfileUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.handphone,
    required this.bio,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, avatar, email, handphone, bio, address];

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      email: json['email'] as String,
      handphone: json['handphone'] as String,
      bio: json['bio'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'handphone': handphone,
      'bio': bio,
      'address': address,
    };
  }
}
