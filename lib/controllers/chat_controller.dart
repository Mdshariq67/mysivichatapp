import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';
import '../models/user_model.dart';
import 'history_controller.dart';

class ChatController extends GetxController {
  final ChatUser user;
  ChatController(this.user);

  final _messages = <Message>[].obs;
  List<Message> get messages => List.unmodifiable(_messages);

  final _loading = false.obs;
  bool get loading => _loading.value;

  final HistoryController historyController = Get.find();

  @override
  void onInit() {
    super.onInit();
    // seed welcome message
    _messages.add(Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Hello ${user.name}, welcome!',
      isSender: false,
      time: DateTime.now(),
      senderInitial: user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
    ));
  }

  void sendLocalMessage(String text) async {
    if (text.trim().isEmpty) return;
    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isSender: true,
      time: DateTime.now(),
      senderInitial: 'Y', // Y = you
    );
    _messages.add(msg);
    historyController.updateOrAdd(user.id, user.name, text, DateTime.now());
    update();

    // Simulate reply by fetching from API:
    await fetchReply();
  }

  Future<void> fetchReply() async {
    try {
      _loading.value = true;
      update();
      final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=1'));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        final r = list[Random().nextInt(list.length)];
        final text = r['body']?.toString() ?? 'Okay!';
        final reply = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isSender: false,
          time: DateTime.now(),
          senderInitial: user.name.isNotEmpty ? user.name[0].toUpperCase() : 'R',
        );
        _messages.add(reply);
        historyController.updateOrAdd(user.id, user.name, text, DateTime.now());
      } else {
        _messages.add(Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'Failed to fetch reply (code ${res.statusCode})',
          isSender: false,
          time: DateTime.now(),
          senderInitial: user.name[0].toUpperCase(),
        ));
      }
    } catch (e) {
      _messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Reply error: $e',
        isSender: false,
        time: DateTime.now(),
        senderInitial: user.name[0].toUpperCase(),
      ));
    } finally {
      _loading.value = false;
      update();
    }
  }

  /// fetch meaning for a single word via free dictionary api
  Future<String?> fetchMeaning(String word) async {
    try {
      final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is List && decoded.isNotEmpty) {
          final meanings = decoded[0]['meanings'] as List<dynamic>;
          if (meanings.isNotEmpty) {
            final def = meanings[0]['definitions'][0]['definition'];
            return def?.toString();
          }
        }
      }
    } catch (_) {}
    return null;
  }
}
