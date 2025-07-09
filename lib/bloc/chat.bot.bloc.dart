import 'package:bloc/bloc.dart';
import '../model/chat.bot.model.dart';
import '../repository/chat.bot.repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChatBotEvent {}

class AskLLMEvent extends ChatBotEvent {
  final String query;
  AskLLMEvent({required this.query});
}

class RetryEvent extends ChatBotEvent {}

abstract class ChatBotState {
  final List<Message> messages;
  ChatBotState({required this.messages});
}

class ChatBotPendingState extends ChatBotState {
  ChatBotPendingState({required super.messages});
}

class ChatBotSuccessState extends ChatBotState {
  ChatBotSuccessState({required super.messages});
}

class ChatBotInitialState extends ChatBotState {
  ChatBotInitialState()
    : super(
        messages: [
          Message(message: "hello", type: "user"),
          Message(message: "How can I help you ?", type: "assistant"),
        ],
      );
}

class ChatBotErrorState extends ChatBotState {
  final String errorMessage;
  ChatBotErrorState({required super.messages, required this.errorMessage});
}

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final ChaBotRepository repository = ChaBotRepository();
  late ChatBotEvent lastEvent;
  ChatBotBloc() : super(ChatBotInitialState()) {
    on<AskLLMEvent>((event, emit) async {
      print(("AskLLMEvent occured"));
      lastEvent = event;
      List<Message> currentMessages = state.messages;
      emit(ChatBotPendingState(messages: state.messages));
      currentMessages.add(Message(message: event.query, type: "user"));
      try {
        Message responseMessage = await repository.askLargeLanguageModel(
          event.query,
        );
        List<Message> messages = state.messages;
        messages.add(responseMessage);
        emit(ChatBotSuccessState(messages: state.messages));
      } catch (e) {
        emit(
          ChatBotErrorState(
            messages: state.messages,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
