import 'package:chat_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthCubit authCubit;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    authCubit = getIt<AuthCubit>();
    authCubit.loadCurrentUser();
    _loadSavedImage();
  }

  /// Pick image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() => _image = file);

      final bytes = await file.readAsBytes();
      final base64Str = base64Encode(bytes);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_image', base64Str);
    }
  }

  /// Load saved image
  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Str = prefs.getString('saved_image');

    if (base64Str != null) {
      final bytes = base64Decode(base64Str);
      final file = File('${Directory.systemTemp.path}/saved_image.png');
      await file.writeAsBytes(bytes);
      setState(() => _image = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showLogoutDialog(context, () {
                  authCubit.logout();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),

        /// ✅ FIXED BODY
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 📧 User Info
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is AuthSuccess) {
                    return Row(
                      children: [
                        Text("Hello, ",style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                        const SizedBox(height: 10),
                        Text(
                          state.user.email ?? "No Email",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }

                  if (state is AuthError) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }

                  return const Text('No user logged in');
                },
              ),

              const SizedBox(height: 20),

              /// 👤 Profile Image
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  child: _image != null
                      ? ClipOval(
                    child: Image.file(
                      _image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.add_a_photo, size: 40),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

/// Logout Dialog
void _showLogoutDialog(BuildContext context, void Function()? onPressed) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}