import 'package:flutter/material.dart';

class JobAdDetailPage extends StatelessWidget {
  final Map<String, String> jobAd;

  JobAdDetailPage({required this.jobAd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 162, 219),
        foregroundColor: Colors.white,
        title: Text('İş İlanı Detayı'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('Firma Adı:', jobAd['companyName']),
            _buildDetailRow('İş Unvanı:', jobAd['jobTitle']),
            _buildDetailRow('İlan Detayları:', jobAd['jobDetails']),
            _buildDetailRow('Yan Haklar:', jobAd['benefits']),
            _buildDetailRow('Mülakat Tarihi:', jobAd['interviewDate']),
            _buildDetailRow('Mülakat Saati:', jobAd['interviewTime']),
            _buildDetailRow('Mülakat Yeri:', jobAd['interviewLocation']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }
}
