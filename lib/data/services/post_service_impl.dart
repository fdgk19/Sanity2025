import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/commons/firestore/firestore_path.dart';
import 'package:sanity_web/commons/firestore/firestore_service.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/models/section_media_model.dart';
import 'package:sanity_web/data/models/section_model.dart';
import 'package:sanity_web/data/services/interfaces/post_service.dart';

class PostServiceImpl implements PostService{
  final FirestoreService? firestoreService;

  PostServiceImpl({@required this.firestoreService});

  // Create/Update
  @override
  Future<void> setPost({required PostModel post, bool merge = false}) async {
     await firestoreService!.set(
        path: FirestorePath.post(post.pid),
        data: post.toJson(),
        merge: merge
      ).then((_) async {
        if(post.section != null){
          for (var sec in post.section!) {
            await setSection(sec, post.pid);
          }
        }
      });
  }

  // Create/Update section
  @override
  Future<void> setSection(SectionModel section, String postId) async => 
     await firestoreService!.set(
        path: FirestorePath.section(postId, section.sid),
        data: section.toJson(),
      );

  // Delete
  @override
  Future<void> deletePost({required PostModel post}) async {
    await firestoreService!.deleteData(path: FirestorePath.post(post.pid));
  }

  // Get all
  @override
  Future<List<PostModel>> getAllForHome({bool? includePro, List<String>? doctorIds}) async{
    return await firestoreService!.collectionSnapshot(
      path: FirestorePath.posts(), 
      builder: ((data, documentID) => PostModel.fromJson(data, documentID)),
      queryBuilder: (query) {
        List<Query<Map<String, dynamic>>> queryList = [];
        queryList.add(query.where("isPrivate", isEqualTo: false));
        queryList.add(queryList.last.where("isPublished", isEqualTo: true));
        if(includePro != null){
          queryList.add(queryList.last.where("isFromPro", isEqualTo: includePro));
        }
        if(doctorIds != null){
          queryList.add(queryList.last.where("doctorId", whereIn: doctorIds));
        }
        return queryList.last;
      },
      sort: ((lhs, rhs) => lhs.date.compareTo(rhs.date)) //TO check
      );
  }

  // Get by postId
  @override
  Future<PostModel> getByPostId({required String postId}) async =>
      await firestoreService!.documentSnapshot(
        path: FirestorePath.post(postId),
        builder: (data, documentId) => PostModel.fromJson(data, documentId),
      );

  // Get all sections from the same post based on pid, this call should be used only on postdetail view
  @override
  Future<List<SectionModel>> getSectionsByPostId({required String postId}) async => 
      await firestoreService!.collectionSnapshot(
        path: FirestorePath.sections(postId),
        builder: (data, documentId) => SectionModel.fromJson(data, documentId),
        sort: ((lhs, rhs) => lhs.position!.compareTo(rhs.position!)),
      );
  
  // Get all draft
  @override
  Future<List<PostModel>> getAllDraft({required String doctorId}) async {
    return await firestoreService!.collectionSnapshot(
      path: FirestorePath.posts(), 
      builder: ((data, documentID) => PostModel.fromJson(data, documentID)),
      queryBuilder: (query) {
        List<Query<Map<String, dynamic>>> queryList = [];
        queryList.add(query.where("isPublished", isEqualTo: false));
        queryList.add(queryList.last.where("doctorId", isEqualTo: doctorId));
        return queryList.last;
      },
    );
  }
  
  // Get private post
  @override
  Future<List<PostModel>> getAllPostByAndForMe({String? doctorId, String? userId, bool? isPrivate}) async {
    return await firestoreService!.collectionSnapshot(
      path: FirestorePath.posts(), 
      builder: ((data, documentID) => PostModel.fromJson(data, documentID)),
      queryBuilder: (query) {
        List<Query<Map<String, dynamic>>> queryList = [];
        queryList.add(query.where("isPublished", isEqualTo: true));
        if(isPrivate != null){
          queryList.add(queryList.last.where("isPrivate", isEqualTo: isPrivate));
        }
        if(doctorId != null){
          queryList.add(queryList.last.where("doctorId", isEqualTo: doctorId));
        }
        if(userId != null){
          queryList.add(queryList.last.where("destinationUid", isEqualTo: userId));
        }
        return queryList.last;
        }
      );
  }
  
  @override
  Future<List<PostModel>> getAllSaved({required String userId}) async{
    return await firestoreService!.collectionSnapshot(
      path: FirestorePath.posts(), 
      builder: ((data, documentID) => PostModel.fromJson(data, documentID)),
      queryBuilder: (query) {
        List<Query<Map<String, dynamic>>> queryList = [];
        queryList.add(query.where("isPublished", isEqualTo: true));
        queryList.add(queryList.last.where("isPrivate", isEqualTo: false));
        queryList.add(queryList.last.where("userIdLikes", arrayContains: userId));
        return queryList.last;
        }
      );
  }
  
  @override
  Future<int> getUserPostCount({required String uid}) async{
    var postList = await firestoreService!.collectionSnapshot(
      path: FirestorePath.posts(), 
      builder: ((data, documentID) => PostModel.fromJson(data, documentID)),
      queryBuilder: (query) {
        List<Query<Map<String, dynamic>>> queryList = [];
        queryList.add(query.where("doctorId", isEqualTo: uid));
        queryList.add(queryList.last.where("isPublished", isEqualTo: true));
        return queryList.last;
        }
      );
    return postList.length;
  }

  

  @override
  Future<PostModel> addLike({required String postId, required String userId}) async{
    var currentPost = await getByPostId(postId: postId);
    currentPost.userIdLikes ??= [];
    currentPost.userIdLikes!.add(userId);
    await setPost(post: currentPost, merge: true);

    return currentPost;
  }
  
  @override
  Future<PostModel> removeLike({required String postId, required String userId}) async{
    var currentPost = await getByPostId(postId: postId);
    currentPost.userIdLikes ??= [];
    currentPost.userIdLikes!.remove(userId);
    await setPost(post: currentPost, merge: true);

    return currentPost;
  }
  
  @override
  Future<bool> reedemCode({required String userId, required String reedemCode}) async {
    var currentPostList = await firestoreService!.collectionSnapshot(
      path: FirestorePath.posts(), 
      builder: ((data, documentID) => PostModel.fromJson(data, documentID)),
      queryBuilder: (query) {
        List<Query<Map<String, dynamic>>> queryList = [];
        queryList.add(query.where("reedemableCode", isEqualTo: reedemCode));

        return queryList.last;
      },
    );
    if (currentPostList.isEmpty) {
      return false;
    } else {
      var currentPost = currentPostList.first;
      currentPost.destinationUid = userId;
      await setPost(post: currentPost, merge: true);
    }

    return true;
  }

  @override
  Future<bool> clonePost({required PostModel post}) async{
    try {
      String newPid = firestoreId();
      if(post.mainImage != null){
        post.mainImage = await clonePostMainImage(post.doctorId, post.pid, newPid);
      }
      
      post.section = await getSectionsByPostId(postId: post.pid);
      if(post.section!= null){
        for (var section in post.section!) {
          if (section.sectionMediaList != null) {
            for (var sectionMedia in section.sectionMediaList!) {
              if(sectionMedia.mediaType == InputCreateType.audio || sectionMedia.mediaType == InputCreateType.image || sectionMedia.mediaType == InputCreateType.video){
                sectionMedia.mediaContent = await clonePostSectionMedia(doctorId: post.doctorId,postId: post.pid, sectionId: section.sid, newPostId: newPid, sectionMedia: sectionMedia);
              }
            }
          }
        }
      }
      
      post.isPublished = false;
      post.destinationUid = null;
      post.reedemableCode = null;
      post.userIdLikes = null;
      post.pid = newPid;
      await setPost(post: post);
      return true;
    // ignore: unused_catch_clause
    } on Exception catch (e) {
      return false;
    }
  }

  Future<String> clonePostMainImage(String doctorId, String postId, String newPostId) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference refCover = storage.ref("$doctorId/posts/$postId/mainImage");
    Uint8List? oldRef = await refCover.getData();

    var metaData = await refCover.getMetadata();
    String mediaContentType = metaData.contentType ?? "";
    Reference newRefCover = storage.ref("$doctorId/posts/$newPostId/mainImage");
    UploadTask task = newRefCover.putData(oldRef!, SettableMetadata(contentType: mediaContentType));
    await task;

    var storageUrl = await FirebaseStorage.instance
          .ref()
          .child("$doctorId/posts/$newPostId/mainImage")
          .getDownloadURL();

    return storageUrl;
  }

  Future<String> clonePostSectionMedia({required String doctorId,required String postId,required String sectionId,required String newPostId,required SectionMediaModel sectionMedia}) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference refCover = storage.ref("$doctorId/posts/$postId/sections/$sectionId/${sectionMedia.mediaType.name}/${sectionMedia.mediaName}");
    Uint8List? oldRef = await refCover.getData();
    String mediaContentType = getExtention(sectionMedia.mediaName ?? "", sectionMedia.mediaType);
   

    Reference newRefCover = storage.ref("$doctorId/posts/$newPostId/sections/$sectionId/${sectionMedia.mediaType.name}/${sectionMedia.mediaName}");
    UploadTask task = newRefCover.putData(oldRef!, SettableMetadata(contentType: mediaContentType));
    await task;

    var storageUrl = await FirebaseStorage.instance
          .ref()
          .child("$doctorId/posts/$newPostId/sections/$sectionId/${sectionMedia.mediaType.name}/${sectionMedia.mediaName}")
          .getDownloadURL();

    return storageUrl;
  }

}