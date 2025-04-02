import 'package:sanity_web/data/models/user_model.dart';

abstract class UserService {
  Future<void> setUser({required UserModel user, bool merge = false});
  Future<void> deleteUser(UserModel user);
  Future<void> incrementPostCounter({required String userId});
  Future<UserModel> getByUserId({required String userId});
  Future<bool> checkByMail({required String email});
  Future<List<UserModel>> getAllUser();
  Future<List<UserModel>> getAllFollowers({required String userId, required List<String> followersIds});
  Future<List<UserModel>> getAllFollowings({required String userId, required List<String> followingIds});
  Future<List<UserModel>> getAllRaccomended();
  Future<List<UserModel>> searchDoctors();
  Future<List<UserModel>> searchAllUser();
  Future<void> updateSessionIdAndIsPremium({required String userId, String? sessionId, required bool isPremium});
  Future<void> setDocumentReference({required String userId, required String docReference, required bool isCV});
  Future<UserModel> addFollow({required String userId, required String doctorId});
  Future<UserModel> removeFollow({required String userId, required String doctorId});
  Future<UserModel> updateCoverImage({required String userId, required String imageReference});
  Future<UserModel> updateProfileImage({required String userId, required String imageReference});
  Future<UserModel> updateEmail({required String userId, required String newMail});
}