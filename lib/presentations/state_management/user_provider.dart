import 'package:flutter/material.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/data/services/interfaces/post_service.dart';
import 'package:sanity_web/data/services/interfaces/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListProvider with ChangeNotifier{
  final UserService? userService;
  final PostService? postService;
  final SharedPreferences? sharedPreferences;
  
  UserListProvider({@required this.userService, @required this.postService, @required this.sharedPreferences});

  bool loading = false;
  
  List<UserModel>? _userListPro;
  List<UserModel>? _userListFollower;
  List<UserModel>? _userListFollowing;
  List<UserModel>? _userSearched;

  UserModel? _userDetail;
  int _userPostCount = 0;
  
  List<UserModel>? get userListPro => _userListPro;
  List<UserModel>? get userListFollower => _userListFollower;
  List<UserModel>? get userListFollowing => _userListFollowing;
  List<UserModel>? get userSearched => _userSearched;
  UserModel? get userDetail => _userDetail;
  int get userPostCount => _userPostCount;

  getUserPostCount({required String userId}) async{
    _userPostCount = await postService!.getUserPostCount(uid: userId); 
    notifyListeners();
  }

  getRaccomendedUsers() async{
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      _userListPro = await userService!.getAllRaccomended(); 
      _endOperation(); 
    });
  }

  search() async{
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      _userSearched = await userService!.searchDoctors(); 
      _endOperation(); 
    });
  }

  searchAllUser() async{
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      _userSearched = await userService!.searchAllUser(); 
      _endOperation(); 
    });
  }

  getFollowingUsers() async{
    _startOperation();
    
    Future.delayed(const Duration(milliseconds: 500), () async {
    var doctorIDs = sharedPreferences!.getStringList("followingDoctorIds") ?? [];
    var tempUserId = sharedPreferences!.getString("userId");
    if (tempUserId == null) {
      _endOperation();
      return;
    }
    
    _userListFollowing = await userService!.getAllFollowings(userId: tempUserId, followingIds:doctorIDs);
    
    _endOperation();  
    });
  }

  getFollowersUsers() async{
    _startOperation();
    
    var userIDs = sharedPreferences!.getStringList("followersIds") ?? [];
    var tempUserId = sharedPreferences!.getString("userId");
    if (tempUserId == null) {
      _endOperation();
      return;
    }

    _userListFollower = await userService!.getAllFollowers(userId: tempUserId, followersIds:userIDs);
   
    
    _endOperation(); 
  }

  getUserDetail({required String userId}) async{
    _startOperation();

    Future.delayed(const Duration(milliseconds: 500), () async {
      _userDetail = await userService!.getByUserId(userId: userId);
      _endOperation(); 
    });
  }

  Future<UserModel> getPostUserDetail({required String userId}) async{
    return await userService!.getByUserId(userId: userId);
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