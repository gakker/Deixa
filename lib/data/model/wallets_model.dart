class WalletsModel {
  WalletsModel({
    required this.status,
    required this.message,
    required this.publicKeys,
  });
  late final String status;
  late final String message;
  late final List<PublicKeys> publicKeys;

  WalletsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    publicKeys = List.from(json['publicKeys']).map((e)=>PublicKeys.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['publicKeys'] = publicKeys.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class PublicKeys {
  PublicKeys({
    required this.id,
    required this.uid,
    required this.addressKey,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String uid;
  late final String addressKey;
  late final String createdAt;
  late final String updatedAt;

  PublicKeys.fromJson(Map<String, dynamic> json){
    id = json['id'];
    uid = json['uid'];
    addressKey = json['address_key'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['address_key'] = addressKey;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}