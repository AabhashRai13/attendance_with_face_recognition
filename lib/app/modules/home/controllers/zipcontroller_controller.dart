import 'package:get/get.dart';
import 'dart:io';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';

class ZipControllerController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }



  final appDataDir = Directory.systemTemp;

  static const _dataFilesBaseDirectoryName = "store";
  final dataFiles = {
    "image_picker6046590957484809829.jpg": "abc",
    "file2.txt": "åäö",
    "subdir1/file3.txt": r"@_£$",
    "subdir1/subdir11/file4.txt": "123",
  };

  Future test({List imageList}) async {
    print("Start test");

    // test createFromFiles
    // case 1
    var  zipFile = await testZipFiles(includeBaseDirectory: false,imageList: imageList);
    await _testUnzip(zipFile, zipIncludesBaseDirectory: false);
    // case 2
    zipFile = await testZipFiles(includeBaseDirectory: true, imageList: imageList);
    await _testUnzip(zipFile, zipIncludesBaseDirectory: true);

    print("DONE!");
  }



  Future<File> testZipFiles({ bool includeBaseDirectory,List imageList  }) async {
    print("_appDataDir=${appDataDir.path}");
    final storeDir =
    Directory("/data/user/0/com.aabhash.attendance_project/app_flutter");

    final testFiles = await createTestFiles( imageList);

    final zipFile = _createZipFile("testZipFiles.zip");
    print("Writing files to zip file: ${zipFile.path}");

    try {
      await ZipFile.createFromFiles(
          sourceDir: storeDir,
          files: testFiles,
          zipFile: zipFile,
          includeBaseDirectory: includeBaseDirectory);
    } on PlatformException catch (e) {
      print(e);
    }
    return zipFile;
  }

  Future _testUnzip(File zipFile,
      {bool progress = false, bool zipIncludesBaseDirectory = false}) async {
    print("_appDataDir=${appDataDir.path}");

    final destinationDir = Directory("${appDataDir.path}/unzip");
    final destinationDir2 = Directory("${appDataDir.path}/unzip2");

    if (destinationDir.existsSync()) {
      print("Deleting existing unzip directory: ${destinationDir.path}");
      destinationDir.deleteSync(recursive: true);
    }
    if (destinationDir2.existsSync()) {
      print("Deleting existing unzip directory: ${destinationDir2.path}");
      destinationDir2.deleteSync(recursive: true);
    }

    print("Extracting zip to directory: ${destinationDir.path}");
    destinationDir.createSync();
    // test concurrent extraction
    final extractFutures = <Future>[];
    int onExtractingCallCount1 = 0;
    int onExtractingCallCount2 = 0;
    try {
      extractFutures.add(ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir,
          onExtracting: progress
              ? (zipEntry, progress) {
            ++onExtractingCallCount1;
            print('Extract #1:');
            print('progress: ${progress.toStringAsFixed(1)}%');
            print('name: ${zipEntry.name}');
            print('isDirectory: ${zipEntry.isDirectory}');
            print(
                'modificationDate: ${zipEntry.modificationDate.toLocal().toIso8601String()}');
            print('uncompressedSize: ${zipEntry.uncompressedSize}');
            print('compressedSize: ${zipEntry.compressedSize}');
            print('compressionMethod: ${zipEntry.compressionMethod}');
            print('crc: ${zipEntry.crc}');
            return ZipFileOperation.includeItem;
          }
              : null));

      extractFutures.add(ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir2,
          onExtracting: progress
              ? (zipEntry, progress) {
            ++onExtractingCallCount2;
            print('Extract #2:');
            print('progress: ${progress.toStringAsFixed(1)}%');
            print('name: ${zipEntry.name}');
            print('isDirectory: ${zipEntry.isDirectory}');
            print(
                'modificationDate: ${zipEntry.modificationDate.toLocal().toIso8601String()}');
            print('uncompressedSize: ${zipEntry.uncompressedSize}');
            print('compressedSize: ${zipEntry.compressedSize}');
            print('compressionMethod: ${zipEntry.compressionMethod}');
            print('crc: ${zipEntry.crc}');
            return ZipFileOperation.includeItem;
          }
              : null));

      await Future.wait<void>(extractFutures);
      assert(onExtractingCallCount1 == onExtractingCallCount2);
      assert(!progress || onExtractingCallCount1 > 0);
    } on PlatformException catch (e) {
      print(e);
    }

    // verify unzipped files
    if (zipIncludesBaseDirectory) {
      _verifyFiles(
          Directory("${destinationDir.path}/$_dataFilesBaseDirectoryName"));
      _verifyFiles(
          Directory("${destinationDir2.path}/$_dataFilesBaseDirectoryName"));
    } else {
      _verifyFiles(destinationDir);
      _verifyFiles(destinationDir2);
    }
  }

  File _createZipFile(String fileName) {
    final zipFilePath = "$fileName";
    final zipFile = File(zipFilePath);

    if (zipFile.existsSync()) {
      print("Deleting existing zip file: ${zipFile.path}");
      zipFile.deleteSync();
    }
    return zipFile;
  }

 Future< List<File>> createTestFiles( List imageList) async {
    // if (storeDir.existsSync()) {
    //   storeDir.deleteSync(recursive: true);
    // }
    // storeDir.createSync();
    final files = <File>[];
    // for (final fileName in dataFiles.keys) {
    //   print("key ${dataFiles.keys}");
    //   final file = File("${storeDir.path}/$fileName");
    //   print("file $file");
    //   file.createSync(recursive: true);
    //   // print("Writing file: ${file.path}");
    //   file.writeAsStringSync(dataFiles[fileName]);
    //   files.add(file);
    
    // }
    for (int  i=0; i<imageList.length; i++) {

      final file = File("${imageList[i]}");
      print("file $file");
      // file.createSync(recursive: true);
      // // print("Writing file: ${file.path}");
      // file.writeAsStringSync(dataFiles[{imageList[i]}]);
      files.add(file);

    }
    print('files $files');
    // verify created files
   // _verifyFiles(storeDir);

    return files;
  }

  void _verifyFiles(Directory filesDir) {
    print("Verifying files at: ${filesDir.path}");
    final extractedItems = filesDir.listSync(recursive: true);
    for (final item in extractedItems) {
      print("extractedItem: ${item.path}");
    }
    print("File count: ${extractedItems.length}");
    assert(extractedItems.whereType<File>().length == dataFiles.length,
    "Invalid number of files");
    for (final fileName in dataFiles.keys) {
      final file = File('${filesDir.path}/$fileName');
      print("Verifying file: ${file.path}");
      assert(file.existsSync(), "File not found: ${file.path}");
      final content = file.readAsStringSync();
      assert(content == dataFiles[fileName],
      "Invalid file content: ${file.path}");
    }
    print("All files ok");
  }

  @override
  void onClose() {}
  
}
