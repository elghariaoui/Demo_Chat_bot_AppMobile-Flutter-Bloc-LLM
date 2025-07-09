import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'bloc/chat.bot.bloc.dart';

class ChatBotPage extends StatelessWidget {
  ChatBotPage({super.key});
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Bot",
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          BlocBuilder<ChatBotBloc, ChatBotState>(
            builder: (context, state) {
              if (state is ChatBotPendingState) {
                return CircularProgressIndicator();
              } else if (state is ChatBotErrorState) {
                return Column(
                  children: [
                    Text(
                      "${state.errorMessage}",
                      style: TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ChatBotEvent evt = context
                            .read<ChatBotBloc>()
                            .lastEvent;
                        context.read<ChatBotBloc>().add(evt);
                      },
                      child: Text("Retry"),
                    ),
                  ],
                );
              } else if (state is ChatBotSuccessState ||
                  state is ChatBotInitialState) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: state.messages.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool isUser = state.messages[index].type == "user";
                        return Column(
                          children: [
                            ListTile(
                              trailing: isUser ? Icon(Icons.person) : null,
                              leading: isUser
                                  ? null
                                  : Icon(Icons.support_agent),
                              title: Row(
                                children: [
                                  SizedBox(width: isUser ? 100 : 0),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        state.messages[index].message,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                      ),
                                      color: isUser
                                          ? Color.fromARGB(100, 0, 255, 0)
                                          : Colors.grey,
                                      padding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(width: isUser ? 0 : 100),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      //icon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.visibility),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String question = messageController.text;
                    if (question.isNotEmpty) {
                      context.read<ChatBotBloc>().add(
                        AskLLMEvent(query: question),
                      );
                      messageController.clear();
                    }
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
