import 'package:flutter/cupertino.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/services/interfaces/post_service.dart';
import 'package:sanity_web/data/services/interfaces/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostListProvider with ChangeNotifier{
  final PostService? postService;
  final UserService? userService;
  final SharedPreferences? sharedPreferences;
  
  PostListProvider({@required this.postService, @required this.userService, @required this.sharedPreferences});

  bool loading = false;
  
  List<PostModel>? _postListPro;
  List<PostModel>? _postListFollowed;
  List<PostModel>? _postListDraft;
  List<PostModel>? _postListByMe;
  List<PostModel>? _postListForMe;
  List<PostModel>? _postListSaved;
  List<PostModel>? _postListByMePublic;
  
  List<PostModel>? get postListPro => _postListPro;
  List<PostModel>? get postListFollowed => _postListFollowed;
  List<PostModel>? get postListDraft => _postListDraft;
  List<PostModel>? get postListByMe => _postListByMe;
  List<PostModel>? get postListByMePublic => _postListByMePublic;
  List<PostModel>? get postListForMe => _postListForMe;
  List<PostModel>? get postListSaved => _postListSaved;

  getRaccomendedPosts() async{
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      _postListPro = await postService!.getAllForHome(includePro: true); 
      _endOperation();   
    });
  }

  getFollowingPosts() async{
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      var doctorIDs = sharedPreferences!.getStringList("followingDoctorIds") ?? [];
      if(doctorIDs.isNotEmpty){
        _postListFollowed = await postService!.getAllForHome(doctorIds: doctorIDs);
      }
      _endOperation(); 
    });
  }

  getDraftPost() async{
    var tempUserId = sharedPreferences!.getString("userId");
    if (tempUserId == null) {
      _postListDraft = [];
    }else{
      _postListDraft = await postService!.getAllDraft(doctorId: tempUserId); 
    }
    notifyListeners();
  }

 Future<bool> getPostByCode(String code) async  {
    var tempUserId = sharedPreferences!.getString("userId");
    if (tempUserId == null){
      return false;
    } 
    return await postService!.reedemCode(userId: tempUserId, reedemCode: code);
  }

  getPostsForMe() async {
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      var tempUserId = sharedPreferences!.getString("userId");
      if (tempUserId == null) {
        _endOperation();
        return;
      }
      _postListForMe = await postService!.getAllPostByAndForMe(userId: tempUserId, isPrivate: true);
      
      _endOperation(); 
    });
  }



  getPostsByMePublic({required String doctorId}) async {
    _startOperation();
      _postListByMePublic = await postService!.getAllPostByAndForMe(doctorId: doctorId, isPrivate: false);
      _endOperation(); 
  }

  getPostsByMe() async {
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      var tempUserId = sharedPreferences!.getString("userId");
      if (tempUserId == null) {
        _endOperation();
        return;
      }
      _postListByMe = await postService!.getAllPostByAndForMe(doctorId: tempUserId);
      
      _endOperation(); 
    });
  }

   deletePostByMe(PostModel post) async {
    _startOperation();
    Future.delayed(const Duration(milliseconds: 500), () async {
      await postService!.deletePost(post: post);
      _postListByMe!.remove(post);
      _endOperation(); 
    });
   }

   getPostsByDoctorId({required String doctorId}) async {
    _startOperation();
    _postListByMe = await postService!.getAllPostByAndForMe(doctorId: doctorId);
    
    _endOperation(); 
  }

  getSavedPosts () async{
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      var tempUserId = sharedPreferences!.getString("userId");
      if (tempUserId == null) {
        _endOperation();
        return;
      }
      _postListSaved = await postService!.getAllSaved(userId: tempUserId);
      
      _endOperation(); 
    });
  }

  // #region Methods for manage loader
  _startOperation() {
    loading = true;
    notifyListeners();
  }

  _endOperation() {
    loading = false;
    notifyListeners();
  }
// #endregion

}