import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'jobAdsOnDatePage.dart'; // Yeni sayfayı import edin

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Map<String, String>>> _interviewDates = {};

  @override
  void initState() {
    super.initState();
    _fetchInterviewDates();
  }

  Future<void> _fetchInterviewDates() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('ilanlar').get();

    final interviewDates = <DateTime, List<Map<String, String>>>{};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final interviewDateStr = data['interviewDate'] as String?;
      if (interviewDateStr != null) {
        final interviewDate = DateTime.parse(interviewDateStr).toLocal();
        final jobTitle = data['jobTitle'] ?? 'No Title';
        final companyName = data['companyName'] ?? 'No Company';
        final interviewTime = data['interviewTime'] ?? 'No Time';

        if (interviewDates.containsKey(interviewDate)) {
          interviewDates[interviewDate]!.add({
            'jobTitle': jobTitle,
            'companyName': companyName,
            'interviewTime': interviewTime,
          });
        } else {
          interviewDates[interviewDate] = [
            {
              'jobTitle': jobTitle,
              'companyName': companyName,
              'interviewTime': interviewTime,
            }
          ];
        }
      }
    }

    setState(() {
      _interviewDates = interviewDates;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/3.jpg',
      'assets/4.png',
      'assets/5.png',
      'assets/6.png',
      'assets/7.jpg',
      'assets/8.jpg',
      'assets/11.jpeg',
    ];

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 200.0,
              child: Image.asset(
                'assets/2.jpeg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            height: 80.0,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlayInterval: const Duration(seconds: 2),
                height: 120.0,
                viewportFraction: 0.3,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
                initialPage: 0,
              ),
              items: imgList
                  .map((item) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          child: Image.asset(
                            item,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              locale: "tr_TR",
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _navigateToJobAdsOnDatePage(selectedDay);
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              firstDay: DateTime.now(),
              lastDay: DateTime(2028),
              eventLoader: (day) {
                return _interviewDates[day] ?? [];
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return SizedBox.shrink();

                  return Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      width: 8,
                      height: 8,
                      child: Center(
                        child: Text(
                          '${events.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToJobAdsOnDatePage(DateTime selectedDay) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobAdsOnDatePage(selectedDate: selectedDay),
      ),
    );
  }
}
