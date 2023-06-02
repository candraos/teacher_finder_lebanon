class Message{
  final int id;
  final String content;
  final bool markAsRead;
  final String userFrom;
  final String userTo;
  final DateTime createdAt;
  final bool isMine;

  Message(
      {
        required this.id,
        required this.content,
        required this.markAsRead,
        required this.userFrom,
        required this.userTo,
        required this.createdAt,
        required this.isMine
      });

  Message.create({
    required this.content, required this.userFrom, required this.userTo
})
  : id = 0,
  markAsRead = false,
  isMine = true,
  createdAt = DateTime.now();

  Message.fromJson(Map<String,dynamic> json, String userId) : id = json["id"], content = json["content"],markAsRead = json["mark_as_read"],userFrom = json["user_from"],userTo = json["user_to"],createdAt = DateTime.parse(json["created_at"]),isMine = json["user_from"] == userId;

  Map toMap(){
    return {
      "content" : content,
      "user_from" : userFrom,
      "user_to" : userTo,
      "mark_as_read" : markAsRead
    };
  }
}