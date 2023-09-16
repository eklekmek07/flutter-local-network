import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:lan_scanner/lan_scanner.dart';
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

  List<dynamic> networkProperties = [];

  void addDiscoveredDevice(String deviceInfo) {
    setState(() {
      discoveredDevices.add(deviceInfo);
    });
  }

  void addLocalNetwork() async {
    var _prop = await getLocalNetwork();
    setState(() {
      networkProperties = _prop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                discoverDevices();
                addLocalNetwork();
              },
              child: const Text(
                'Click Me',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20), // Add spacing between button and text
            Text(
              discoveredDevices.length.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(networkProperties.toString()),
          ],
        ),
      ),
    ));
  }
}

Future<List> getLocalNetwork() async {
  final info = NetworkInfo();
  final wifiName = await info.getWifiName(); // "FooNetwork"
  final wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
  final wifiIP = await info.getWifiIP(); // 192.168.1.43
  final wifiIPv6 =
      await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
  final wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
  final wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
  final wifiGateway = await info.getWifiGatewayIP();
  return [
    wifiName,
    wifiBSSID,
    wifiIP,
    wifiIPv6,
    wifiSubmask,
    wifiBroadcast,
    wifiGateway
  ];
}

Future<void> discoverDevices() async {
  final udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  final message = 'Hello, any devices out there?'.codeUnits;
  print("is this even");
  udpSocket.broadcastEnabled = true;

  Timer(const Duration(seconds: 5), () {
    udpSocket.close();
  });

  udpSocket.send(message, InternetAddress('255.255.255.255'), 8888);

  udpSocket.listen((event) {
    if (event == RawSocketEvent.read) {
      final datagram = udpSocket.receive();
      if (datagram != null) {
        final message = String.fromCharCodes(datagram.data);
        print('Received message from ${datagram.address}: $message');
        // Handle the discovered device or app here.
      }
    }
  });
}
