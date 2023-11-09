import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/Devices.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketApp {
  static final WebSocketApp _singleton = WebSocketApp._internal();
  factory WebSocketApp() {
    return _singleton;
  }
  WebSocketApp._internal();

  IO.Socket SetConnection() {
    if (Devices().isDesktop) {
      print("Desktop");
      return IO.io(SOCKET_BASE_URL_WEB,
          IO.OptionBuilder().setTransports(['websocket', 'polling']).build());
    } else {
      print("Mobile");
      return IO.io(SOCKET_BASE_URL_APP,
          IO.OptionBuilder().setTransports(['websocket', 'polling']).build());
    }
  }
}
