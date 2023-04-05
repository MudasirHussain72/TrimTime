class ShopModel {
  String? uid;
  String? shopName;
  String? shopImage;
  String? phone;
  String? address;
  String? latitude;
  String? longitude;
  String? fromTime;
  String? toTime;
  String? deviceToken;

  ShopModel({
    this.uid,
    this.address,
    this.phone,
    this.latitude,
    this.shopImage,
    this.shopName,
    this.longitude,
    this.fromTime,
    this.toTime,
    this.deviceToken,
  });

  ShopModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    address = json['address'] ?? '';
    phone = json['phone'] ?? '';
    latitude = json['latitude'] ?? '';
    shopImage = json['shopImage'] ?? '';
    shopName = json['shopName'] ?? '';
    longitude = json['longitude'] ?? '';
    fromTime = json['fromTime'] ?? '';
    toTime = json['toTime'] ?? '';
    deviceToken = json['deviceToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['address'] = address;
    data['phone'] = phone;
    data['latitude'] = latitude;
    data['shopImage'] = shopImage;
    data['shopName'] = shopName;
    data['longitude'] = longitude;
    data['fromTime'] = fromTime;
    data['toTime'] = toTime;
    data['deviceToken'] = deviceToken;
    return data;
  }
}
