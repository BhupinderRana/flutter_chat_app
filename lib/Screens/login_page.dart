import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Provider/chat_provider.dart';
import 'package:flutter_chat_app/Screens/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  var _nameController = TextEditingController();
  late ChatProvider chatProvider;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    chatProvider = context.read<ChatProvider>();
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          height: 250,
          width: 300,
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                  ),
                  maxLength: 10,
                  validator: (val) {
                    if (val.toString().trim().isEmpty) return 'Enter your name';
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      chatProvider.setName(_nameController.text);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  },
                  child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
