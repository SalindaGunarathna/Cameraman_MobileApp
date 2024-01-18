class UserModel {
  final String uid;
  final String username;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String propic;
  final String token;
  final List followers;
  final List following;

// ignore: sort_constructors_first
  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.propic,
    required this.token,
    required this.followers,
    required this.following,
  });

  // when we send data to firebase we send it in the form of map
  Map<String, dynamic> toJSON() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'propic': propic,
      'token': token,
      'followers': followers,
      'following': following,
    };
  }

// when we get data from firebase we get it in the form of map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      propic: json['propic'] as String,
      token: json['token'] as String,
      followers: json['followers'] as List,
      following: json['following'] as List,
    );
  }
}
