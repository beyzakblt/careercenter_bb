import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:table_calendar/table_calendar.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  late final DateTime _selectedDay;
  late final DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // List of image assets
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
        title: Text('İş İlanları'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Ana fotoğrafın ekleneceği kısım
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: 200.0, // Yükseklik istediğiniz gibi ayarlanabilir
              child: Image.asset(
                'assets/2.jpeg', // Ana fotoğrafın yolu
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Carousel (Kaydırılabilir galeri) kısmı
          Container(
            height: 80.0, // Carousel'in yüksekliği
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlayInterval: Duration(seconds: 2),
                height: 120.0, // Carousel'in yüksekliği
                viewportFraction: 0.3, // Fotoğraf genişliği ayarı
                autoPlay: true, // Otomatik kaydırma
                enlargeCenterPage: true, // Merkezdeki fotoğrafı büyüt
                aspectRatio: 16 / 9, // Aspect ratio
                enableInfiniteScroll: true, // Sonsuz kaydırma
                initialPage: 0,
              ),
              items: imgList.map((item) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  child: Image.asset(
                    item,
                    fit: BoxFit.contain,
                  ),
                ),
              )).toList(),
            ),
          ),
          // Takvim kısmı
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
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
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ), firstDay: DateTime.now(), lastDay: DateTime(2028),
            ),
          ),
        ],
      ),
    );
  }
}
