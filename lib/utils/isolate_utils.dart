import 'dart:isolate';
import 'dart:typed_data';

import 'classifier.dart';

class IsolateData {
  int interpreterAddress;
  List<String> labels;
  Uint8List imageBytes;
  SendPort responsePort;

  IsolateData({
    required this.interpreterAddress,
    required this.labels,
    required this.imageBytes,
    required this.responsePort,
  });
}

class IsolateUtils {
  static const String debugName = "InferenceIsolate";

  late Isolate _isolate;
  final ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: debugName,
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      Classifier classifier = Classifier(
        isolateData.interpreterAddress,
        isolateData.labels,
      );
      final result = classifier.classify(isolateData.imageBytes);
      isolateData.responsePort.send(result);
    }
  }

  void dispose() {
    _isolate.kill();
  }
}
