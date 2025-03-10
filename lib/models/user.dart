class User {
  final String username;
  final String password;
  final String name;
  final String email;
  final String picture;
  final bool emailIsVerified;

  const User(
      {required this.username,
      required this.password,
      required this.name,
      required this.email,
      required this.picture,
      required this.emailIsVerified});

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'] ?? "",
        password: json['password'] ?? "",
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        picture: json['picture'] ?? "",
        emailIsVerified: json['email_verified'] as bool,
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "name": name,
        "email": email,
        "picture": picture,
        "emailIsVerified": emailIsVerified,
      };
}
