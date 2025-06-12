import 'package:flutter/material.dart';
import 'package:my_project/models/user.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/screens/register_screen.dart';
import 'package:my_project/services/connectivity_service.dart';
import 'package:my_project/storage/shared_prefs_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen(BuildContext context) async {
    final storage = SharedPrefsStorage();
    final User? user = await storage.loadUser();

    if (user != null) {
      final connectivityService = ConnectivityService();
      final isConnected = await connectivityService.checkConnection();

      if (!isConnected) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text
                ('No Internet connection. Some features may not work.'),
            ),
          );
        });
      }

      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Alarm',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Builder(
        builder: (context) => FutureBuilder<Widget>(
          future: _getInitialScreen(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data!;
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
