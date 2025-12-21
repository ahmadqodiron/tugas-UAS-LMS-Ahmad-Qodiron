import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'about_me_tab.dart';
import 'kelas_tab.dart';
import 'edit_profile_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          body: Column(
            children: [
              // Header with gradient
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[900]!, Colors.blue[300]!],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      // Profile photo and name
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  user.updateProfileImage(image.path);
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: user.profileImagePath != null
                                    ? FileImage(File(user.profileImagePath!))
                                    : null,
                                child: user.profileImagePath == null
                                    ? Icon(Icons.person, size: 50, color: Colors.white)
                                    : null,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              user.fullName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'About Me'),
                    Tab(text: 'Kelas'),
                    Tab(text: 'Edit Profile'),
                  ],
                  labelColor: Colors.blue[800],
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue[800],
                  indicator: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    AboutMeTab(),
                    KelasTab(),
                    EditProfileTab(),
                  ],
                ),
              ),
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
            currentIndex: 0, // Assuming profile is accessed from home
            selectedItemColor: Colors.blue[800],
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            onTap: (index) {
              // Handle navigation if needed
            },
          ),
        );
      },
    );
  }
}