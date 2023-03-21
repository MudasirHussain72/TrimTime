class UserModel {
  String? uid;
  String? address;
  String? phone;
  String? latitude;
  String? onlineStatus;
  String? profileImage;
  String? userName;
  String? email;
  String? longitude;
  bool? isBarber;

  UserModel(
      {this.uid,
      this.address,
      this.phone,
      this.latitude,
      this.onlineStatus,
      this.profileImage,
      this.userName,
      this.email,
      this.longitude,
      this.isBarber});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    address = json['address'] ?? '';
    phone = json['phone'] ?? '';
    latitude = json['latitude'] ?? '';
    onlineStatus = json['onlineStatus'] ?? '';
    profileImage = json['profileImage'] ?? '';
    userName = json['userName'] ?? '';
    email = json['email'] ?? '';
    longitude = json['longitude'] ?? '';
    isBarber = json['isBarber'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['address'] = address;
    data['phone'] = phone;
    data['latitude'] = latitude;
    data['onlineStatus'] = onlineStatus;
    data['profileImage'] = profileImage;
    data['userName'] = userName;
    data['email'] = email;
    data['longitude'] = longitude;
    data['isBarber'] = isBarber;
    return data;
  }
}
