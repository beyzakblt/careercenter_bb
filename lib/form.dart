import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart'; // Omni DateTime Picker paketini içe aktar
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore'u içe aktar
import 'package:flutter_proje/component/primary_button.dart'; // Kendi PrimaryButton widget'ınızı kullanıyorsanız

class FormPage extends StatefulWidget {
  final Function(
      String companyName,
      String jobTitle,
      String jobDetails,
      String benefits,
      String interviewDate,
      String interviewTime,
      String interviewLocation)? onSave;

  const FormPage({super.key, this.onSave});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDetailsController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _interviewDateController =
      TextEditingController();
  final TextEditingController _interviewTimeController =
      TextEditingController();
  final TextEditingController _interviewLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 162, 219),
        foregroundColor: Colors.white,
        title: const Text('Yeni İş İlanı Formu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 55, 112, 177).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFormField(
                    controller: _companyNameController,
                    labelText: 'Firma Adı',
                    validatorMessage: 'Firma adı boş olamaz',
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextFormField(
                    controller: _jobTitleController,
                    labelText: 'İş Unvanı',
                    validatorMessage: 'İş unvanı boş olamaz',
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextFormField(
                    controller: _jobDetailsController,
                    labelText: 'İlan Detayları',
                    validatorMessage: 'İlan detayları boş olamaz',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextFormField(
                    controller: _benefitsController,
                    labelText: 'Yan Haklar',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildTextFormField(
                        controller: _interviewDateController,
                        labelText: 'Mülakat Tarihi',
                        keyboardType: TextInputType.datetime,
                        enabled: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: _buildTextFormField(
                        controller: _interviewTimeController,
                        labelText: 'Mülakat Saati',
                        keyboardType: TextInputType.datetime,
                        enabled: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextFormField(
                    controller: _interviewLocationController,
                    labelText: 'Mülakat Yeri',
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: PrimaryButton(
                      text: 'Kaydet',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _saveToFirestore(); // Veriyi Firestore'a kaydet
                          Navigator.pop(context);
                        }
                      },
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? validatorMessage,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 12, 73, 117),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      style: const TextStyle(
        color: Color.fromARGB(255, 1, 26, 44),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage ?? 'Bu alan boş olamaz';
        }
        return null;
      },
      enabled: enabled,
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showOmniDateTimePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        is24HourMode: true,
        type: OmniDateTimePickerType.date);

    if (pickedDate != null) {
      setState(() {
        _interviewDateController.text =
            '${pickedDate.toLocal()}'.split(' ')[0]; // Tarih
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final DateTime? pickedTime = await showOmniDateTimePicker(
        context: context,
        initialDate: DateTime.now(),
        is24HourMode: true,
        type: OmniDateTimePickerType.time);

    if (pickedTime != null) {
      setState(() {
        _interviewTimeController.text =
            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}'; // Saat
      });
    }
  }

  void _saveToFirestore() {
    final firestore = FirebaseFirestore.instance;
    firestore.collection('ilanlar').add({
      'companyName': _companyNameController.text,
      'jobTitle': _jobTitleController.text,
      'jobDetails': _jobDetailsController.text,
      'benefits': _benefitsController.text,
      'interviewDate': _interviewDateController.text,
      'interviewTime': _interviewTimeController.text,
      'interviewLocation': _interviewLocationController.text,
    }).then((value) {
      print('İlan başarıyla kaydedildi.');
    }).catchError((error) {
      print('İlan kaydedilirken bir hata oluştu: $error');
    });
  }
}
