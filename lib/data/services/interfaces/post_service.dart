import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/models/section_model.dart';

abstract class PostService {
  Future<void> setPost({required PostModel post, bool merge = false});
  Future<void> setSection(SectionModel section, String postId);
  Future<void> deletePost({required PostModel post});
  Future<List<PostModel>> getAllForHome({bool? includePro, List<String>? doctorIds});
  Future<List<PostModel>> getAllDraft({required String doctorId});
  Future<List<PostModel>> getAllSaved({required String userId});
  Future<List<PostModel>> getAllPostByAndForMe({String? doctorId, String? userId, bool? isPrivate});
  Future<PostModel> getByPostId({required String postId});
  Future<List<SectionModel>> getSectionsByPostId({required String postId});
  Future<int> getUserPostCount({required String uid});
  Future<PostModel> addLike({required String postId, required String userId});
  Future<bool> reedemCode({required String userId, required String reedemCode});
  Future<PostModel> removeLike({required String postId, required String userId});
  Future<bool> clonePost({required PostModel post});
}