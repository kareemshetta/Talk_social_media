class MessageModel {
  final String senderId;
  final String receiverId;
  final String dateTime;
  final String text;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.dateTime,
  });

  factory MessageModel.fromJson(dynamic jsonData) {
    final senderId = jsonData['senderId'];
    final receiverId = jsonData['receiverId'];
    final dateTime = jsonData['dateTime'];
    final text = jsonData['text'];

    return MessageModel(
        dateTime: dateTime,
        receiverId: receiverId,
        senderId: senderId,
        text: text);
  }

  dynamic toMap() {
    return {
      'text': text,
      'dateTime': dateTime,
      'receiverId': receiverId,
      'senderId': senderId
    };
  }
}
