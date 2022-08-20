class UserModel {
  final String id;
  final String firebaseToken;
  final String image;
  final String phoneNumber;
  final String username;
  final bool active;
  UserModel(
      {required this.firebaseToken,
      required this.active,
      required this.id,
      required this.image,
      required this.phoneNumber,
      required this.username});

  UserModel.fromJson(Map<String, dynamic> data)
      : active = data["active"],
        id = data["uid"],
        image = data["image"],
        phoneNumber = data["phone"],
        username = data["username"],
        firebaseToken = data["token"];

  toJson() {
    return {
      "active": active,
      "uid": id,
      "image": image,
      "phone": phoneNumber,
      "token": firebaseToken,
      "username": username
    };
  }
}
