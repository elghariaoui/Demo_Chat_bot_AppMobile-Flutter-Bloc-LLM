import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//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
class ChatBotPage extends StatefulWidget {
  ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List messages = [
    {"message": "hello", "type": "user"},
    {"message": "How can I help you ?", "type": "assistant"},
    {"message": "Are you good ? ", "type": "user"},
    {"message": "Yes I am good and you ?", "type": "assistant"},
  ];

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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isUser = messages[index]["type"] == "user";
                  return Column(
                    children: [
                      ListTile(
                        trailing: isUser ? Icon(Icons.person) : null,
                        leading: isUser ? null : Icon(Icons.support_agent),
                        title: Row(
                          children: [
                            SizedBox(width: isUser ? 100 : 0),
                            Expanded(
                              child: Container(
                                child: Text(
                                  messages[index]["message"],
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
                      Divider(height: 1, color: Theme.of(context).primaryColor),
                    ],
                  );
                },
              ),
            ),
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
                    String query = messageController.text;
                    //llama 3.2

                    var uri = Uri.http("10.0.2.2:11434", "api/chat");
                    Map<String, String> headers = {
                      "Content-Type": "application/json",
                    };

                    //openai
                    /*
                    var uri = Uri.https(
                      "api.openai.com",
                      "/v1/chat/completions",
                    );

                    Map<String, String> headers = {
                      "Content-Type": "application/json",

                    };*/

                    //llama 3.2
                    //"model": "gpt-3.5-turbo",
                    var prompt = {
                      "model":
                          "llama3.2", //any models pulled from Ollama can be replaced here
                      "messages": [
                        {"role": "user", "content": query},
                      ],
                      "stream": false,
                    };
                    http
                        .post(uri, headers: headers, body: json.encode(prompt))
                        .then(
                          (response) {
                            var llmResponse = json.decode(response.body);
                            print("****************RESPONSE*************");
                            //print(response.body);
                            print(llmResponse["message"]["content"]);
                            //openai
                            String responseContent =
                                //llmResponse["choices"][0]["message"]["content"];
                                llmResponse["message"]["content"];
                            //llama 3.2
                            //llmResponse["response"];
                            setState(() {
                              messages.add({
                                "message": responseContent,
                                "type": "assistant",
                              });
                              scrollController.jumpTo(
                                scrollController.position.maxScrollExtent + 500,
                              );
                            });
                          },
                          onError: (err) {
                            print("****************ERROR*************");
                            print(err);
                          },
                        );

                    messageController.clear();
                    setState(() {
                      messages.add({"message": query, "type": "user"});
                      scrollController.jumpTo(
                        scrollController.position.maxScrollExtent + 200,
                      );
                    });
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
