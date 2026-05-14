import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../storage/token_storage.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  bool _obscureText = true;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.login(
        usernameController.text,
        passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        final token = result['data']['token'];
        final userName = result['data']['user']['name'];

        await TokenStorage.saveToken(token);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(
                token: token,
                userName: userName,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Login gagal'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan koneksi atau server'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0EAFC),
              Color(0xFFCFDEF3),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masuk menggunakan akun mahasiswa',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: 'NIM',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'NIM',
                      filled: true,
                      fillColor: Colors.grey[50],
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: isLoading ? null : login,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E56C1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}