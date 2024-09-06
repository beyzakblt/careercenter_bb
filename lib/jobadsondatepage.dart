import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_proje/jobAdDetailPage.dart';
import 'package:intl/intl.dart'; // intl paketini import et

class JobAdsOnDatePage extends StatelessWidget {
  final DateTime selectedDate;

  const JobAdsOnDatePage({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('d MMMM yyyy', 'tr_TR').format(selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 162, 219),
        foregroundColor: Colors.white,
        title: Text(formattedDate),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: _fetchJobAdsOnDate(selectedDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          final jobAds = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: jobAds.length,
              itemBuilder: (context, index) {
                final jobAd = jobAds[index];

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Position of the shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      trailing: const Icon(Icons.arrow_forward_ios),
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: jobAd['companyLogo'] != null
                          ? Image.network(
                              jobAd['companyLogo']!,
                              width: 50.0, // Genişlik
                              height: 50.0, // Yükseklik
                              fit: BoxFit
                                  .cover, // Görüntüyü kapsayacak şekilde ayarla
                            )
                          : const Icon(Icons.image),
                      title: Text(
                        jobAd['jobTitle'] ?? 'N/A',
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(jobAd['jobDetails'] ?? 'N/A',
                          style: const TextStyle(fontSize: 15)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobAdDetailPage(jobAd: jobAd),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Stream<List<Map<String, String>>> _fetchJobAdsOnDate(DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd')
        .format(date); // Format to match Firestore dates
    return FirebaseFirestore.instance
        .collection('ilanlar')
        .where('interviewDate', isEqualTo: formattedDate)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc
                      .data()
                      .map((key, value) => MapEntry(key, value.toString())),
                })
            .toList());
  }
}
