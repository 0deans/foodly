import 'dart:isolate';

import 'classifier.dart';

class IsolateData {
  int interpreterAddress;
  List<String> labels;
  String imageFilePath;
  SendPort responsePort;

  IsolateData({
    required this.interpreterAddress,
    required this.labels,
    required this.imageFilePath,
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
      final result = classifier.classify(isolateData.imageFilePath);
      isolateData.responsePort.send(result);
    }
  }

  void dispose() {
    _isolate.kill();
  }
}
