// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/models/section_media_model.dart';
import 'package:sanity_web/data/models/section_model.dart';
import 'package:sanity_web/data/services/interfaces/post_service.dart';
import 'package:sanity_web/data/services/interfaces/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPostProvider with ChangeNotifier {
  final PostService? postService;
  final UserService? userService;
  final SharedPreferences? sharedPreferences;

  NewPostProvider(
      {@required this.postService,
      @required this.userService,
      @required this.sharedPreferences});

  bool loading = false;
  bool loadingMedia = false;

  PostModel? _post;
  // ignore: prefer_final_fields
  List<SectionModel> _sectionList = [];

  PostModel? get post => _post;
  List<SectionModel> get sectionList => _sectionList;

  List<String> mediaContentRemoved = [];

  Future<bool>clonePost({required PostModel post}) async{
    
    bool result =  await postService!.clonePost(post: post);
    if (result) {
      await userService!.incrementPostCounter(userId: post.doctorId);
    }
    return result;
    
  }

  initDraftPost({required String postId}) async{
    _startOperation();
    _post = await postService!.getByPostId(postId: postId);
    _sectionList = await postService!.getSectionsByPostId(postId: postId);
    _endOperation();
  }


  initEditPostPost({required PostModel post}) async{
    _startOperation();
    _post = post;
    _sectionList = await postService!.getSectionsByPostId(postId: post.pid);
    
    _endOperation();
  }


// #region Methods for Edit flow
  setSectionForEdit(int index) async {
    Map<String, dynamic> sectionMap = sectionList[index].toShared();
    String sectionJsonString = jsonEncode(sectionMap);
    await sharedPreferences!.setString('sectionEdit', sectionJsonString);
  }

  SectionModel? getSectionForEdit() {
    var secFromShared = sharedPreferences!.getString('sectionEdit');
    if (secFromShared != null) {
      var sectionJson = jsonDecode(secFromShared);
      return SectionModel.fromShared(sectionJson);
    }
    return null;
  }

  confirmEditSection(SectionModel section) async {
    // Cancello i media che ho tolto in fase di edit dallo storage
    for (var mediaContent in mediaContentRemoved) {
      var delResult = await removeSectionMediaFromStorage(mediaContent);
      if (!delResult) {
        print("Error on delete section Media");
      }
    }
    updateSectionTitle(section);
  }

  abortEditSection(SectionModel previousVersion, int currentIndex) async {
    List<SectionMediaModel> mediaToRemove = [];
    var modifiedSection = sectionList[currentIndex];

    //tolgo media
    for (var media in modifiedSection.sectionMediaList!) {
      bool needRemove = true;

      for (var prevMedia in previousVersion.sectionMediaList!) {
        if(prevMedia.mediaContent == media.mediaContent && prevMedia.mediaType == media.mediaType){
          needRemove = false;
        }
      }
      if(needRemove){
        mediaToRemove.add(media);
      }
    }

    for (var media in mediaToRemove) {
      var tempIndex =
          sectionList[currentIndex].sectionMediaList!.indexOf(media);
      await removeSectionMedia(currentIndex, tempIndex, false, false);
    }

    sectionList[currentIndex] = previousVersion;
    notifyListeners();
  }

// #endregion

// #region Methods for manage section list order
  removeSection(int index) async {
    if (sectionList.length > index) {
      _startOperation();
      SectionModel tempSection = sectionList[index];
      if (tempSection.sectionMediaList != null) {
        //remove from storage
        var delResult = await removeAllSectionMedia(tempSection.sid);
        if (!delResult) {
          print("Error on delete section Media");
        }
      }

      _sectionList.removeAt(index);
      
      updatePositionProps();
      _endOperation();
    }
  }

  moveUpSection(int index) {
    var newIndex = index == 0 ? 0 : index - 1;
    var itemMoved = sectionList.removeAt(index);
    sectionList.insert(newIndex, itemMoved);

    updatePositionProps();
    notifyListeners();
  }

  moveDownSection(int index) {
    var newIndex = index == sectionList.length ? sectionList.length : index + 1;
    var itemMoved = sectionList.removeAt(index);
    sectionList.insert(newIndex, itemMoved);

    updatePositionProps();
    notifyListeners();
  }

  updatePositionProps(){
    for (var section in sectionList) {
      section.position = sectionList.indexOf(section);
    }
  }

// #endregion

// #region Methods for Content Creator
  addMediaSection(int sectionIdex, SectionMediaModel sectionMedia) {
    if (_sectionList[sectionIdex].sectionMediaList == null) {
      _sectionList[sectionIdex].sectionMediaList = [];
    }
    _sectionList[sectionIdex].sectionMediaList!.add(sectionMedia);
    //notifyListeners();
  }

  moveUpSectionMedia(int sectionIdex, int index) {
    _startMediaOperation();
    
    Future.delayed(const Duration(milliseconds: 200), () async {
      var newIndex = index == 0 ? 0 : index - 1;
      var itemMoved = sectionList[sectionIdex].sectionMediaList!.removeAt(index);
      sectionList[sectionIdex].sectionMediaList!.insert(newIndex, itemMoved);

      _endMediaOperation();
    });
  }

  moveDownSectionMedia(int sectionIdex, int index) {
    _startMediaOperation();
    
    Future.delayed(const Duration(milliseconds: 200), () async {
      var newIndex = index == sectionList[sectionIdex].sectionMediaList!.length
          ? sectionList[sectionIdex].sectionMediaList!.length
          : index + 1;
      var itemMoved = sectionList[sectionIdex].sectionMediaList!.removeAt(index);
      sectionList[sectionIdex].sectionMediaList!.insert(newIndex, itemMoved);

      _endMediaOperation();
    });
  }

  removeSectionMedia(int sectionIdex, int index, bool fromEdit, bool toNotify) async {
    if(toNotify){
      _startMediaOperation();
      Future.delayed(const Duration(milliseconds: 200), () async {
        SectionMediaModel tempSectionMedia =
            sectionList[sectionIdex].sectionMediaList![index];
        if (fromEdit) {
          mediaContentRemoved.add(tempSectionMedia.mediaContent);
        } else {
          if(tempSectionMedia.mediaType != InputCreateType.text && tempSectionMedia.mediaType != InputCreateType.url && tempSectionMedia.mediaType != InputCreateType.signature) {
            var delResult = await removeSectionMediaFromStorage(tempSectionMedia.mediaContent);
          if (!delResult) {
            print("Error on delete section Media");
            }
          }
        }
        sectionList[sectionIdex].sectionMediaList!.removeAt(index);
        _endMediaOperation();
      });
    }else{
      SectionMediaModel tempSectionMedia =
            sectionList[sectionIdex].sectionMediaList![index];
        if (fromEdit) {
          mediaContentRemoved.add(tempSectionMedia.mediaContent);
        } else {
          if(tempSectionMedia.mediaType != InputCreateType.text && tempSectionMedia.mediaType != InputCreateType.url && tempSectionMedia.mediaType != InputCreateType.signature) {
            var delResult = await removeSectionMediaFromStorage(tempSectionMedia.mediaContent);
          if (!delResult) {
            print("Error on delete section Media");
            }
          }
        }
        sectionList[sectionIdex].sectionMediaList!.removeAt(index);
    }
  }

  addSection(SectionModel section) {
    if(sectionList.isNotEmpty){
      section.position = sectionList.indexOf(sectionList.last) + 1;
    }else{
      section.position = 0;
    }
    _sectionList.add(section);
    notifyListeners();
  }

  updateSectionTitle(SectionModel section) {
    var index =
        _sectionList.indexWhere((element) => element.sid == section.sid);
    if (index >= 0) {
      _sectionList[index].title = section.title;
      notifyListeners();
    }
  }

// #endregion

// #region Methods for manage loader
  _startOperation() {
    loading = true;
    notifyListeners();
  }

  _endOperation() {
    loading = false;
    notifyListeners();
  }

  _startMediaOperation() {
    loadingMedia = true;
    notifyListeners();
  }

  _endMediaOperation() {
    loadingMedia = false;
    notifyListeners();
  }
// #endregion

// #region Methods for Manage Post in Draft and Published 
  Future<bool> createDraftPost({required String title,required PlatformFile mainImage,List<String>? tags}) async {
    _startOperation();

    var tempDoctorId = sharedPreferences!.getString("userId");
    if (tempDoctorId == null) {
      _endOperation();
      return false;
    }
    var currentUser = await userService!.getByUserId(userId: tempDoctorId);
    String newPostId = firestoreId();
    var imageUrl = await uploadPostMainImage(newPostId, mainImage, "mainImage");

    if (imageUrl == null) {
      _endOperation();
      return false;
    }

    _post = PostModel(
        pid: newPostId,
        doctorId: currentUser.uid,
        mainTitle: title,
        isFromPro: currentUser.isPremium,
        isPublished: false,
        date: DateTime.now(),
        isPrivate: false,
        mainImage: imageUrl,
        tags: tags);

    await postService!.setPost(post: post!);

    await userService!.incrementPostCounter(userId: currentUser.uid);

    _endOperation();
    return true;
  }

  Future deletePost() async {
    if(post != null){
      await removeAllPostMedia();
      await postService!.deletePost(post: post!);
    }
    clearPostProvider();
  }

  Future saveAndExit({String? title, PlatformFile? imageUploaded, String? mainImageRef, List<String>? tags}) async {
    if(post != null){
      _post!.section = _sectionList;
      if(title != null){
        _post!.mainTitle = title;
      }
      if (imageUploaded != null) {
        var imageUrl = await uploadPostMainImage(post!.pid, imageUploaded, "mainImage");
        _post!.mainImage = imageUrl;
      }
      if(mainImageRef != null){
        _post!.mainImage = mainImageRef;
      }
      if(tags != null){
        _post!.tags = tags;
      }
      
      await postService!.setPost(post: post!);
    }
    clearPostProvider();
  }

  Future<bool> publishPost({required bool isPrivate, String? destinationUserId, PlatformFile? imageUploaded, String? mainImageRef}) async {
    _startOperation();
    var tempDoctorId = sharedPreferences!.getString("userId");
    if (tempDoctorId == null) {
      _endOperation();
      return false;
    }
    var currentUser = await userService!.getByUserId(userId: tempDoctorId);
    _post!.section = _sectionList;
    _post!.isFromPro = currentUser.isPremium;
    _post!.isPrivate = isPrivate;
    _post!.date = DateTime.now();
    _post!.isPublished = true;
    _post!.destinationUid = destinationUserId;
    if (imageUploaded != null) {
      var imageUrl = await uploadPostMainImage(post!.pid, imageUploaded, "mainImage");
      _post!.mainImage = imageUrl;
    }
    if(mainImageRef != null){
      _post!.mainImage = mainImageRef;
    }


    await postService!.setPost(post: post!);
    clearPostProvider();
    _endOperation();
    return true;
  }

  Future<bool> publishPostWithCode({String? reedemableCode, PlatformFile? imageUploaded, String? mainImageRef}) async {
    _startOperation();
    var tempDoctorId = sharedPreferences!.getString("userId");
    if (tempDoctorId == null) {
      _endOperation();
      return false;
    }
    var currentUser = await userService!.getByUserId(userId: tempDoctorId);
    _post!.section = _sectionList;
    _post!.isFromPro = currentUser.isPremium;
    _post!.isPrivate = true;
    _post!.reedemableCode = reedemableCode;
    _post!.date = DateTime.now();
    _post!.isPublished = true;
    if (imageUploaded != null) {
      var imageUrl = await uploadPostMainImage(post!.pid, imageUploaded, "mainImage");
      _post!.mainImage = imageUrl;
    }
    if(mainImageRef != null){
      _post!.mainImage = mainImageRef;
    }


    await postService!.setPost(post: post!);
    clearPostProvider();
    _endOperation();
    return true;
  }

  Future clearPostProvider() async {
    _post = null;
    _sectionList = [];
    notifyListeners();
  }
  

// #endregion

// #region Methods for Manage media in firebase storage
  Future<String?> uploadPostMainImage(String postId, PlatformFile tempFile, String mediaName) async {
    try {
      var tempDoctorId = sharedPreferences!.getString("userId");
      if (tempDoctorId == null) {
        return null;
      }

      Uint8List? uploadFile = tempFile.bytes;
      var mediaContentType = getExtention(tempFile.name, InputCreateType.image);

      FirebaseStorage storage = FirebaseStorage.instance;

      Reference refCover =
          storage.ref("$tempDoctorId/posts/$postId/$mediaName");

      UploadTask task = refCover.putData(
          uploadFile, SettableMetadata(contentType: mediaContentType));
      await task;

      var storageUrl = await FirebaseStorage.instance
          .ref()
          .child("$tempDoctorId/posts/$postId/$mediaName")
          .getDownloadURL();

      return storageUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> uploadSectionMedia(PlatformFile tempFile, String sectionId, String mediaName, InputCreateType mediaType) async {
    try {
      var tempDoctorId = sharedPreferences!.getString("userId");
      if (tempDoctorId == null) {
        return null;
      }

      Uint8List? uploadFile = tempFile.bytes;
      var mediaContentType = getExtention(tempFile.name, mediaType);

      FirebaseStorage storage = FirebaseStorage.instance;

      Reference refCover = storage.ref(
          "$tempDoctorId/posts/${post!.pid}/sections/$sectionId/$mediaName");

      UploadTask task = refCover.putData(
          uploadFile, SettableMetadata(contentType: mediaContentType));

      await task;

      // TO archive url of current uploaded file
      // we can save this url in post section data to make easy download in view all post
      var storageUrl = await FirebaseStorage.instance
          .ref()
          .child(
              "$tempDoctorId/posts/${post!.pid}/sections/$sectionId/$mediaName")
          .getDownloadURL();

      return storageUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> removeAllSectionMedia(String sectionId) async {
    try {
      var tempDoctorId = sharedPreferences!.getString("userId");
      if (tempDoctorId == null) {
        return false;
      }

      FirebaseStorage storage = FirebaseStorage.instance;

      Reference refCover =
          storage.ref("$tempDoctorId/posts/${post!.pid}/sections/$sectionId");

      await refCover.delete();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> removeAllPostMedia() async {
    try {
      var tempDoctorId = sharedPreferences!.getString("userId");
      if (tempDoctorId == null) {
        return false;
      }

      FirebaseStorage storage = FirebaseStorage.instance;

      Reference refCover =
          storage.ref("$tempDoctorId/posts/${post!.pid}");

      await refCover.delete();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> removeSectionMediaFromStorage(String mediaUrl) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference refCover = storage.ref(mediaUrl);

      await refCover.delete();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

// #endregion
}
