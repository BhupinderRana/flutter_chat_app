import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/DataModel/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatProvider extends ChangeNotifier {
  late String _name;
  List<MessageModel> _model = [];
  late IO.Socket socket;

  List<MessageModel> get model => _model;

  String get name => _name;
  String _typing = '';

  String get typing => _typing;

  setName(String text) => _name = text;

  void createConnection() {
    socket = IO.io('http://127.0.0.1:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to websocket
    socket.connect();
    socket.onConnect((_) {
      print('connect');
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  void onReceiveMessage() {
    socket.on('receive', (data) {
      _model = [
        ..._model,
        MessageModel(name: data['name'], message: data['message'])
      ];
      notifyListeners();
    });
  }

  void sendMessage(Map<String, dynamic> map) {
    socket.emit('message', map);
  }

  void onTyping() {
    socket.emit('typing', name + ' typing...');
  }

  void onTypingIndicator() {
    socket.on('typing', (data) {
      _typing = data;
      notifyListeners();
      clearTyping();
    });
  }

  void clearTyping() {
    Future.delayed(Duration(milliseconds: 300),(){
      _typing='';
      notifyListeners();
    });
  }
}
