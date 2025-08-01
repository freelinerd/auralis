import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<String> _sessionLogs = [];
  int _totalMinutes = 0;
  File? _profileImage;
  bool _isUploading = false;
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadMeditationStats();
  }

  Future<void> _loadMeditationStats() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList('meditation_logs') ?? [];
    int totalMinutes = 0;

    for (var log in logs) {
      try {
        final parts = log.split('-');
        final minutes = int.tryParse(parts.last.trim().split(' ').first);
        if (minutes != null) {
          totalMinutes += minutes;
        }
      } catch (_) {
        continue;
      }
    }

    setState(() {
      _sessionLogs = logs.reversed.toList();
      _totalMinutes = totalMinutes;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permiso denegado para acceder a la galería.'),
        ),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      File file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child(
        'user_profile_photos/${user.uid}.jpg',
      );

      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      await user.updatePhotoURL(downloadUrl);
      await user.reload();

      setState(() {
        _profileImage = file;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil actualizada')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al subir imagen: $e')));
    }
  }

  void _changeBackground(Color color) {
    setState(() {
      _backgroundColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    ImageProvider imageProvider;
    if (_profileImage != null) {
      imageProvider = FileImage(_profileImage!);
    } else if (user?.photoURL != null) {
      imageProvider = NetworkImage(user!.photoURL!);
    } else {
      imageProvider = const AssetImage('assets/avatar.png');
    }

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Opciones de fondo',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.white),
              title: const Text('Fondo Blanco'),
              onTap: () {
                Navigator.pop(context);
                _changeBackground(Colors.white);
              },
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.blue),
              title: const Text('Fondo Azul'),
              onTap: () {
                Navigator.pop(context);
                _changeBackground(Colors.blue.shade100);
              },
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.green),
              title: const Text('Fondo Verde'),
              onTap: () {
                Navigator.pop(context);
                _changeBackground(Colors.green.shade100);
              },
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(color: _backgroundColor),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadMeditationStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: imageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(Icons.edit, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_isUploading)
                      const CircularProgressIndicator()
                    else
                      Column(
                        children: [
                          Text(
                            user?.displayName ?? 'Nombre no disponible',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            user?.email ?? 'Email no disponible',
                            style: const TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statTile(
                              Icons.timer,
                              'Total tiempo',
                              '$_totalMinutes min',
                            ),
                            _statTile(
                              Icons.self_improvement,
                              'Sesiones',
                              '${_sessionLogs.length}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Historial de sesiones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _sessionLogs.isEmpty
                        ? const Text(
                            'No hay sesiones registradas.',
                            style: TextStyle(color: Colors.black45),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _sessionLogs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white.withOpacity(0.1),
                                child: ListTile(
                                  title: Text(
                                    _sessionLogs[index],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  leading: const Icon(
                                    Icons.history,
                                    color: Colors.black54,
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
