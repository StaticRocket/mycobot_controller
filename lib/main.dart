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
  final _channel =
      WebSocketChannel.connect(Uri.parse('ws://10.200.200.1:8765'));
  final _logList = <String>[];
  bool _isDemoMode = false;
  var _isInteractive = false;
  var _subscription;
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
  initState() {
    super.initState();
    _subscription = _channel.stream.listen((message) {
      _appendLog("${message}");
    });
  }

  @override
  dispose() {
    super.dispose();

    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: _setInteractive,
        child: Scaffold(
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
                demoBool: _isDemoMode,
                appendLog: _appendLog),
          ])),
        ])));
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

  void _setInteractive(movement) {
    _isInteractive = true;
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
      if (_isInteractive) {
        await Future.delayed(const Duration(seconds: 15));
        _isInteractive = false;
      } else {
        await _smoothStep(_axisValues, pose);
        String message = "G1";
        pose.forEach((poseKey, poseValue) {
          message = "${message} ${poseKey}${poseValue.toStringAsFixed(0)}";
        });
        _sendMessage(message);
        await Future.delayed(const Duration(seconds: 3));
      }
      index += 1;
      if (index >= DemoPoses.poses.length) index = 0;
    }
  }

  Future<void> _smoothStep(start, target) async {
    while (!DemoPoses.isAtTarget(start, target) &&
        _isDemoMode &&
        !_isInteractive) {
      setState(() {
        start.forEach((startKey, startValue) {
          var targetValue = target[startKey];
          if (targetValue != null) {
            var deviation = startValue - targetValue;
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
