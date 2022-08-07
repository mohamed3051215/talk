class UserModel {
  final String id;
  final String image;
  final String phoneNumber;
  final String username;
  final bool active;
  final String? oneSignalID;
  UserModel(
      {required this.active,
      required this.oneSignalID,
      required this.id,
      required this.image,
      required this.phoneNumber,
      required this.username});

  UserModel.fromJson(Map<String, dynamic> data)
      : active = data["active"],
        id = data["uid"],
        oneSignalID = data['onesignal id'],
        image = data["image"],
        phoneNumber = data["phone"],
        username = data["username"];
}
