class UserModel {
  final String name;
  final String id;
  final String email;
  final String phone;
  final String bio;
  final String image;
  final String coverImage;
  UserModel(
      {required this.email,
      required this.id,
      required this.name,
      required this.phone,
      required this.bio,
      required this.image,
      required this.coverImage});

  factory UserModel.fromJson(dynamic jsonData) {
    final name = jsonData['name'];
    final id = jsonData['id'];
    final email = jsonData['email'];
    final phone = jsonData['phone'];
    final image = jsonData['image'];
    final bio = jsonData['bio'];
    final coverImage = jsonData['coverImage'];

    return UserModel(
        email: email,
        id: id,
        name: name,
        phone: phone,
        bio: bio,
        image: image,
        coverImage: coverImage);
  }

  dynamic toMap() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'phone': phone,
      'bio': bio,
      'image': image,
      'coverImage': coverImage,
    };
  }
}
