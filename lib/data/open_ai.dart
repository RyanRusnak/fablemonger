import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAi{

  Future<String> getMessages(List<dynamic> messages) async {
    const String authority = 'api.openai.com';
    const String path = 'v1/chat/completions';
    const String apiKey = 'API-KEY';
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
    Map<String, dynamic> data = json.decode(result.body);
    return data['choices'][0]['message']['content'];
  }

  Future<String> getImage(String prompt) async {
    const String authority = 'api.openai.com';
    const String path = 'v1/images/generations';
    const String apiKey = 'API-KEY';
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
