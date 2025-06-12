import 'package:flutter/material.dart';
import 'package:my_project/models/user.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/storage/shared_prefs_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SharedPrefsStorage _storage = SharedPrefsStorage();
  User? _user;

  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _storage.loadUser();
    setState(() {
      _user = user;
      _nameController.text = user?.name ?? '';
    });
  }

  Future<void> _logout() async {
    await _storage.clearUser();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<Widget>(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  Future<void> _updateName() async {
    if (_user == null) return;

    final updatedUser = User(
      email: _user!.email,
      password: _user!.password,
      name: _nameController.text.trim(),
    );

    await _storage.saveUser(updatedUser);
    setState(() {
      _user = updatedUser;
      _isEditing = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            if (_isEditing)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter new name',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Center(
                child: Text(
                  _user!.name,
                  style: const TextStyle(fontSize: 24,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Center(
            child: Text(
              _user!.email,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            ),
            const SizedBox(height: 24),
            if (_isEditing)
              ElevatedButton(
                onPressed: _updateName,
                child: const Text('Save Name'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  setState(() => _isEditing = true);
                },
                child: const Text('Edit Profile'),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
