import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_proje/component/primary_button.dart';

class EditJobAdPage extends StatefulWidget {
  final Map<String, String> jobAd;
  final void Function(String, String, String, String, String, String, String) onSave;

  EditJobAdPage({required this.jobAd, required this.onSave});

  @override
  _EditJobAdPageState createState() => _EditJobAdPageState();
}

class _EditJobAdPageState extends State<EditJobAdPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyNameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _jobDetailsController;
  late TextEditingController _benefitsController;
  late TextEditingController _interviewDateController;
  late TextEditingController _interviewTimeController;
  late TextEditingController _interviewLocationController;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.jobAd['companyName']);
    _jobTitleController = TextEditingController(text: widget.jobAd['jobTitle']);
    _jobDetailsController = TextEditingController(text: widget.jobAd['jobDetails']);
    _benefitsController = TextEditingController(text: widget.jobAd['benefits']);
    _interviewDateController = TextEditingController(text: widget.jobAd['interviewDate']);
    _interviewTimeController = TextEditingController(text: widget.jobAd['interviewTime']);
    _interviewLocationController = TextEditingController(text: widget.jobAd['interviewLocation']);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _jobTitleController.dispose();
    _jobDetailsController.dispose();
    _benefitsController.dispose();
    _interviewDateController.dispose();
    _interviewTimeController.dispose();
    _interviewLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 162, 219),
        foregroundColor: Colors.white,
        title: Text('İş İlanını Düzenle'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _jobTitleController,
                labelText: 'İş Unvanı',
                validatorMessage: 'İş unvanı boş olamaz',
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _jobDetailsController,
                labelText: 'İlan Detayları',
                validatorMessage: 'İlan detayları boş olamaz',
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _benefitsController,
                labelText: 'Yan Haklar',
                maxLines: 2,
              ),
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _interviewLocationController,
                labelText: 'Mülakat Yeri',
              ),
              SizedBox(height: 60),
              Center(
                child: PrimaryButton(
                  text: "Kaydet",
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onSave(
                        _companyNameController.text,
                        _jobTitleController.text,
                        _jobDetailsController.text,
                        _benefitsController.text,
                        _interviewDateController.text,
                        _interviewTimeController.text,
                        _interviewLocationController.text,
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
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
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 12, 73, 117),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      style: TextStyle(
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

  void _selectDate(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      onConfirm: (date) {
        setState(() {
          _interviewDateController.text = '${date.toLocal().toLocal()}'.split(' ')[0];
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.tr, // Türkçe dil seçeneği
    );
  }

  void _selectTime(BuildContext context) {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        setState(() {
          _interviewTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.tr, // Türkçe dil seçeneği
    );
  }
}