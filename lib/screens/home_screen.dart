import 'package:cto_game/data/open_ai.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  String story = 'during a zombie outbreak. I am trying to escape from the zombies and get out of the city on a road bike, with the ultimate goal of getting to Alcatraz Island';   
  String location = 'San Francisco';
  String name = 'Jeff';
  var items = [    
    'during a zombie outbreak. I am trying to escape from the zombies and get out of the city on a road bike, with the ultimate goal of getting to Alcatraz Island',
    'during a care bear convention. I am trying to do yoga with the care bears and spread love',
    'on the open seas swimming from Blackbeard the dreaded pirate and his bloodthirsty crew',
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: location,
              onSaved: (String? value){location=value!;},
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter a location',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
                isExpanded: true,
                value: story,
                icon: const Icon(Icons.keyboard_arrow_down),    
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    story = newValue!;
                  }); 
                },
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  _formKey.currentState!.save();
                  List messages = [];
                  String initialMessage = '''I would like you to play an interactive fiction game with me. You will tell a story, where I am the main character. At each decision point, youll stop and ask me what I do next. Please begin your prompt to me with “Decision time, $name". My answer will influence your next response. The story is set in $location. $story. My name is $name.''';
                  OpenAi openAi = OpenAi();
                  messages.add({
                    'role': 'user',
                    'type': 'text',
                    'content': initialMessage
                    });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Setting up game')),
                  );
                  openAi.getMessages(messages).then((value) {
                    messages.add({
                      'role': 'system',
                      'type': 'text',
                      'content': value
                    });
                    print(messages);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(messages: messages,),
                      ));
                  });
                }
              },
              child: const Text('Start Game'),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

