import 'package:flutter/material.dart';
import 'materi_tab.dart';
import 'tugas_kuis_tab.dart';
import 'create_class_screen.dart';
import 'create_tugas_screen.dart';
import 'create_kuis_screen.dart';

class KelasSayaScreen extends StatefulWidget {
  const KelasSayaScreen({super.key});

  @override
  KelasSayaScreenState createState() => KelasSayaScreenState();
}

class KelasSayaScreenState extends State<KelasSayaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Increased height for better text fit
        title: const Text(
          'Kelas Saya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade300],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            // Materi tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateClassScreen()),
            );
          } else if (_tabController.index == 1) {
            // Tugas dan Kuis tab
            final outerContext = context;
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.assignment, color: Colors.blue),
                        title: const Text('Buat Tugas'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            outerContext,
                            MaterialPageRoute(builder: (context) => const CreateTugasScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.quiz, color: Colors.blue),
                        title: const Text('Buat Kuis'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            outerContext,
                            MaterialPageRoute(builder: (context) => CreateKuisScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        child: Container(
          width: 56,
          height: 56,
          child: const Icon(Icons.add, color: Colors.white),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 6,
      ),
    );
  }
}