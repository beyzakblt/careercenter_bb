import 'package:flutter/material.dart';
import 'package:flutter_proje/job_ads.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pop-up formu açmak için basit bir metot
    void _showLoginPopup() {
      final TextEditingController idController = TextEditingController();
      final TextEditingController passwordController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Admin Girişi'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                  ),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  // ID ve Şifre kontrolü yapıyoruz
                  if (idController.text == 'admin' &&
                      passwordController.text == 'admin') {
                    // Doğruysa JobAdsPage'e yönlendirme yapıyoruz
                    Navigator.of(context).pop(); // Pop-up kapatılıyor
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobAdsPage()),
                    );
                  } else {
                    // Yanlışsa hata mesajı gösteriyoruz
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hatalı giriş!')),
                    );
                  }
                },
                child: const Text('Giriş'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showLoginPopup,
          child: const Text('Giriş Yap'),
        ),
      ),
    );
  }
}
