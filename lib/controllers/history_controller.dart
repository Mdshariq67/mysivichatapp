import 'package:get/get.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import 'package:intl/intl.dart';

class HistoryItem {
  final String userId;
  final String name;
  final String lastMessage;
  final DateTime time;

  HistoryItem({
    required this.userId,
    required this.name,
    required this.lastMessage,
    required this.time,
  });
}

class HistoryController extends GetxController {
  final _list = <HistoryItem>[].obs;

  List<HistoryItem> get items => _list.toList();

  void updateOrAdd(String userId, String name, String lastMessage, DateTime time) {
    final idx = _list.indexWhere((i) => i.userId == userId);
    final hi = HistoryItem(userId: userId, name: name, lastMessage: lastMessage, time: time);
    if (idx == -1) {
      _list.insert(0, hi);
    } else {
      _list.removeAt(idx);
      _list.insert(0, hi);
    }
    update();
  }
}
