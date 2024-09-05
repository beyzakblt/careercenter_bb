import 'package:flutter/material.dart';

// Ortak buton widget'ı
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 200,
    this.height = 48,
    this.backgroundColor = const Color.fromARGB(255, 32, 162, 219),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Butonun genişliği
      height: height, // Butonun yüksekliği
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Butonun arka plan rengi
          foregroundColor: Colors.white, // Butonun metin rengi
          padding: EdgeInsets.zero, // İç boşlukları sıfırlayın
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Butonun köşe yuvarlaklığı
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16.0, // Buton metninin boyutu
            ),
          ),
        ),
      ),
    );
  }
}
