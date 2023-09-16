import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'dart:async';
import 'package:network_info_plus/network_info_plus.dart';

void main() {
  DartPingIOS.register();
  Future.delayed(const Duration(seconds: 5));
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<dynamic> discoveredDevices = [];
  String localIp = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  var _ = await getIPAddress();
                  setState(() {
                    localIp = _!;
                  });
                },
                child: const Text('Fetch Data'),
              ),
              const SizedBox(height: 20.0),
              Text(localIp),
              ElevatedButton(
                onPressed: () {
                  setState(() async {
                    discoveredDevices = (await getLocalDevicesIp());
                    print(discoveredDevices);
                  });
                },
                child: const Text('Get other device'),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(title: Text(discoveredDevices[index]));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> getIPAddress() async {
  return await NetworkInfo().getWifiIP();
}

Future<List> getLocalDevicesIp() async {
  String? wifiIP = await NetworkInfo().getWifiIP();
  String subnet = ipToCSubnet(wifiIP!);
  final List<Host> hosts = await LanScanner().quickIcmpScanAsync(subnet);
  return hosts;
}
