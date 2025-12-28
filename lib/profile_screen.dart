import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'about_me_tab.dart';
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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
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
                              user.isProfileFilled ? user.fullName : 'User',
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
              // Custom Tab bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(0),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: _tabController.index == 0
                                ? LinearGradient(colors: [Colors.blue[900]!, Colors.blue[300]!])
                                : null,
                            color: _tabController.index == 0 ? null : Colors.grey[100],
                            borderRadius: BorderRadius.circular(21),
                            boxShadow: _tabController.index == 0
                                ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 4, spreadRadius: 1)]
                                : null,
                          ),
                          child: Text(
                            'About Me',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: _tabController.index == 0 ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(1),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: _tabController.index == 1
                                ? LinearGradient(colors: [Colors.blue[900]!, Colors.blue[300]!])
                                : null,
                            color: _tabController.index == 1 ? null : Colors.grey[100],
                            borderRadius: BorderRadius.circular(21),
                            boxShadow: _tabController.index == 1
                                ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 4, spreadRadius: 1)]
                                : null,
                          ),
                          child: Text(
                            'Edit Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: _tabController.index == 1 ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    AboutMeTab(),
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