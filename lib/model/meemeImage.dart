class MeemeImage {
  String id;
  String userId;
  String imageUrl;
  Map likes;
  DateTime createdAt;

  MeemeImage.fromParameters(String uid, String imageUrl, String userId,
      Map likes, DateTime dateTime) {
    this.id = uid;
    this.imageUrl = imageUrl;
    this.userId = userId;
    this.likes = likes;
    this.createdAt = dateTime;
  }

  MeemeImage.fromJson(String uid, Map<String, dynamic> values) {
    this.id = uid;
    this.userId = values['userId'];
    this.imageUrl = values['imageUrl'];
    this.likes = values['likes'];
    this.createdAt = values['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "imageUrl": imageUrl,
      "userId": userId,
      "likes": likes,
      "createdAt": createdAt
    };
  }
}