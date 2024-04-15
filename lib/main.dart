import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'console.dart';
import 'axis_slider.dart';
import 'button_mappings.dart';
import 'diagram.dart';
import 'demo_poses.dart' as DemoPoses;

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
  bool _isDemoMode = false;
  final _axisValues = {
    'X': 0.0,
    'Y': 0.0,
    'Z': 0.0,
    'A': 0.0,
    'B': 0.0,
    'C': 0.0
  };

  void _setAxis(String axis, double value, bool immediate) {
    _axisValues[axis] = value;
    if (immediate) {
      _sendMessage('G1 ${axis}${value.toStringAsFixed(0)}');
    }
  }

  double _getAxis(String axis) {
    double? value = _axisValues[axis];
    if (value is double) return value;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: Row(children: [
          Expanded(child: DiagramCard()),
          Expanded(
            child: Console(
                channel: _channel,
                logList: _logList,
                sendMessage: _sendMessage,
                appendLog: _appendLog),
          )
        ]),
      ),
      Expanded(
          child: Row(children: [
        AxisSliderCard(
          getAxis: _getAxis,
          setAxis: _setAxis,
        ),
        ButtonCard(
            sendMessage: _sendMessage,
            toggleDemo: _toggleDemo,
            demoBool: _isDemoMode),
      ])),
    ]));
  }

  void _sendMessage(String message) {
    _appendLog('> ${message}');
    _channel.sink.add(message);
  }

  void _appendLog(String entry) {
    setState(() {
      _logList.insert(0, entry);
    });
  }

  Future<void> _toggleDemo() async {
    setState(() {
      _isDemoMode = !_isDemoMode;
    });
    await _demoMode();
  }

  Future<void> _demoMode() async {
    var index = 0;
    while (_isDemoMode) {
      Map<String, double> pose = DemoPoses.poses[index];
      await _smoothStep(_axisValues, pose);
      await Future.delayed(const Duration(seconds: 3), () => "3");
      index += 1;
      if (index >= DemoPoses.poses.length) index = 0;
    }
  }

  Future<void> _smoothStep(start, target) async {
    while (!DemoPoses.isAtTarget(start, target)) {
      setState(() {
        start.forEach((startKey, startValue) {
          startValue = startValue.round();
          var targetValue = target[startKey];
          if (targetValue != null) {
            var deviation = startValue.round() - targetValue;
            if (deviation > 0) {
              start[startKey] -= 1;
            } else if (deviation < 0) {
              start[startKey] += 1;
            }
          }
        });
      });
      await Future.delayed(const Duration(milliseconds: 10), () => "1");
    }
  }
}
