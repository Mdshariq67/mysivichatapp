class Message {
  final String id;
  final String text;
  final bool isSender;
  final DateTime time;
  final String senderInitial;

  Message({
    required this.id,
    required this.text,
    required this.isSender,
    required this.time,
    required this.senderInitial,
  });
}
