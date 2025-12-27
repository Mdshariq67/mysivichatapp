import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../controllers/users_controller.dart';
import '../widgets/avatar_initial.dart';
import 'chat_view.dart';

class HistoryTab extends StatefulWidget {
  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> with AutomaticKeepAliveClientMixin {
  final HistoryController hc = Get.find();
  final UsersController uc = Get.find();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final items = hc.items;
      if (items.isEmpty) return Center(child: Text('No recent chats'));
      return ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(height: 1),
        itemBuilder: (ctx, i) {
          final it = items[i];
          return ListTile(
            leading: AvatarInitial(name: it.name),
            title: Text(it.name),
            subtitle: Text(it.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(_formatTime(it.time)),
            onTap: () {
              final user = uc.findById(it.userId);
              if (user != null) Get.to(() => ChatView(user: user));
            },
          );
        },
      );
    });
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
