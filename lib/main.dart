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

  final uri = Uri.parse("https://api.ipify.org");
  String flutterIp = "Click Get IP Button";
  String nativeIp = "Click Get IP Button";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            try {
              flutterIp = "Loading";
              nativeIp = "Loading";
              setState(() {});
              final flutterIpResponse = await http.get(uri);
              flutterIp = flutterIpResponse.body;
              setState(() {});

              final nativeIpResposne =
                  await nativeClient.getUrl("https://api.ipify.org");
              nativeIp = nativeIpResposne.body;
              setState(() {});
            } catch (e) {
              flutterIp = e.toString();
              nativeIp = e.toString();
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
                const Text("Flutter Http Client"),
                Text(flutterIp),
                const Text("Android/iOS Native Http Client"),
                Text(nativeIp),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
