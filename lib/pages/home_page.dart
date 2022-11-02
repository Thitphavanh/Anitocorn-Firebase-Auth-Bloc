import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Home'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/bloc_logo_full.png',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              SizedBox(height: 20.0),
              Text(
                'Bloc is an awesome\nstate management library\nfor flutter',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
