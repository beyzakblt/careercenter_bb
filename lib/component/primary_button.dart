import 'package:flutter/material.dart';

// Ortak buton widget'ı
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  PrimaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Butonun genişliği
      height: 50, // Butonun yüksekliği
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 32, 162, 219), // Butonun arka plan rengi
          foregroundColor: Colors.white, // Butonun metin rengi
          padding: EdgeInsets.zero, // İç boşlukları sıfırlayın
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Butonun köşe yuvarlaklığı
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.0, // Buton metninin boyutu
            ),
          ),
        ),
      ),
    );
  }
}
