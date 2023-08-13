import 'package:flutter/material.dart';

import '../data/open_ai.dart';

class ChatScreen extends StatefulWidget {

  ChatScreen({super.key, required this.messages});

  final messages;

  @override
  State<ChatScreen> createState() => _ChatScreebState();
}

class _ChatScreebState extends State<ChatScreen> {
  List<dynamic> messages = [];
  String nextAction = '';
  var nextActionController = TextEditingController();

  @override
  void initState() {
    messages = widget.messages;
    nextAction = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('FableMonger'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                for (var message in messages)
                  Align(
                    alignment: message['role'] == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: message['role'] == 'user'
                            ? Colors.blue
                            : Colors.grey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: message['type'] != 'image' ? Text(message['content'],
                          style: const TextStyle(
                            color: Colors.white
                            ),  
                          ) : Image.network(message['content']),
                        ),
                      ),
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nextActionController,
                  onChanged: (String? value){nextAction=value!;},
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'What do you do next?',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your next action';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    OpenAi openAi = OpenAi();
                    nextActionController.clear();
                    messages.add({'role': 'user', 'type': 'text', 'content': nextAction});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating Response')),
                    );
                    if (nextAction == 'what do you see?') {
                      print('generating image');
                      print(messages[messages.length-2]['content']);
                      openAi.getImage(messages[messages.length-2]['content']).then((value) {
                        messages.add({'role': 'system', 'type': 'image', 'content': value});
                        setState(() {
                          messages = messages;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      });
                    }else{
                      openAi.getMessages(messages).then((value) {
                        messages.add({'role': 'system', 'type': 'text', 'content': value});
                        setState(() {
                          messages = messages;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              )
            ],
            ),
          ],
        ),
      ),
    );
  }
}

