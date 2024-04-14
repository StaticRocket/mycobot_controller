import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'console.dart';
import 'axis_slider.dart';
import 'button_mappings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8765'));
  final _logList = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: Console(
            channel: _channel,
            logList: _logList,
            sendMessage: _sendMessage,
            appendLog: _appendLog),
      ),
      Expanded(
          child: Row(children: [
        AxisSliderCard(sendMessage: _sendMessage),
        ButtonCard(sendMessage: _sendMessage)
      ])),
    ]));
  }

  void _sendMessage(String message) {
    _appendLog('> ${message}');
    _channel.sink.add(message);
  }

  void _appendLog(String entry) {
    _logList.insert(0, entry);
    while (_logList.length > 50) _logList.removeAt(0);
  }
}
