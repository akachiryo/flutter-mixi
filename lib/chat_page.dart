import './post_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatPage extends StatefulWidget {
  // title を受け取ってるね👀
  const ChatPage({super.key, required this.title});

  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String _text = '';

  Future<void> openPostPage() async {
    // pop 時に渡ってきた値は await して取得！
    final v = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PostPage(),
        fullscreenDialog: true,
      ),
    );
    // 受け取ったテキストを chatgpt に投げる！
    if (v != null) {
      await postChat(v);
    }
  }

Future<void> postChat(String text) async {
    final token = dotenv.env['MY_TOKEN']; // dotenvの使用方法を修正

    var url = Uri.https("api.openai.com", "v1/chat/completions");
    
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": text}
          ]
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> answer = json.decode(utf8.decode(response.bodyBytes));
        
        if (answer['choices'] != null && answer['choices'].isNotEmpty) {
          setState(() {
            _text = answer['choices'][0]["message"]["content"] ?? '';
          });
        }
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Error posting chat: $e");
    }
}


  @override
  Widget build(BuildContext context) {
    // Scaffold は土台みたいな感じ（白紙みたいな）
    return Scaffold(
      // AppBar は上のヘッダー
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      // Center で真ん中寄せ
      body: Center(
        child: Text(
          _text,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      // 右下のプラスボタン（Floating Action Button と言います）
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await openPostPage();
        },
        tooltip: 'post',
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
