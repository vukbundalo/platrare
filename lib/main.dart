import 'package:flutter/material.dart';
import 'package:platrare/screens/accounts/accounts_screen.dart';
import 'package:platrare/screens/plan/plan_screen.dart';
import 'package:platrare/screens/track/track_screen.dart';
import 'package:platrare/screens/review/review_screen.dart';

void main() => runApp(PlatrareApp());

class PlatrareApp extends StatelessWidget {
  const PlatrareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Platrare',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _screens = [
    AccountsScreen(),
    PlanScreen(),
    TrackScreen(),
    ReviewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Track'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Review',
          ),
        ],
      ),
    );
  }
}