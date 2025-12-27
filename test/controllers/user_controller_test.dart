import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mysivichatapp/controllers/users_controller.dart';


void main() {
  group('UsersController Tests', () {
    late UsersController controller;

    setUp(() {
      Get.testMode = true;
      controller = UsersController();
    });

    test('Initially user list should be empty', () {
      expect(controller.users.length, 0);
    });

    test('Adding a user should increase list size', () {
      controller.addUser('Alice');
      expect(controller.users.length, 1);
      expect(controller.users.first.name, 'Alice');
    });

    test('Multiple users can be added', () {
      controller.addUser('Alice');
      controller.addUser('Bob');

      expect(controller.users.length, 2);
    });
  });
}
