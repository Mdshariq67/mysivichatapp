import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mysivichatapp/controllers/chat_controller.dart';
import 'package:mysivichatapp/controllers/history_controller.dart';
import 'package:mysivichatapp/models/user_model.dart';

void main() {
  group('ChatController Tests', () {
    late ChatController controller;

    setUp(() {
      Get.testMode = true;
      Get.put(HistoryController());

      final user = ChatUser(id: '1', name: 'Alice');
      controller = ChatController(user);
    });

    test('Initial welcome message exists', () {
      expect(controller.messages.isNotEmpty, true);
    });

    test('Sending local message adds sender message', () async {
      controller.sendLocalMessage('Hello');

      expect(controller.messages.last.isSender, true);
      expect(controller.messages.last.text, 'Hello');
    });

    test('Receiver message is added after API call', () async {
       controller.sendLocalMessage('Hi');


      expect(controller.messages.last.isSender, false);
    });
  });
}
