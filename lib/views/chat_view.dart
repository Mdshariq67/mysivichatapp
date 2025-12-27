import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';
import '../models/message_model.dart';
import '../widgets/avatar_initial.dart';

class ChatView extends StatefulWidget {
  final ChatUser user;
  ChatView({required this.user});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ChatController cc;
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // create a controller for this user
    cc = Get.put(ChatController(widget.user), tag: widget.user.id);
  }

  void _send() {
    final txt = _input.text.trim();
    if (txt.isEmpty) return;
    cc.sendLocalMessage(txt);
    _input.clear();
    // scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      _scroll.animateTo(_scroll.position.maxScrollExtent + 100, duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  void _onWordLongPressed(String word) async {
    final def = await cc.fetchMeaning(word);
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(word, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text(def ?? 'No meaning found.'),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () => Get.back(), child: Text('Close')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          AvatarInitial(name: widget.user.name),
          SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.user.name, style: TextStyle(fontSize: 16)),
            Text('Online', style: TextStyle(fontSize: 12)),
          ])
        ]),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final msgs = cc.messages;
              return ListView.builder(
                controller: _scroll,
                padding: EdgeInsets.all(12),
                itemCount: msgs.length,
                itemBuilder: (ctx, i) {
                  final m = msgs[i];
                  return GestureDetector(
                    onLongPress: () {
                      // long press toggles bottom sheet with whole message (or choose a word)
                      // here we'll allow selecting a word by showing choices
                      // simple approach: split words and let user tap a word
                      Get.bottomSheet(
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: m.text.split(' ').map((w) {
                              final clean = w.replaceAll(RegExp(r'[^\w]'), '');
                              return ActionChip(
                                label: Text(clean),
                                onPressed: () {
                                  Get.back();
                                  _onWordLongPressed(clean);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    child: MessageBubble(
                      message: m,
                      onWordTap: (word) => _onWordLongPressed(word),
                    ),
                  );
                },
              );
            }),
          ),
          _buildComposer()
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _input,
                decoration: InputDecoration(hintText: 'Type a message', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
            SizedBox(width: 8),
            CircleAvatar(
              child: IconButton(
                icon: Icon(Icons.send, size: 18, color: Colors.white),
                onPressed: _send,
              ),
              radius: 22,
              backgroundColor: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
