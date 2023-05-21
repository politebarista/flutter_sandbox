import 'dart:convert';
import 'dart:isolate';

void isolateJsonDecoder(SendPort screenSendPort) {
  print('testing func');
  // handshake
  final receivePort = ReceivePort()..listen((message) async {
    print('decoding started');
    final stopwatch = Stopwatch()..start();
    jsonDecode(message);
    stopwatch.stop();
    print('decoding taked ${stopwatch.elapsedMilliseconds}');
  });
  screenSendPort.send(receivePort.sendPort);
}
