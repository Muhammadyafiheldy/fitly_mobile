import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController; // Tambahkan controller untuk email
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
    final authController = Provider.of<AuthController>(context, listen: false);
    _nameController = TextEditingController(text: authController.userName);
    _emailController = TextEditingController(text: authController.userEmail); // Inisialisasi email
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose(); // Dispose email controller
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImageFile = File(image.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim(); // Ambil email baru

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong.')));
      return;
    }
    // Tambahkan validasi dasar untuk email jika diperlukan
    if (newEmail.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email tidak valid.')));
      return;
    }


    try {
      final success = await authController.updateProfile(
        newName,
        newEmail: newEmail, // Kirim email baru
        newProfilePicture: _pickedImageFile,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!')),
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memperbarui profil: ${authController.errorMessage ?? 'Unknown error'}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: const Text('Edit Profil'),
            backgroundColor: const Color(0xFFA4DD00),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA4DD00), Color(0xFF6BCB77)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _pickedImageFile != null
                              ? FileImage(_pickedImageFile!) as ImageProvider
                              : (auth.user?.fullProfilePictureUrl != null &&
                                      auth.user!.fullProfilePictureUrl!.isNotEmpty
                                  ? NetworkImage(auth.user!.fullProfilePictureUrl!) as ImageProvider // Gunakan NetworkImage
                                  : const AssetImage('assets/img/profil.jpg') as ImageProvider),
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Error loading profile image: $exception');
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Color(0xFF6BCB77),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  auth.userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      _buildProfileInputField(
                        label: 'Nama Pengguna',
                        icon: Icons.person_outline,
                        controller: _nameController,
                        enabled: true,
                      ),
                      const SizedBox(height: 20),
                      _buildProfileInputField(
                        label: 'Email',
                        icon: Icons.email_outlined,
                        controller: _emailController, // Gunakan email controller
                        enabled: false, // Email tidak bisa diubah
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>((
                        Set<MaterialState> states,
                      ) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white.withOpacity(0.2);
                        }
                        return null;
                      }),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA4DD00), Color(0xFF6BCB77)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child:
                            auth.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'SIMPAN',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool enabled = true,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF8B7355)),
            hintText: 'Masukkan $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
          ),
          style: TextStyle(
            color: enabled ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}