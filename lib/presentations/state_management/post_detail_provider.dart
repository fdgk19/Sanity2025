import 'package:flutter/cupertino.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/data/services/interfaces/post_service.dart';
import 'package:sanity_web/data/services/interfaces/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetailProvider with ChangeNotifier{
  final PostService? postService;
  final UserService? userService;
  final SharedPreferences? sharedPreferences;
  
  PostDetailProvider({@required this.postService, @required this.userService, @required this.sharedPreferences});

  bool loadingDetails = false;
  bool loadingMediaDetails = false;
  bool isFavorite = false;
  
  PostModel? _postDetails;
  UserModel? _userDetail;
  
  PostModel? get postDetails => _postDetails;
  UserModel? get userDetail => _userDetail;

  getPostDetails({required PostModel post}) async{
    _startDetailsOperation();
    var tempId = sharedPreferences!.getString("userId");
    if(tempId != null){
      _postDetails = post;
      _postDetails!.section = await postService!.getSectionsByPostId(postId: post.pid);
      _userDetail = await userService!.getByUserId(userId: post.doctorId);
      postDetails!.userIdLikes ??= [];
      isFavorite = postDetails!.userIdLikes!.contains(tempId);
    }
    _endDetailsOperation();
  }

  Future<PostModel> getPostDetailsById({required String postId, required String doctorId}) async{
    return await postService!.getByPostId(postId: postId);
  }

  Future<void> removeLike() async {
    var tempId = sharedPreferences!.getString("userId");
    if(tempId != null){
      var tempPostDetails = await postService!.removeLike(userId: tempId, postId: postDetails!.pid);
      _postDetails!.userIdLikes = tempPostDetails.userIdLikes;
      isFavorite = postDetails!.userIdLikes!.contains(tempId);
    }
    notifyListeners();
  }

  Future<void> addLike() async {
    var tempId = sharedPreferences!.getString("userId");
    if(tempId != null){
      var tempPostDetails = await postService!.addLike(userId: tempId, postId: postDetails!.pid);
      _postDetails!.userIdLikes = tempPostDetails.userIdLikes;
      isFavorite = postDetails!.userIdLikes!.contains(tempId);
    }
    notifyListeners();
  }

  // #region Methods for manage loader
  _startDetailsOperation() {
    loadingDetails = true;
    notifyListeners();
  }

  _endDetailsOperation() {
    loadingDetails = false;
    notifyListeners();
  }

  startMediaDetailsOperation() {
    loadingMediaDetails = true;
    notifyListeners();
  }

  endMediaDetailsOperation() {
    loadingMediaDetails = false;
    notifyListeners();
  }
// #endregion
}