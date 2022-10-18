class PostModel {
  final String name;
  final String uId;
  final String dataTime;
  final String userImage;
  final String text;
  String? image;

  PostModel({
    required this.userImage,
    required this.uId,
    required this.name,
    required this.dataTime,
    this.image,
    required this.text,
  });

  factory PostModel.fromJson(dynamic jsonData, {likesJsonData}) {
    final name = jsonData['name'];
    final userImage = jsonData['userImage'];
    final id = jsonData['uId'];
    final image = jsonData['image'];
    final dateTime = jsonData['dateTime'];
    final text = jsonData['text'];

    return PostModel(
      uId: id,
      userImage: userImage,
      name: name,
      text: text,
      image: image,
      dataTime: dateTime,
    );
  }

  dynamic toMap() {
    return {
      'name': name,
      'uId': uId,
      'text': text,
      'dateTime': dataTime,
      'image': image,
    };
  }
}
