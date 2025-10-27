import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whiskers_flutter_app/src/models/chat_message_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/services/supabase_service.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';
import 'package:whiskers_flutter_app/src/enum/chat_message_type.dart';

class ChatViewModel extends BaseViewModel<List<ChatMessageModel>> {
  ChatViewModel(this.ref) : super([]);

  final Ref ref;
  static const _boxName = "chat_messages";
  late Box _box;
  bool isTyping = false;

  @override
  Future<void> init({String docId = ''}) async {
    _box = await Hive.openBox(_boxName);

    // Convert stored maps into models
    final loaded = _box.values
        .map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    state = loaded;
  }

  @override
  void notifyChanges(List<ChatMessageModel> model) {
    state = model;
  }

  void setTyping(bool typing) {
    isTyping = typing;
    state = [...state];
  }

  Future<void> sendMessage(String messageText, BuildContext context) async {
    final userMessage = ChatMessageModel(
      text: messageText,
      timestamp: DateTime.now(),
      isUser: true,
      messageType: ChatMessageType.none,
    );

    await addMessage(userMessage);

    setTyping(true);

    final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
    final userData = await sharedPreferencesService.getAccessToken();


    print("userData===userData${userData}");

    try {
      final response = await SupabaseService().post(
        context,
        functionName: 'chats/completions',
        body: {"UserName": "Ahan", "UserGender": "male", "Message": "hello"},
      );

      setTyping(false);

      final botMessage = ChatMessageModel(
        text: response['message'] ?? 'No response',
        timestamp: DateTime.now(),
        isUser: false,
        messageType: ChatMessageType.none,
      );

      await addMessage(botMessage);
    } catch (e) {
      setTyping(false);
      final errorMessage = ChatMessageModel(
        text: 'Sorry, something went wrong. Please try again.',
        timestamp: DateTime.now(),
        isUser: false,
        messageType: ChatMessageType.none,
      );
      await addMessage(errorMessage);
    }
  }

  Future<void> addMessage(ChatMessageModel msg) async {
    await _box.add(msg.toJson());
    state = [...state, msg];
  }

  Future<void> clearMessages() async {
    await _box.clear();
    state = [];
  }
}

final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, List<ChatMessageModel>>((ref) {
      return ChatViewModel(ref);
    });
