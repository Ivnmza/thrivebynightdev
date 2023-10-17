import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:thrivebynightdev/main.dart';

class StorageService {
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  final db = FirebaseFirestore.instance;

  testAddData() {
    // Create a new user with a first and last name
  
    final blogPost = <String, dynamic>{
      "title": "Alan",
      "url":
          "https://firebasestorage.googleapis.com/v0/b/thrivebynightdev-866d3.appspot.com/o/2023-03-03%2018-45-38.mov?alt=media&token=5e81f613-de01-4cf0-b7f7-19ddf1f8bc20&_gl=1*3qmznn*_ga*MTU3MzgzNzIwNi4xNjk1MjcxNjcw*_ga_CW55HF8NVT*MTY5NzI2MzczNi4xNi4xLjE2OTcyNjUwMzMuNTkuMC4w",
      "date": "Turing",
      "description": "1912",
      "content": "asdfasdfasfdsf"
    };

// Add a new document with a generated ID
    db.collection("blog").add(blogPost).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }




  Future<List<String>> getAllVideoURLs() async {
    final listResult = await storageRef.listAll();
    List<String> videoList = [];

    for (var item in listResult.items) {
      String videoUrl;
      logger.d('getAllVideos: ${item.bucket} ${item.fullPath}');
      videoUrl = await item.getDownloadURL();
      videoList.add(videoUrl);
    }
    return videoList;
  }

  Future<List<CloudVideo>> getCloudVideos() async {
    late ListResult listResult;
    List<CloudVideo> cloudVideoList = [];

    try {
      listResult = await storageRef.listAll();
    } on FirebaseException catch (e) {
      logger.d('Failed with error ${e.code}: ${e.message}');
    }
    for (var item in listResult.items) {
      String videoUrl;
      logger.d('file: ${item.bucket} ${item.fullPath}');
      videoUrl = await item.getDownloadURL();
      cloudVideoList.add(CloudVideo(name: item.name, url: videoUrl));
    }
    return cloudVideoList;
  }

  printListItems() async {
    logger.d('list item button pressed');
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      logger.d('Prefix: $prefix');
    }
    for (var item in listResult.items) {
      logger.d('${item.bucket} ${item.fullPath}');
    }
  }
/*
    Future<List<Module>> getAllModules() async {
    final isar = await db;
    return await isar.modules.where().findAll();
  }

//esasy
  Stream<List<Module>> listenToModules() async* {
    final isar = await db;
    yield* isar.modules.where().watch(fireImmediately: true);
  }
  */
}

class BlogPost {
  final String title;
  final String url;
  final DateTime date;
  final String description;
  final String content;
  BlogPost({required this.title, required this.url, required this.date, required this.description, required this.content});
}

class CloudVideo {
  final String name;
  final String url;
  CloudVideo({required this.name, required this.url});
}
