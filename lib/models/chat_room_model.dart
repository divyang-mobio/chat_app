class ChatRoom{
  String id;

  ChatRoom({required this.id});

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(id: json['id']);
}