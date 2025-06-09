import 'package:flutter/material.dart';
import 'package:my_project/models/user.dart';
import 'package:my_project/services/auth_service.dart';
import 'package:my_project/storage/shared_prefs_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(SharedPrefsStorage());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidName(String name) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);
  bool isValidEmail(String email) => email.contains('@') && email.contains('.');
  bool isValidPassword(String password) => password.length >= 6;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _authService.registerUser(user);

      if (context.mounted) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ім\'я'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть ім\'я';
                  } else if (!isValidName(value)) {
                    return 'Ім\'я не повинно містити цифри';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть email';
                  } else if (!isValidEmail(value)) {
                    return 'Невірний формат email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть пароль';
                  } else if (!isValidPassword(value)) {
                    return 'Пароль повинен містити щонайменше 6 символів';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _register,
                child: const Text('Зареєструватися'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Вже маєте акаунт? Увійти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
