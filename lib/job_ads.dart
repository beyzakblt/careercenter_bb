import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editJob.dart';
import 'jobAdDetailPage.dart';
import 'form.dart'; // FormPage widget'ını import edin

class JobAdsPage extends StatefulWidget {
  const JobAdsPage({super.key});

  @override
  _JobAdsPageState createState() => _JobAdsPageState();
}

class _JobAdsPageState extends State<JobAdsPage> {
  late Stream<List<Map<String, String>>> _jobAdsStream;

  @override
  void initState() {
    super.initState();
    _jobAdsStream = _fetchJobAds();
  }

  Stream<List<Map<String, String>>> _fetchJobAds() {
    return FirebaseFirestore.instance
        .collection('ilanlar')
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

  void _addJobAd(
      String companyName,
      String jobTitle,
      String jobDetails,
      String benefits,
      String interviewDate,
      String interviewTime,
      String interviewLocation) {
    FirebaseFirestore.instance.collection('ilanlar').add({
      'companyName': companyName,
      'jobTitle': jobTitle,
      'jobDetails': jobDetails,
      'benefits': benefits,
      'interviewDate': interviewDate,
      'interviewTime': interviewTime,
      'interviewLocation': interviewLocation,
    });
  }

  void _editJobAd(String docId, Map<String, String> updatedData) {
    FirebaseFirestore.instance
        .collection('ilanlar')
        .doc(docId)
        .update(updatedData);
  }

  void _showDeleteConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Silme Onayı'),
          content:
              const Text('Bu iş ilanını silmek istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                _deleteJobAd(docId);
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _deleteJobAd(String docId) {
    FirebaseFirestore.instance.collection('ilanlar').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 162, 219),
        foregroundColor: Colors.white,
        title: const Text('İş İlanları'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: _jobAdsStream,
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
                final docId = jobAd['id']; // Firestore doc ID

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
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: const Icon(Icons.work),
                      title: Text(jobAd['jobTitle'] ?? 'N/A'),
                      subtitle: Text(jobAd['jobDetails'] ?? 'N/A'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (docId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditJobAdPage(
                                      jobAd: jobAd,
                                      onSave: (companyName,
                                          jobTitle,
                                          jobDetails,
                                          benefits,
                                          interviewDate,
                                          interviewTime,
                                          interviewLocation) {
                                        _editJobAd(docId, {
                                          'companyName': companyName,
                                          'jobTitle': jobTitle,
                                          'jobDetails': jobDetails,
                                          'benefits': benefits,
                                          'interviewDate': interviewDate,
                                          'interviewTime': interviewTime,
                                          'interviewLocation':
                                              interviewLocation,
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                          ),
                          IconButton(
                            onPressed: () {
                              if (docId != null) {
                                _showDeleteConfirmationDialog(docId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('İş ilanı ID’si mevcut değil!')),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
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
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormPage(
                    onSave: _addJobAd,
                  ),
                ),
              );
            },
            backgroundColor: const Color.fromARGB(255, 32, 162, 219),
            foregroundColor: Colors.white,
            tooltip: 'Yeni İş İlanı',
            child: const Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
