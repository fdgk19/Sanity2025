import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/enum.dart';

DateTime? convertTimeStampToDateTime(dynamic dateFromFirestore) {
  if (dateFromFirestore == null) {
    return null;
  } else {
    var converted = dateFromFirestore as Timestamp;
    return converted.toDate();
  }
}

const textInputDecoration = InputDecoration(
  border: InputBorder.none,
  contentPadding: EdgeInsets.only(bottom: 8, left: 10),
);

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String firestoreId() => getRandomString(28);

List<String> imageExtSupported = ["jpg", "jpeg", "png"];
List<String> videoExtSupported = ["mp4", "mov"];
List<String> audioExtSupported = ["mp3", "mpeg"];
List<String> documentExtSupported = ['pdf'];

String getExtention(String name, InputCreateType type){
  var subs = name.split('.');
  var ext = subs.last;
  switch (type) {
    case InputCreateType.image:
      if (imageExtSupported.contains(ext)) {
        return "image/$ext"; 
      }
      break;
    case InputCreateType.video:
      if (videoExtSupported.contains(ext)) {
        return "video/$ext";
      }
      break;
    case InputCreateType.audio:
      if (audioExtSupported.contains(ext)) {
        return "audio/$ext";
      }
      break;
    case InputCreateType.url:
      if (documentExtSupported.contains(ext)) {
        return "application/$ext";
      }
      break;
    default:
  }
  
  return ext;
}

Future<PlatformFile?> fileFromStorage(List<String> extension) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extension
      );

    if (result != null) {
      PlatformFile file = result.files.first;
      if(extension == imageExtSupported && file.size > (1048 * 1048)){
        return null;
      } else if (extension == videoExtSupported && file.size > (1048 * 1048 * 100)){
        return null;
      } else if (extension == audioExtSupported && file.size > (1048 * 1048 * 1000) ){
        return null;
      } else if (extension == documentExtSupported && file.size > (1048 * 1048)) {
        return null;
      }
      return file;
    } else {
      return null;
    }
  }

Future<void> showerrortoast(String text, context) async {
    var fToast = FToast();
    fToast.init(context);
    fToast.removeCustomToast();
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red,
      ),
      child: Text(
       text,
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 5),
    );
}

Future<PlatformFile?> cropImage(BuildContext context, DeviceScreenType screenType, String? uploadedBlobUrl, String? name) async {
    if (uploadedBlobUrl != null) {
      WebUiSettings settings;
      if (screenType == DeviceScreenType.mobile) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        settings = WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.page,
          boundary: CroppieBoundary(
            width: (screenWidth * 0.9).round(),
            height: (screenHeight * 0.8).round(),
          ),
          viewPort: const CroppieViewPort(
            width: 480,
            height: 480,
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
          enableResize: true
        );
      } else {
          final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        settings = WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.page,
          boundary:  CroppieBoundary(
              width: (screenWidth * 0.9).round(),
            height: (screenHeight * 0.8).round(),
          ),
          viewPort: const CroppieViewPort(
            width: 480,
            height: 480,
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
          enableResize: true
        );
      }
      final croppedFile = await ImageCropper().cropImage(
        maxWidth: 300,
        maxHeight: 480,
        sourcePath: uploadedBlobUrl,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [settings],
      );
      if (croppedFile != null) {
        var fileAsByte = await croppedFile.readAsBytes();
        return PlatformFile( name: name ?? "franco.png", size: fileAsByte.length, bytes: fileAsByte);
      }
    }
    return null;
  }

  Future<PlatformFile?> uploadImage(BuildContext context, DeviceScreenType screenType,) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null ) {
      final blobUrl = pickedFile.path;
      debugPrint('picked blob: $blobUrl');
      // ignore: use_build_context_synchronously
      return await cropImage(context, screenType, blobUrl, pickedFile.name); 
    } return null;
  }

  String formattedDate(DateTime inputDate) {
    final DateTime now = inputDate;
    final DateFormat formatter = DateFormat('dd-MM-yyyy, HH:mm', 'it_IT');
    final String formatted = formatter.format(now);
    return formatted;
  }