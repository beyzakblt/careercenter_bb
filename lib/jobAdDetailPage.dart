import 'package:flutter/material.dart';

class JobAdDetailPage extends StatefulWidget {
  final Map<String, String> jobAd;

  const JobAdDetailPage({super.key, required this.jobAd});

  @override
  State<JobAdDetailPage> createState() => _JobAdDetailPageState();
}

class _JobAdDetailPageState extends State<JobAdDetailPage> {
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
            _buildLogo(widget.jobAd['companyLogo']),
            const SizedBox(height: 10),
            _buildCompanyNameAndTitle(
                widget.jobAd['companyName'], widget.jobAd['jobTitle']),
            const SizedBox(height: 20),
            _buildDetailsAndBenefitsRow(
                widget.jobAd['jobDetails'], widget.jobAd['benefits']),
            const SizedBox(height: 10),
            _buildInterviewDetails(widget.jobAd['interviewLocation'],
                widget.jobAd['interviewDate'], widget.jobAd['interviewTime']),
            const SizedBox(height: 20),
            _buildBottomLogo(), // Alt logo ekleniyor
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(String? logoUrl) {
    return logoUrl != null && logoUrl.isNotEmpty
        ? Image.network(
            logoUrl,
            height: 140,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Resim yüklenemedi');
            },
          )
        : const Text('Firma logosu bulunamadı.');
  }

  Widget _buildCompanyNameAndTitle(String? companyName, String? jobTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            companyName ?? 'Firma adı mevcut değil',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            jobTitle ?? 'İş unvanı mevcut değil',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsAndBenefitsRow(String? jobDetails, String? benefits) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'İlan Detayları:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  height: 100, // Belirli bir yükseklik
                  child: SingleChildScrollView(
                    child: Text(
                      jobDetails ?? 'Detaylar mevcut değil',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Yan Haklar:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  height: 100, // Belirli bir yükseklik
                  child: SingleChildScrollView(
                    child: Text(
                      benefits ?? 'Yan haklar mevcut değil',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewDetails(String? location, String? date, String? time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/logo.jpeg', // Logo dosyasının yolu
            height: 140,
            width: 140,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Resim yüklenemedi');
            },
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Konum: ${location ?? 'Belirtilmemiş'}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold, // Koyu
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tarih: ${date ?? 'Belirtilmemiş'}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold, // Koyu
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Saat: ${time ?? 'Belirtilmemiş'}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold, // Koyu
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomLogo() {
    return Center(
      child: Image.asset(
        'assets/bottom_logo.jpg', // Alt logo dosyasının yolu
        height: 120,
        width: 500, // Yükseklik isteğe bağlı
        fit: BoxFit.contain,
      ),
    );
  }
}
