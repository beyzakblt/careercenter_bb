import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_proje/component/primary_button.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatefulWidget {
  final Function(File) onImageSelected;

  const MyImagePicker({super.key, required this.onImageSelected});

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File? _image;
  final picker = ImagePicker();

  // Galeriden fotoğraf seçme
  Future<void> getImageGallery() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        widget.onImageSelected(_image!);
      });
    }
  }

  // fotoğraf ekleme dialog
  void showPhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Fotoğraf Ekle",
          ),
          content: const Text(
            "Firmanızın logosunu ekleyin",
          ),
          actions: [
            Row(
              children: [
                PrimaryButton(
                  width: 120,
                  height: 48,
                  text: "Galeriden Seç",
                  onPressed: () {
                    Navigator.pop(context);
                    getImageGallery();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                PrimaryButton(
                  backgroundColor: const Color.fromARGB(255, 221, 85, 85),
                  width: 120,
                  height: 48,
                  text: "İptal",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPhotoDialog(context),
      child: Container(
        width: 150, // Genişlik
        height: 40, // Yükseklik
        decoration: BoxDecoration(
          color: Colors.grey[300], // Arkaplan rengi
          image: _image != null
              ? DecorationImage(
                  image: FileImage(_image!), // Seçilen resmi göster
                  fit: BoxFit.contain, // Resmi container'a sığdır
                )
              : null,
          borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatma
        ),
        child: _image == null
            ? const Icon(
                Icons.add,
                size: 25,
                color: Colors.grey,
              )
            : null, // Resim yoksa '+' simgesi göster
      ),
    );
  }
}
