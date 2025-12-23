import 'package:flutter/material.dart';
import 'materi_tab.dart';
import 'tugas_kuis_tab.dart';

class KelasSayaScreen extends StatefulWidget {
  const KelasSayaScreen({super.key});

  @override
  KelasSayaScreenState createState() => KelasSayaScreenState();
}

class KelasSayaScreenState extends State<KelasSayaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedIndex = 1; // Kelas Saya is active

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigate back to Home
      Navigator.pop(context);
    } else if (index == 2) {
      // Notifikasi - placeholder
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notifikasi belum tersedia')),
      );
    }
    // Kelas Saya is current, do nothing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Increased height for better text fit
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'DESAIN ANTARMUKA & PENGALAMAN PENGGUNA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15, // Slightly smaller
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            Text(
              'D4SM-42-03',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13, // Slightly smaller
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blue[300]!],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Materi'),
            Tab(text: 'Tugas dan Kuis'),
          ],
          labelColor: Colors.blue[800],
          unselectedLabelColor: const Color.fromARGB(255, 255, 255, 255),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MateriTab(),
          TugasKuisTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Kelas Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}