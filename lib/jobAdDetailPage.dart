import 'package:flutter/material.dart';

class JobAdDetailPage extends StatelessWidget {
  final Map<String, String> jobAd;

  const JobAdDetailPage({super.key, required this.jobAd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 162, 219),
        foregroundColor: Colors.white,
        title: const Text('İş İlanı Detayı'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildLogo(jobAd['companyLogo']),
            const SizedBox(height: 20),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(String? logoUrl) {
    return logoUrl != null && logoUrl.isNotEmpty
        ? Image.network(
            logoUrl,
            height: 150,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Resim yüklenemedi');
            },
          )
        : const Text('Firma logosu bulunamadı.');
  }
}
