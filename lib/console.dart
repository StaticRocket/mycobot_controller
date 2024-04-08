import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Console extends StatefulWidget {
  const Console(
      {super.key,
      required this.channel,
      required this.logList,
      required this.sendMessage,
      required this.appendLog});
  final WebSocketChannel channel;
  final List<String> logList;
  final Function sendMessage;
  final Function appendLog;

  @override
  State<Console> createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StreamBuilder(
          stream: widget.channel.stream,
          builder: (context, snapshot) {
            widget.appendLog(snapshot.hasData ? '${snapshot.data}' : '');
            return Expanded(
                child: Container(
                    child: ListView.builder(
              reverse: true,
              itemCount: widget.logList.length,
              itemBuilder: (BuildContext context, int index) {
                return Text('${widget.logList[index]}');
              },
            )));
          },
        ),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
            child: Container(
              child: Form(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Send a command'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IntrinsicHeight(
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
              ),
            ),
          ),
        ]),
      ]),
    )));
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.sendMessage(_controller.text);
    }
  }
}
