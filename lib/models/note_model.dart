class Note {
  String userId;
  String? title;
  String? content;
  String? image;

  Note(
      {required this.userId,
      required this.title,
      required this.content,
      required this.image});

  Note.fromJson(Map<dynamic, dynamic> json)
      : userId = json['userId'],
        title = json['title'],
        content = json['content'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'content': content,
        'image': image,
      };
}
