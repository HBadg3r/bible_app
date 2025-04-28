import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bible_app/consts.dart'; // Import your API key

Future<String> sendMessageToChatGPT(String message) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $OPENAI_API_KEY',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "model": "gpt-3.5-turbo", // Or "gpt-4" if you have access
      "messages": [
        {"role": "user", "content": message}
      ],
      "temperature": 0.7,
      "max_tokens": 200,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'];
    return content;
  } else {
    throw Exception('Failed to connect to ChatGPT: ${response.body}');
  }
}

class OpenaiChatPage extends StatefulWidget {
  const OpenaiChatPage({super.key});

  @override
  State<OpenaiChatPage> createState() => _OpenaiChatPageState();
}

class _OpenaiChatPageState extends State<OpenaiChatPage> {
  List<types.Message> _messages = [];
  final types.User _user = const types.User(id: 'user-1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT'),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(
          backgroundColor: Color(0xFF101010),
          primaryColor: Colors.greenAccent,
          secondaryColor: Color(0xFF101010),
          inputBackgroundColor: Color(0xFF101010), // Input field matching
          inputTextColor: Colors.white, // Make input text readable
          sentMessageBodyTextStyle: TextStyle(
            color: Colors.black, // Text inside green bubbles = black
          ),
          receivedMessageBodyTextStyle: TextStyle(
            color: Colors.white, // Future received messages text color
          ),
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    // 🌟 Send user message to ChatGPT
    try {
      final botResponse = await sendMessageToChatGPT(message.text);

      final botMessage = types.TextMessage(
        author: const types.User(id: 'bot'), // Different ID for GPT
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: botResponse,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}
