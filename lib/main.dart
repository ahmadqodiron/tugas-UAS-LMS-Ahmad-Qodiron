import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => User(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@university.edu',
        programStudi: 'Teknik Informatika',
        fakultas: 'Fakultas Teknik',
        country: 'Indonesia',
        description: 'Mahasiswa semester 5 yang tertarik dengan pengembangan aplikasi mobile.',
        firstAccess: DateTime(2023, 9, 1),
        lastAccess: DateTime.now(),
      ),
      child: MaterialApp(
        title: 'LMS App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
