import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> goToHome() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildImage() {
    return Image.asset('images/logo.png');
  }

  @override
  Widget build(BuildContext context) {
    goToHome();
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: _buildImage(),
    );
  }
}
