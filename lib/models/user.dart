class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      phone: json['user']['phone'],
      token: json['token'],
    );
  }
}
