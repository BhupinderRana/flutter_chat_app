import 'package:flutter/material.dart';
import 'package:flutter_chat_app/DataModel/message_model.dart';
import 'package:flutter_chat_app/Provider/chat_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ChatProvider _chatProvider;
  var _messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chatProvider = context.read<ChatProvider>();
    _chatProvider.createConnection();
    _chatProvider.onReceiveMessage();
    _chatProvider.onTypingIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_chatProvider.name),
            Consumer<ChatProvider>(builder: (_, data, __) {
              return Text(
                data.typing,
                style: TextStyle(color: Colors.grey[200], fontSize: 12),
              );
            }),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            Expanded(
              child: Selector<ChatProvider, List<MessageModel>>(
                  selector: (context, val) => val.model,
                  builder: (_, data, __) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    data[i].name,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Expanded(
                                      child: Text(' :- ${data[i].message}'))
                                ],
                              ),
                            ));
                  }),
            ),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(hintText: 'write your message..'),
                  onChanged: (val) {
                    _chatProvider.onTyping();

                  },
                )),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 40,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (!_messageController.text.trim().isEmpty) {
                        Map<String, dynamic> map = {
                          'name': _chatProvider.name,
                          'message': _messageController.text.trim()
                        };
                        _chatProvider.sendMessage(map);
                        _messageController.text = '';
                      }
                    },
                    child: Icon(Icons.send),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
