import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/secrets.dart';

class OpenAi{

  Future<String> getMessages(List<dynamic> messages) async {
    const String authority = 'api.openai.com';
    const String path = 'v1/chat/completions';
    // Cheap-and-dirty secrets hiding until there's a back-end to store them.
    // You should create a file called lib/auth/secrets.dart and add the following:
    //   const String openaiApiKey = "API-KEY";
    // where API-KEY is your OpenAI API key.
    const String apiKey = openaiApiKey;
    Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
    };
    Map<String, dynamic> parameters = {
      'model': 'gpt-3.5-turbo',
      "temperature": 0.7,
      "messages": messages,
    };

    // remove type from messages
    for (var message in messages) {
      message.remove('type');
    }

    Uri uri = Uri.https(authority, path);
    http.Response result = await http.post(uri, headers: headers, body: json.encode(parameters));

    // If we got an error (result.body.error is not null), return the error.
    // Otherwise, return the response.
    Map<String, dynamic> data = json.decode(result.body);
    if (data['error'] != null) {
      return data['error']['message'];
    } else {
      return data['choices'][0]['message']['content'];
    }
  }

  Future<String> getImagePrompt(String story, String latestMessage) async {
    const String authority = 'api.openai.com';
    const String path = 'v1/chat/completions';
    // Cheap-and-dirty secrets hiding until there's a back-end to store them.
    // You should create a file called lib/auth/secrets.dart and add the following:
    //   const String openaiApiKey = "API-KEY";
    // where API-KEY is your OpenAI API key.
    const String apiKey = openaiApiKey;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };
    List messages = [];
    String content = '''Generate a Dall-E prompt for the following scene, limiting the prompt to 400 characters: $story
    
    $latestMessage''';
    messages.add({
      'role': 'user',
      'type': 'text',
      'content': content
    });
    Map<String, dynamic> parameters = {
      'model': 'gpt-3.5-turbo',
      "temperature": 0.7,
      "messages": messages,
    };

    // remove type from messages
    for (var message in messages) {
      message.remove('type');
    }
    Uri uri = Uri.https(authority, path);
    http.Response result = await http.post(uri, headers: headers, body: json.encode(parameters));
    Map<String, dynamic> data = json.decode(result.body);
    if (data['error'] != null) {
      return data['error']['message'];
    } else {
      return data['choices'][0]['message']['content'];
    }
  }

  Future<String> getImage(String prompt) async {
    const String authority = 'api.openai.com';
    const String path = 'v1/images/generations';
    // Cheap-and-dirty secrets hiding until there's a back-end to store them.
    // You should create a file called lib/auth/secrets.dart and add the following:
    //   const String openaiApiKey = "API-KEY";
    // where API-KEY is your OpenAI API key.
    const String apiKey = openaiApiKey;
    Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
    };
    Map<String, dynamic> parameters = {
      'prompt': prompt,
      'n': 1,
      'size': '512x512'
    };
    Uri uri = Uri.https(authority, path);
    http.Response result = await http.post(uri, headers: headers, body: json.encode(parameters));
    Map<String, dynamic> data = json.decode(result.body);
    return data['data'][0]['url'];
  }
}
