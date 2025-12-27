import 'package:flutter/material.dart';
import '../models/message_model.dart';
import 'avatar_initial.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final void Function(String word)? onWordTap;
  const MessageBubble({required this.message, this.onWordTap});

  @override
  Widget build(BuildContext context) {
    final isSender = message.isSender;
    final align = isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bg = isSender ? Colors.blue : Colors.grey.shade200;
    final txtColor = isSender ? Colors.white : Colors.black87;
    final radius = Radius.circular(14);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) AvatarInitial(name: message.senderInitial),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: align,
              children: [
                GestureDetector(
                  onTap: () {}, // could be used to open message actions
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.only(
                        topLeft: radius,
                        topRight: radius,
                        bottomLeft: isSender ? radius : Radius.circular(2),
                        bottomRight: isSender ? Radius.circular(2) : radius,
                      ),
                    ),
                    child: Wrap(
                      children: _buildTextSpans(message.text, txtColor, onWordTap),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(_shortTime(message.time), style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          SizedBox(width: 8),
          if (isSender) AvatarInitial(name: message.senderInitial),
        ],
      ),
    );
  }

  String _shortTime(DateTime t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  List<Widget> _buildTextSpans(String text, Color color, void Function(String)? onWordTap) {
    final words = text.split(' ');
    return words.map((w) {
      final cleaned = w.replaceAll(RegExp(r'[^\w]'), '');
      return GestureDetector(
        onTap: onWordTap == null ? null : () => onWordTap(cleaned),
        child: Padding(
          padding: EdgeInsets.only(right: 4),
          child: Text(w, style: TextStyle(color: color)),
        ),
      );
    }).toList();
  }
}
