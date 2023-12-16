class User {
  final int id;
  final String username;
  final String name;
  final String avatar;
  final String email;
  final String handphone;
  final String bio;
  final String address;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.avatar,
    required this.email,
    required this.handphone,
    required this.bio,
    required this.address,
  });

  // Create a factory method to convert a Map to a User instance
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'] ?? 0,
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      email: map['email'] ?? '',
      handphone: map['handphone'] ?? '',
      bio: map['bio'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // Convert User instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'username': username,
      'name': name,
      'avatar': avatar,
      'email': email,
      'handphone': handphone,
      'bio': bio,
      'address': address,
    };
  }
}