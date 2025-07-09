import 'dart:convert';

import 'package:chat_bot_app/model/chat.bot.model.dart';
import 'package:http/http.dart' as http;

class AppConfig {
  // Pour définir au moment du build : flutter run --dart-define=USE_LOCAL_API=true
  static const bool useLocalApi = bool.fromEnvironment(
    'USE_LOCAL_API',
    defaultValue: false,
  );

  static String get baseUrl {
    if (useLocalApi) {
      return "10.0.2.2:11434"; // Pour l'émulateur Android accédant au localhost du PC
      // Si vous voulez aussi tester une app web locale sur le même PC :
      // if (kIsWeb) return "localhost:11434"; else return "10.0.2.2:11434";
    } else {
      //return "api.votre-domaine.com"; // Votre API de production
      return "127.0.0.1:11434";
    }
  }

  static String get scheme {
    if (useLocalApi) {
      return "http";
    } else {
      return "http"; // Production devrait être HTTPS
    }
  }
}

class ChaBotRepository {
  Future<Message> askLargeLanguageModel(String question) async {
    //uri desktop

    final scheme = AppConfig.scheme;
    final baseUrl = AppConfig.baseUrl;
    late Uri uri;

    //var uri = Uri.http("10.0.2.2:11434", "api/chat");
    if (scheme == "https") {
      uri = Uri.https(baseUrl, "api/chat");
    } else {
      uri = Uri.http(baseUrl, "api/chat");
    }

    Map<String, String> headers = {"Content-Type": "application/json"};
    //llama 3.2
    var prompt = {
      "model": "llama3.2", //any models pulled from Ollama can be replaced here
      "messages": [
        {"role": "user", "content": question},
      ],
      "stream": false,
    };
    try {
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: json.encode(prompt),
      );
      if (response.statusCode == 200) {
        print("****************RESPONSE*************");
        print(response.body);
        Map<String, dynamic> llmResponse = json.decode(response.body);
        String responseContent = llmResponse["message"]["content"];
        return Message(message: responseContent, type: "assistant");
      } else {
        return throw ("Error ${response.statusCode}");
      }
    } catch (err) {
      return throw ("Error ${err.toString()}");
    }
  }
}

/*
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
  });
}

 */
