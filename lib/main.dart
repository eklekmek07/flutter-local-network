import 'package:flutter/material.dart';
import 'dart:async';
import 'package:network_info_plus/network_info_plus.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<String> discoveredDevices = [];
  String textData = "";

  Future<void> getIPAddress() async {
    String? data = await NetworkInfo().getWifiIP();
    if (data != null) {
      setState(() {
        textData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  getIPAddress();
                  print(textData);
                },
                child: const Text('Fetch Data'),
              ),
              const SizedBox(height: 20.0),
              Text(textData),
            ],
          ),
        ),
      ),
    );
  }
}
