class UserModel {
  String? uid;
  String? city;
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
      this.city,
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
    city = json['city'] ?? '';
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['city'] = this.city;
    data['phone'] = this.phone;
    data['latitude'] = this.latitude;
    data['onlineStatus'] = this.onlineStatus;
    data['profileImage'] = this.profileImage;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['longitude'] = this.longitude;
    data['isBarber'] = this.isBarber;
    return data;
  }
}
