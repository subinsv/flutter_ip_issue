import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_client/http_client.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final nativeClient = HttpNativeClient();
  final dartIoHttpClient = HttpClient();

  final uri = Uri.parse("https://api.ipify.org");
  String flutterIp = "Click Get IP Button";
  String flutterDartIoIp = "Click Get IP Button";
  String nativeIp = "Click Get IP Button";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            try {
              flutterIp = "Loading";
              flutterDartIoIp = "Loading";
              nativeIp = "Loading";
              setState(() {});

              //http package response
              final flutterIpResponse = await http.get(uri);
              flutterIp = flutterIpResponse.body;
              setState(() {});

              //dart.io:HttpClient response
              final request = await dartIoHttpClient.getUrl(uri);
              final response = await request.close();
              flutterDartIoIp = await response.transform(utf8.decoder).join();
              setState(() {});

              //native wrapper response
              final nativeIpResposne =
                  await nativeClient.getUrl("https://api.ipify.org");
              nativeIp = nativeIpResposne.body;
              setState(() {});
            } catch (e) {
              flutterIp = e.toString();
              nativeIp = e.toString();
              flutterDartIoIp = e.toString();
              setState(() {});
            }
          },
          label: const Text("Get IP"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text(
                    "Flutter Http Client [package:http]",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    flutterIp,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Flutter Http Client [dart.io:HttpClient]",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    flutterDartIoIp,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Android/iOS Native Http Client",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    nativeIp,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
