class DoctorLoginModel {
  String? name = '';
  String? phone = '';
  String? email = '';
  String? bio = '';
  String? profileImage = '';
  String? profileCover = '';
  String? uId = '';
  String? prof = '';
  late String? receiverFCMToken;

  DoctorLoginModel({
     this.name,
     this.phone,
     this.email,
     this.bio,
     this.profileImage,
     this.profileCover,
     this.uId,
    this.receiverFCMToken,
    this.prof,
  });

  DoctorLoginModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    bio = json['bio'];
    profileImage = json['profileImage'];
    profileCover = json['profileCover'];
    uId = json['uId'];
    receiverFCMToken = json['receiverFCMToken'];
    prof = json['prof'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'profileCover': profileCover,
      'uId': uId,
      'prof': prof,
      'receiverFCMToken': receiverFCMToken,
    };
  }
}
