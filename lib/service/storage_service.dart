import 'package:firebase_storage/firebase_storage.dart';
import 'package:thrivebynightdev/main.dart';

class StorageService {
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  List<String> videoList = [];

  Future<List<CloudVideo>> getCloudVideos() async {
    late ListResult listResult;
    try {
      listResult = await storageRef.listAll();
    } on FirebaseException catch (e) {
      logger.d('Failed with error ${e.code}: ${e.message}');
    }
    List<CloudVideo> cloudVideoList = [];
    for (var item in listResult.items) {
      String videoUrl;
        logger.d('File: storage_service: - getCloudVideos: ${item.bucket} ${item.fullPath}');
      videoUrl = await item.getDownloadURL();
      cloudVideoList.add(CloudVideo(name: item.name, url: videoUrl));
    }
    return cloudVideoList;
  }

  Future<List<String>> getAllVideos() async {
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      String videoUrl;
      logger.d('getAllVideos: ${item.bucket} ${item.fullPath}');
      videoUrl = await item.getDownloadURL();
      videoList.add(videoUrl);
    }
    return videoList;
  }

  printListItems() async {
    logger.d('list item button pressed');
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      logger.d('Prefix: $prefix');    }
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

class CloudVideo {
  final String name;
  final String url;
  CloudVideo({required this.name, required this.url});
}
