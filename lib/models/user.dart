class User {
  final int id;
  final String name;
  final String email;
  final String? token;
  final String? profilePictureUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] as String?,
      profilePictureUrl: json['foto'] as String?, // Tetap mapping dari 'foto'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'foto': profilePictureUrl,
    };
  }

  // Metode untuk membuat salinan dengan perubahan
  User copyWith({String? profilePictureUrl}) {
    return User(
      id: this.id,
      name: this.name,
      email: this.email,
      token: this.token,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}