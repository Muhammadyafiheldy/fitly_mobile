// code profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/auth_controller.dart';
import 'package:fitly_v1/views/login.dart';
import 'package:fitly_v1/views/edit_profile.dart';
import 'package:fitly_v1/views/edit_password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Memuat data pengguna dari SharedPreferences saat halaman diinisialisasi.
    // Future.microtask digunakan untuk memastikan bahwa context tersedia
    // sebelum memanggil Provider.of.
    Future.microtask(() {
      Provider.of<AuthController>(context, listen: false).loadUserFromPrefs();
      debugPrint('ProfilePage: initState - loadUserFromPrefs called.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header section with background image and profile
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://i.pinimg.com/736x/f7/c8/76/f7c8768df03d080ffd26828bd36b70df.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                // Menggunakan Consumer untuk hanya membangun ulang bagian yang menampilkan nama dan email
                child: Consumer<AuthController>(
                  builder: (context, auth, child) {
                    debugPrint('ProfilePage: Consumer rebuild - userName: ${auth.userName}, userEmail: ${auth.userEmail}');
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Profile Image (sekarang dinamis berdasarkan user data)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: CircleAvatar(
                            radius: 46,
                            // Menggunakan NetworkImage jika ada URL, jika tidak menggunakan AssetImage default
                            backgroundImage: (auth.user?.profilePictureUrl != null && auth.user!.profilePictureUrl!.isNotEmpty)
                                ? NetworkImage(auth.user!.profilePictureUrl!) as ImageProvider<Object>
                                : const AssetImage('assets/img/profil.jpg') as ImageProvider<Object>,
                            onBackgroundImageError: (exception, stackTrace) {
                              debugPrint('Error loading profile image: $exception');
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Dynamic Name
                        Text(
                          auth.userName, // Mengambil nama dari AuthController
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Dynamic Email
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            auth.userEmail, // Mengambil email dari AuthController
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Account',
                      onTap: () {
                        // Navigasi ke halaman EditProfilePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfilePage()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        // Implementasi navigasi ke halaman Notifications
                        // Anda bisa menambahkan navigasi ke halaman Notifikasi di sini jika ada.
                        // Contoh:
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const NotificationsPage()),
                        // );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Passwords',
                      onTap: () {
                        // Navigasi ke halaman EditPasswordPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditPasswordPage()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {
                        // Dapatkan instance AuthController tanpa mendengarkan
                        final authForLogout = Provider.of<AuthController>(context, listen: false);
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Logout'),
                              content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Tutup dialog, tidak jadi logout
                                    Navigator.of(dialogContext).pop(false);
                                  },
                                  child: const Text('Tidak'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Panggil fungsi logout dari AuthController
                                    await authForLogout.logout();
                                    // Tutup dialog
                                    if (dialogContext.mounted) {
                                      Navigator.of(dialogContext).pop(true);
                                    }
                                    // Navigasi ke halaman login dan hapus semua rute sebelumnya
                                    if (context.mounted) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => const LoginPage()),
                                        (Route<dynamic> route) => false, // Hapus semua rute sebelumnya
                                      );
                                    }
                                  },
                                  child: const Text('Ya', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk membangun item menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF8B7355), // Warna ikon
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D), // Warna teks judul
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFBBBBBB), // Warna ikon panah
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}