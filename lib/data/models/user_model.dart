import 'package:sanity_web/commons/utils.dart';

class UserModel {
  String uid;
  String name;
  String surname;
  String? phoneNumber;
  String mail;
  bool isDoctor;
  bool isPremium;
  String? gender;
  String? address;
  String? city;
  String? photoUrl;
  String? photoCoverUrl;
  String? mainProfesion;
  List<String>? profession;
  String? description;
  List<String>? following;
  List<String>? followers;
  String fcmToken;
  String? sessionId;
  int counterFreePost;
  DateTime signInDate;
  List<String>? documents;

  UserModel({
    required this.uid,
    required this.name,
    required this.surname,
    this.phoneNumber,
    required this.mail,
    required this.isDoctor,
    required this.isPremium,
    this.gender,
    this.address,
    this.city,
    this.photoUrl,
    this.photoCoverUrl,
    this.mainProfesion,
    this.profession,
    this.description,
    this.following,
    this.followers,
    required this.fcmToken,
    this.sessionId,
    required this.counterFreePost,
    required this.signInDate,
    this.documents,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      uid: documentId,
      name: json['name'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'],
      mail: json['mail'],
      isDoctor: json['isDoctor'],
      isPremium: json['isPremium'],
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      photoCoverUrl: json['photoCoverUrl'] ?? '',
      mainProfesion: json['mainProfesion'] ?? '',
      profession: json['profession'] != null ? (json['profession'] as List).map((item) => item as String).toList() : null,
      description: json['description'] ?? '',
      following: json['following'] != null ? (json['following'] as List).map((item) => item as String).toList() : null,
      followers: json['followers'] != null ? (json['followers'] as List).map((item) => item as String).toList() : null,
      fcmToken: json['fcmToken'],
      sessionId: json['sessionId'],
      counterFreePost: json['counterFreePost'],
      signInDate: convertTimeStampToDateTime(json['signInDate']) ?? DateTime.now(),
      documents: json['documents'] != null ? (json['documents'] as List).map((item) => item as String).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'mail': mail,
      'phoneNumber': phoneNumber,
      'isDoctor': isDoctor,
      'isPremium': isPremium,
      'gender': gender,
      'address': address,
      'city': city,
      'photoUrl': photoUrl,
      'photoCoverUrl': photoCoverUrl,
      'mainProfesion': mainProfesion,
      'profession': profession,
      'description': description,
      'following': following,
      'followers': followers,
      'fcmToken': fcmToken,
      'sessionId': sessionId,
      'counterFreePost': counterFreePost,
      'signInDate': signInDate,
      'documents': documents,
    };
  }
}
