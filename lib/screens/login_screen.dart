import 'package:flutter/material.dart';
import 'package:my_project/models/user.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/register_screen.dart';
import 'package:my_project/services/connectivity_service.dart';
import 'package:my_project/storage/shared_prefs_storage.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SharedPrefsStorage _storage = SharedPrefsStorage();
  final ConnectivityService _connectivityService = ConnectivityService();

  String? errorMessage;

  Future<void> _tryLogin() async {
    final isConnected = await _connectivityService.checkConnection();
    if (!isConnected) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No Internet connection'),
            duration: Duration(seconds: 3),
        ),

      );
      return;
    }

    _login();
  }

  void _login() async {
    if (!mounted) return;

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Email and password cannot be empty.');
      return;
    }

    final User? savedUser = await _storage.loadUser();

    if (savedUser == null) {
      setState(() => errorMessage = 'No registered user found.');
      return;
    }

    if (email != savedUser.email || password != savedUser.password) {
      setState(() => errorMessage = 'Invalid email or password.');
      return;
    }

    setState(() => errorMessage = null);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(errorMessage!,
                    style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tryLogin,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Widget>
                    (builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("Don't have an account yet? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
