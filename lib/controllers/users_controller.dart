import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class UsersController extends GetxController {
  final _users = <ChatUser>[].obs;

  List<ChatUser> get users => _users.toList();

  void addUser(String name) {
    final id = Uuid().v4();
    _users.insert(0, ChatUser(id: id, name: name));
    update(); // notify
  }

  ChatUser? findById(String id) {
    return _users.firstWhereOrNull((u) => u.id == id);
  }
}
