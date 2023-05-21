import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:sandbox/isolates_study/isolate_json_decoder.dart';

class IsolateStudyScreen extends StatefulWidget {
  const IsolateStudyScreen({Key? key}) : super(key: key);

  @override
  State<IsolateStudyScreen> createState() => _IsolateStudyScreenState();
}

class _IsolateStudyScreenState extends State<IsolateStudyScreen> {
  ReceivePort? screenReceivePort;
  Isolate? isolate;
  SendPort? isolateSendPort;

  @override
  void dispose() {
    isolate?.kill();
    screenReceivePort?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('isolate study screen')),
        body: Column(
          children: [
            Text('testing'),
            CircularProgressIndicator(),
            MaterialButton(
              onPressed: () {
                if (isolate == null) {
                  startIsolate();
                } else {
                  print('isolate has already been started');
                }
              },
              child: Text('run & get isolate'),
            ),
            MaterialButton(
              onPressed: () async {
                if (isolate == null) {
                  print('isolate has not been started yet');
                } else {
                  print('sending unparsed json to isolate');
                  final json = await rootBundle.loadString('lib/isolates_study/large-file.json');
                  isolateSendPort!.send(json);
                }
              },
              child: Text('send unparsed json to isolate'),
            ),
            MaterialButton(
              onPressed: () => serializeJson(),
              child: Text('serialize json without isolate'),
            ),
          ],
        ),
      ),
    );
  }

  void startIsolate() async {
    screenReceivePort = ReceivePort()
      ..listen((message) {
        if (message is SendPort) {
          print('send port from isolate has been received');
          isolateSendPort = message;
        } else {
          print('message from isolate ${message.toString()}');
        }
      });

    isolate = await Isolate.spawn(
      isolateJsonDecoder,
      screenReceivePort!.sendPort,
    );
  }

  void serializeJson() async {
    print('serialize json');
    final stopwatch = Stopwatch()..start();
    final json = await rootBundle.loadString('lib/isolates_study/large-file.json');
    jsonDecode(json);
    stopwatch.stop();
    print('decoding without isolate takes ${stopwatch.elapsedMilliseconds}');
  }
}
