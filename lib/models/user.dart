class User {
  late final String? id;
  late final String? email;
  late final String? username;
  late final bool? isCompany;

  User({
    this.id,
    this.email,
    this.username,
    this.isCompany,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      isCompany: json['is_company'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'is_company': isCompany,
    };
  }
}
