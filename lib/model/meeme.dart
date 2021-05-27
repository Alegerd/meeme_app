class Meeme {
  String id;
  String imageUrl;
  String text;
  Map likes;
  String userId;
  DateTime createdAt;

  Meeme.fromParameters(String uid, String imageUrl, String text, String userId, Map likes, DateTime createdAt) {
    this.id = uid;
    this.imageUrl = imageUrl;
    this.text = text;
    this.likes = likes;
    this.userId = userId;
    this.createdAt = createdAt;
  }

  Meeme.fromJson(String uid, Map<String, dynamic> values) {
    this.id = uid;
    this.imageUrl = values['imageUrl'];
    this.text = values['text'];
    this.likes = values['likes'];
    this.userId = values['userId'];
    this.createdAt = values['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "imageUrl": imageUrl,
      "text": text,
      "likes": likes,
      "userId": userId,
      "createdAt": createdAt
    };
  }
}
