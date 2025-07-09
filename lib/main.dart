import 'package:chat_bot_app/chat.bot.page.dart';
import 'package:flutter/material.dart';

import 'home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomePage(),
        '/chat': (context) => ChatBotPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        indicatorColor: Colors.white,
      ),
      // home: HomePage(),
    );
  }
}
