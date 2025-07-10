import 'package:fitly_v1/service/api_service.dart'; // Import ini untuk _baseUrl

class User {
  final int id;
  final String name;
  final String email;
  final String? token; // Token hanya ada saat login/register
  final String? profilePicturePath; // Ganti dari profilePictureUrl ke Path

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.profilePicturePath, // Sesuaikan properti
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] ?? 'No Name', // Default value lebih baik
      email: json['email'] ?? 'No Email', // Default value lebih baik
      token: json['token'] as String?,
      profilePicturePath: json['foto'] as String?, // Mapping dari 'foto'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'foto': profilePicturePath, // Simpan path saja
    };
  }

  // Getter untuk URL gambar lengkap
  String get fullProfilePictureUrl {
    if (profilePicturePath != null && profilePicturePath!.isNotEmpty) {
   
      return profilePicturePath!; // Backend sudah mengirim URL lengkap
    }
    // Return URL gambar default jika tidak ada
    return 'https://via.placeholder.com/150'; // Ganti dengan URL gambar default Anda jika ada
  }

  // Metode untuk membuat salinan dengan perubahan (diperbarui)
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? profilePicturePath,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
    );
  }
}