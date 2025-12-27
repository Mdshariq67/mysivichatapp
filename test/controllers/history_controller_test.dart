import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mysivichatapp/controllers/history_controller.dart';

void main() {
  group('HistoryController Tests', () {
    late HistoryController controller;

    setUp(() {
      Get.testMode = true;
      controller = HistoryController();
    });

    test('History initially empty', () {
      expect(controller.items.isEmpty, true);
    });

    test('New chat adds history item', () {
      controller.updateOrAdd(
        '1',
        'Alice',
        'Hello',
        DateTime.now(),
      );

      expect(controller.items.length, 1);
      expect(controller.items.first.name, 'Alice');
    });

    test('Updating existing chat should not duplicate', () {
      controller.updateOrAdd('1', 'Alice', 'Hello', DateTime.now());
      controller.updateOrAdd('1', 'Alice', 'New message', DateTime.now());

      expect(controller.items.length, 1);
      expect(controller.items.first.lastMessage, 'New message');
    });
  });
}
