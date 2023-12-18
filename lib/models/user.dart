class User {
  int id;
  String username;
  String name;
  String avatar;
  String email;
  String handphone;
  String bio;
  String address;

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

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      email: json['email'] ?? '',
      handphone: json['handphone'] ?? '',
      bio: json['bio'] ?? '',
      address: json['address'] ?? '',
    );

    Map<String, dynamic> toJson() => {
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