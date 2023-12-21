import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Zdieľanie súborov"),
        ),
        body: const BottomSheetModal(),
      ),
    );
  }
}

class BottomSheetModal extends StatefulWidget {
  const BottomSheetModal({Key? key}) : super(key: key);

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? list;
  List<FileInfo>? fileInfoList = [];

  @override
  void initState() {
    initSharingListener();

    super.initState();
  }

  initSharingListener() {
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      setState(() {
        list = value;
      });
      for (var file in value) {
        printFileDetails(file.value ?? "");
      }
      print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
    }, onError: (err) {
      print("Shared: getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      print(
          "Shared: getInitialMedia => ${value.map((f) => f.value).join(",")}");
      setState(() {
        list = value;
      });
      for (var file in value) {
        printFileDetails(file.value ?? "");
      }
    });
  }

  Future<int?> getFileSize(String? filePath) async {
    try {
      if (filePath == null) {
        return null;
      }

      File file = File(filePath);
      int sizeInBytes = await file.length();

      int sizeInMB = (sizeInBytes / (1024 * 1024)).ceil();

      return sizeInMB;
    } catch (e) {
      print("Error getting file size: $e");
      return null;
    }
  }

  String? getFileName(String? filePath) {
    if (filePath == null) {
      return null;
    }

    List<String> pathSegments = filePath.split('/');
    return pathSegments.isNotEmpty ? pathSegments.last : null;
  }

  void printFileDetails(String filePath) async {
    String fileName = getFileName(filePath) ?? '';
    int? fileSize = await getFileSize(filePath);

    setState(() {
      fileInfoList = [
        ...?fileInfoList,
        FileInfo(filePath, fileName, fileSize),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Otvoriť modál'),
        onPressed: () {
          showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return _buildBottomSheetContent(context);
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomSheetContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildTopRow(),
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildSection("Workspace", "OP"),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildSection("Destination", "..."),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: _buildFileSection(),
                ),
              ],
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 24,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
         */
        Text(
          "Zdieľajte v spokostave",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String value) {
    // Tu bude v spoku použitý náš multiselect
    return Column(
      children: [
        _buildSectionTitle(title),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios),
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFileSection() {
    // Tu bude názov zdieľaného súboru
    return Column(children: [
      const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Názov súboru: ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
      const SizedBox(
        height: 14,
      ),
      for (var fileInfo in fileInfoList!)
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${fileInfo.fileName ?? ''}, ${fileInfo.fileSize ?? ''} MB',
              style: const TextStyle(fontSize: 20),
            )),
    ]);
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}

class FileInfo {
  final String filePath;
  final String? fileName;
  final int? fileSize;

  FileInfo(this.filePath, this.fileName, this.fileSize);
}
