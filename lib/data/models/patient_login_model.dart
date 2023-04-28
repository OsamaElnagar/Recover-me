class PatientLoginModel {
  String name= '';
  String phone='';
  String email='';
  String bio='';
  String profileImage='';
  String profileCover='';
  String uId = '';
  String? disability = '';
  late String? receiverFCMToken;

  PatientLoginModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.bio,
    required this.profileImage,
    required this.profileCover,
    required this.uId,
     this.disability,
     this.receiverFCMToken,
  });

  PatientLoginModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    bio = json['bio'];
    profileImage = json['profileImage'];
    profileCover = json['profileCover'];
    uId = json['uId'];
    disability = json['disability'];
    receiverFCMToken = json['receiverFCMToken'];
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
      'disability': disability,
      'receiverFCMToken': receiverFCMToken,
    };
  }
}
