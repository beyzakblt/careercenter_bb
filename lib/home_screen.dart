import 'dart:ui'; // BackdropFilter için gerekli
import 'package:flutter/material.dart';
import 'package:flutter_proje/component/primary_button.dart';
import 'package:flutter_proje/job_ads.dart';
import 'package:flutter_proje/userhomepage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _photoSizeAnimation;
  late Animation<double> _photoMarginTopAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _photoSizeAnimation = Tween<double>(
      begin: 1.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _photoMarginTopAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double photoSizeFactor = constraints.maxWidth < 600 ? 0.7 : 0.5;
          double buttonSpacing = constraints.maxHeight < 700 ? 8 : 16;

          return Stack(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: _photoMarginTopAnimation.value),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            _photoSizeAnimation.value *
                            photoSizeFactor,
                        height: MediaQuery.of(context).size.height *
                            _photoSizeAnimation.value *
                            photoSizeFactor,
                        child: Image.asset(
                          'assets/1.jpeg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.3,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _buttonAnimation,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PrimaryButton(
                          text: 'Üye Girişi',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserHomePage()),
                            );
                          },
                        ),
                        SizedBox(height: buttonSpacing),
                        PrimaryButton(
                          text: 'İşveren Girişi',
                          onPressed: () {
                            return _showLoginPopup();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showLoginPopup() {
    final TextEditingController idController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54, // Arka planın karartılması
      pageBuilder: (context, animation1, animation2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), // Blur efekti
          child: AlertDialog(
            backgroundColor: Colors.white, // AlertDialog'un arka planı beyaz
            title: const Text(
              'Admin Girişi',
              style: TextStyle(
                  color: Color.fromARGB(
                      255, 12, 73, 117)), // Yazılar arka plan rengiyle aynı
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 12, 73, 117)), // ID yazısı
                  decoration: InputDecoration(
                    labelText: 'ID',
                    labelStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 12, 73, 117)), // Placeholder yazısı
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 12, 73, 117)), // Kenarlık
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 12, 73, 117)), // Odaklanıldığında kenarlık
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  style: TextStyle(
                      color: Color.fromARGB(255, 12, 73, 117)), // Şifre yazısı
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    labelStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 12, 73, 117)), // Placeholder yazısı
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 12, 73, 117)), // Kenarlık
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 12, 73, 117)), // Odaklanıldığında kenarlık
                    ),
                  ),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  PrimaryButton(
                    backgroundColor: const Color.fromARGB(255, 221, 85, 85),
                    width: 120,
                    height: 48,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'İptal',
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  PrimaryButton(
                    width: 120,
                    height: 48,
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
                    text: 'Giriş',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
