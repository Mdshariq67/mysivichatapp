import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/users_controller.dart';
import '../models/user_model.dart';
import 'chat_view.dart';
import '../widgets/avatar_initial.dart';

class UsersTab extends StatefulWidget {
  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> with AutomaticKeepAliveClientMixin {
  final UsersController uc = Get.find();
  final _scroll = ScrollController();

  @override
  bool get wantKeepAlive => true;

  void _addUserDialog() {
    final ctrl = TextEditingController();
    Get.defaultDialog(
      title: 'Add User',
      content: Column(
        children: [
          TextField(controller: ctrl, decoration: InputDecoration(hintText: 'Name')),
        ],
      ),
      textConfirm: 'Add',
      onConfirm: () {
        final name = ctrl.text.trim();
        if (name.isEmpty) {
          Get.snackbar('Error', 'Please enter a name');
          return;
        }
        uc.addUser(name);
        Get.back();
        Get.snackbar('User added', name);
      },
      textCancel: 'Cancel',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Obx(() {
        final users = uc.users;
        if (users.isEmpty) {
          return Center(child: Text('No users yet. Tap + to add.'));
        }
        return ListView.separated(
          controller: _scroll,
          padding: EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (ctx, i) {
            final u = users[i];
            return ListTile(
              leading: AvatarInitial(name: u.name),
              title: Text(u.name),
              subtitle: Text('Tap to chat'),
              onTap: () => Get.to(() => ChatView(user: u)),
            );
          },
          separatorBuilder: (_, __) => Divider(height: 1),
          itemCount: users.length,
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUserDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
