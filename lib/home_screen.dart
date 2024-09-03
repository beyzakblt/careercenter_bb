import 'package:flutter/material.dart';
import 'package:flutter_proje/component/primary_button.dart';
import 'package:flutter_proje/job_ads.dart';
import 'package:flutter_proje/userhomepage.dart'; // userhomepage.dart dosyasını import edin

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
      begin: 1.0,
      end: 0.7,
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
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: _photoMarginTopAnimation.value),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        _photoSizeAnimation.value,
                    height: MediaQuery.of(context).size.height *
                        _photoSizeAnimation.value,
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
            bottom: 300,
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
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: 'İşveren Girişi',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobAdsPage(
                                // Şu anki tarihi varsayılan olarak veriyoruz
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
