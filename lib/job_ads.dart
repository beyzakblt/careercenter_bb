import 'package:flutter/material.dart';
import 'editJob.dart';
import 'jobAdDetailPage.dart';
import 'form.dart'; // FormPage widget'ını import edin

class JobAdsPage extends StatefulWidget {
  final DateTime filterDate; // Filtre tarihi

  JobAdsPage({required this.filterDate});

  @override
  _JobAdsPageState createState() => _JobAdsPageState();
}

class _JobAdsPageState extends State<JobAdsPage> {
  // Bu listeyi dinamik veri ile değiştirebilirsiniz
  final List<Map<String, String>> _jobAds = [];

  void _addJobAd(String companyName, String jobTitle, String jobDetails, String benefits, String interviewDate, String interviewTime, String interviewLocation) {
    setState(() {
      _jobAds.add({
        'companyName': companyName,
        'jobTitle': jobTitle,
        'jobDetails': jobDetails,
        'benefits': benefits,
        'interviewDate': interviewDate,
        'interviewTime': interviewTime,
        'interviewLocation': interviewLocation,
      });
    });
  }

  void _editJobAd(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditJobAdPage(
          jobAd: _jobAds[index],
          onSave: (companyName, jobTitle, jobDetails, benefits, interviewDate, interviewTime, interviewLocation) {
            setState(() {
              _jobAds[index] = {
                'companyName': companyName,
                'jobTitle': jobTitle,
                'jobDetails': jobDetails,
                'benefits': benefits,
                'interviewDate': interviewDate,
                'interviewTime': interviewTime,
                'interviewLocation': interviewLocation,
              };
            });
          },
        ),
      ),
    );
  }

  void _deleteJobAd(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Silme Onayı'),
          content: Text('Bu iş ilanını silmek istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _jobAds.removeAt(index);
                });
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtered job ads based on selected date
    final filteredJobAds = _jobAds.where((jobAd) => jobAd['interviewDate'] == widget.filterDate.toIso8601String().split('T').first).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 162, 219),
        foregroundColor: Colors.white,
        title: Text('İş İlanları'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredJobAds.length,
          itemBuilder: (context, index) {
            final jobAd = filteredJobAds[index];
            return ListTile(
              leading: Icon(Icons.work),
              title: Text(jobAd['jobTitle'] ?? 'N/A'),
              subtitle: Text(jobAd['jobDetails'] ?? 'N/A'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      _editJobAd(index);
                    },
                    icon: Icon(Icons.edit),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () {
                      _deleteJobAd(index);
                    },
                    icon: Icon(Icons.delete),
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
            );
          },
        ),
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
            child: Icon(Icons.add),
            backgroundColor: const Color.fromARGB(255, 32, 162, 219),
            foregroundColor: Colors.white,
            tooltip: 'Yeni İş İlanı',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
