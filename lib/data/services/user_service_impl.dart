import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sanity_web/commons/firestore/firestore_path.dart';
import 'package:sanity_web/commons/firestore/firestore_service.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/data/services/interfaces/user_service.dart';

class UserServiceImpl implements UserService{
  final FirestoreService? firestoreService;

  UserServiceImpl({@required this.firestoreService});

  // Create/Update
  @override
  Future<void> setUser({required UserModel user, bool merge = false}) async => await firestoreService!.set(
        path: FirestorePath.user(user.uid),
        data: user.toJson(),
        merge: merge
      );

  // Delete
  @override
  Future<void> deleteUser(UserModel user) async {
    await firestoreService!.deleteData(path: FirestorePath.user(user.uid));
  }

  // Get by userId
  @override
  Future<UserModel> getByUserId({required String userId}) async =>
      await firestoreService!.documentSnapshot(
        path: FirestorePath.user(userId),
        builder: (data, documentId) => UserModel.fromJson(data, documentId),
      );

  // Get all
  @override
  Future<List<UserModel>> getAllUser() async => 
      await firestoreService!.collectionSnapshot(
        path: FirestorePath.users(),
        builder: (data, documentId) => UserModel.fromJson(data, documentId),
      );

  // Get all follower
  @override
  Future<List<UserModel>> getAllFollowers({required String userId, required List<String> followersIds}) async {
    if(followersIds.isNotEmpty){
      return await firestoreService!.collectionSnapshot(
          path: FirestorePath.users(),
          builder: (data, documentId) => UserModel.fromJson(data, documentId),
          queryBuilder: (query) {
            var tempQuery = query.where(FieldPath.documentId, whereIn: followersIds);
            return tempQuery;
          },
          sort: ((lhs, rhs) => lhs.name.compareTo(rhs.name))
          );
    }else{
      var currentUser = await firestoreService!.documentSnapshot(
          path: FirestorePath.user(userId),
          builder: (data, documentId) => UserModel.fromJson(data, documentId),
        );

      if(currentUser.followers != null && currentUser.followers!.isNotEmpty)
      {
        return await firestoreService!.collectionSnapshot(
            path: FirestorePath.users(),
            builder: (data, documentId) => UserModel.fromJson(data, documentId),
            queryBuilder: (query) {
              var tempQuery = query.where(FieldPath.documentId, whereIn: currentUser.followers);
              return tempQuery;
            },
            sort: ((lhs, rhs) => lhs.name.compareTo(rhs.name))
            );
      }
    }
    return [];
  }

  // Get all following
  @override
  Future<List<UserModel>> getAllFollowings({required String userId, required List<String> followingIds}) async {
    if(followingIds.isNotEmpty){
      return await firestoreService!.collectionSnapshot(
          path: FirestorePath.users(),
          builder: (data, documentId) => UserModel.fromJson(data, documentId),
          queryBuilder: (query) {
            var tempQuery = query.where(FieldPath.documentId, whereIn: followingIds);
            return tempQuery;
          },
          sort: ((lhs, rhs) => lhs.name.compareTo(rhs.name))
          );
    }else{
      var currentUser = await firestoreService!.documentSnapshot(
          path: FirestorePath.user(userId),
          builder: (data, documentId) => UserModel.fromJson(data, documentId),
        );

      if(currentUser.following != null && currentUser.following!.isNotEmpty)
      {
        return await firestoreService!.collectionSnapshot(
            path: FirestorePath.users(),
            builder: (data, documentId) => UserModel.fromJson(data, documentId),
            queryBuilder: (query) {
              var tempQuery = query.where(FieldPath.documentId, whereIn: currentUser.following);
              return tempQuery;
            },
            sort: ((lhs, rhs) => lhs.name.compareTo(rhs.name))
            );
      }
    }
    return [];
  }

  // Get all raccomended
  @override
  Future<List<UserModel>> getAllRaccomended() async{
    return await firestoreService!.collectionSnapshot(
      path: FirestorePath.users(), 
      builder: ((data, documentID) => UserModel.fromJson(data, documentID)),
      queryBuilder: (query) {
        List<Query<Map<String, dynamic>>> queryList = [];
        queryList.add(query.where("isDoctor", isEqualTo: true));
        queryList.add(queryList.last.where("isPremium", isEqualTo: true));
        return queryList.last;
        },
      sort: ((lhs, rhs) => lhs.signInDate.compareTo(rhs.signInDate)) //TO check
      );
  }

  // Get all doctor 
  @override
  Future<List<UserModel>> searchDoctors() async =>     
      await firestoreService!.collectionSnapshot(
          path: FirestorePath.users(),
          builder: (data, documentId) => UserModel.fromJson(data, documentId),
          queryBuilder: (query) {
            var tempQuery = query.where("isDoctor", isEqualTo: true);
            return tempQuery;
          },
          sort: ((lhs, rhs) => lhs.name.compareTo(rhs.name))
          );
  
   @override
  Future<List<UserModel>> searchAllUser() async =>     
      await firestoreService!.collectionSnapshot(
          path: FirestorePath.users(),
          builder: (data, documentId) => UserModel.fromJson(data, documentId),
          sort: ((lhs, rhs) => lhs.name.compareTo(rhs.name))
          );
          
  @override
  Future<bool> checkByMail({required String email}) async {
    var result = await firestoreService!.collectionSnapshot(
          path: FirestorePath.users(),
          builder: (data, documentId) => UserModel.fromJson(data, documentId),
          queryBuilder: (query) {
            var tempQuery = query.where("mail", isEqualTo: email);
            return tempQuery;
          });
    if(result.isEmpty){
      return false;
    }else{
      return true;
    }
  }
  
  @override
  Future<void> updateSessionIdAndIsPremium({required String userId, String? sessionId, required bool isPremium}) async {
    var currentUser = await getByUserId(userId: userId);
    currentUser.sessionId = sessionId;
    currentUser.isPremium = isPremium;
    return await setUser(user: currentUser, merge: true);
  }

  @override
  Future<void> setDocumentReference({required String userId, required String docReference, required bool isCV}) async {
    var currentUser = await getByUserId(userId: userId);
    currentUser.documents ??= [];
    if(isCV){
      currentUser.documents!.removeWhere((element) => element.contains("cv?"));
    }else{
      currentUser.documents!.removeWhere((element) => element.contains("degree?"));
    }
    currentUser.documents!.add(docReference);
    return await setUser(user: currentUser, merge: true);
  }
  
  @override
  Future<UserModel> addFollow({required String userId, required String doctorId}) async{
    var currentUser = await getByUserId(userId: userId);
    currentUser.following ??= [];
    currentUser.following!.add(doctorId);
    await setUser(user: currentUser, merge: true);

    var doctorUser = await getByUserId(userId: doctorId);
    doctorUser.followers ??= [];
    doctorUser.followers!.add(userId);
    await setUser(user: doctorUser, merge: true);

    return currentUser;
  }
  
  @override
  Future<UserModel> removeFollow({required String userId, required String doctorId}) async{
    var currentUser = await getByUserId(userId: userId);
    currentUser.following ??= [];
    currentUser.following!.remove(doctorId);
    await setUser(user: currentUser, merge: true);
    
    var doctorUser = await getByUserId(userId: doctorId);
    doctorUser.followers ??= [];
    doctorUser.followers!.remove(userId);
    await setUser(user: doctorUser, merge: true);
    
    return currentUser;
  }
  
  @override
  Future<UserModel> updateCoverImage({required String userId, required String imageReference}) async {
    var currentUser = await getByUserId(userId: userId);
    currentUser.photoCoverUrl = imageReference;
    await setUser(user: currentUser, merge: true);
    
    return currentUser;
  }

  @override
  Future<UserModel> updateProfileImage({required String userId, required String imageReference}) async {
    var currentUser = await getByUserId(userId: userId);
    currentUser.photoUrl = imageReference;
    await setUser(user: currentUser, merge: true);
    
    return currentUser;
  }
  
  @override
  Future<UserModel> updateEmail({required String userId, required String newMail}) async {
    var currentUser = await getByUserId(userId: userId);
    currentUser.mail = newMail;
    await setUser(user: currentUser, merge: true);
    
    return currentUser;
  }
  
  @override
  Future<void> incrementPostCounter({required String userId}) async{
    var currentUser = await getByUserId(userId: userId);
    currentUser.counterFreePost++;
    return await setUser(user: currentUser, merge: true);
  }
}