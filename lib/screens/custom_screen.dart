import 'package:anitocorn_firebase_auth_bloc/pages/pages.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  static const String routeName = '/custom-screen';
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    HomePage(),
    Text('Hi'),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        unselectedItemColor: Colors.black38,
        selectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'SEARCH',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
