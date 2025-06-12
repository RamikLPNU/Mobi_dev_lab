import 'dart:async';
import 'dart:developer' as developer;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final _client = MqttServerClient('test.mosquitto.org', '');
  final _topic = 'sleep_tracker/status';

  final StreamController<String> _messageController =
  StreamController<String>.broadcast();
  Stream<String> get messages => _messageController.stream;

  Future<void> connect() async {
    _client.port = 1883;
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().
    millisecondsSinceEpoch}')
        .startClean();

    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } catch (e) {
      _client.disconnect();
    }

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString
        (recMess.payload.message);

      _messageController.add(message);
    });
  }

  void subscribe() {
    _client.subscribe(_topic, MqttQos.atLeastOnce);
  }

  void _onDisconnected() {
    developer.log('Disconnected');
  }

  void disconnect() {
    _client.disconnect();
  }
}
