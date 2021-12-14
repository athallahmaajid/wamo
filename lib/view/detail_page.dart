import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wamo/model/wallpaper.dart';

class DetailPage extends StatefulWidget {
  final String url;
  final String tag;
  String source;

  DetailPage({Key? key, required this.url, required this.tag, this.source = ""}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;
  Stream<String>? progressString;
  String? res;
  bool downloading = false;
  String home = "Home Screen", lock = "Lock Screen", both = "Both Screen", system = "System";

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    Hive.openBox("wallpaperimages");
    var wallpaperBox = Hive.box("wallpaperimages");

    if (wallpaperBox.containsKey(widget.url)) {
      isFavorite = true;
    }

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // ignore: unused_local_variable
      String id = data[0];
      // ignore: unused_local_variable
      DownloadTaskStatus status = data[1];
      // ignore: unused_local_variable
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: widget.tag,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.07,
                left: MediaQuery.of(context).size.width * 0.06,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 7, 5),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 32,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              (widget.source != "")
                  ? Positioned(
                      bottom: 10,
                      right: 10,
                      child: Text(
                        "Powered By ${widget.source}",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  : Container(),
              dialog(),
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    progressString = Wallpaper.ImageDownloadProgress(widget.url);
                    progressString!.listen((data) {
                      setState(() {
                        res = data;
                        downloading = true;
                      });
                    }, onDone: () async {
                      lock = await Wallpaper.homeScreen();
                      setState(() {
                        downloading = false;
                        lock = lock;
                      });
                    }, onError: (error) {
                      setState(() {
                        downloading = false;
                      });
                    });
                  },
                  child: Icon(
                    Icons.wallpaper_outlined,
                    size: 32,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var status = await Permission.storage.request();
                    if (status.isGranted) {
                      String fileName = widget.url.replaceAll("https://images.wallpaperscraft.com/image/single/", "");
                      // ignore: unused_local_variable
                      final taskId = await FlutterDownloader.enqueue(
                        fileName: fileName,
                        url: widget.url,
                        savedDir: '/storage/emulated/0/Download/',
                        showNotification: true, // show download progress in status bar (for Android)
                        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => const Dialog(
                          child: Text("Please grant the permission"),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.download,
                    size: 32,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    var wallpaperBox = Hive.box("wallpaperimages");
                    if (isFavorite) {
                      wallpaperBox.put(widget.url, WallpaperImage(widget.url));
                    } else {
                      wallpaperBox.delete(widget.url);
                    }
                  },
                  child: (isFavorite)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.pink,
                        )
                      : Icon(
                          Icons.favorite_border_outlined,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget dialog() {
    return Positioned(
      top: 220,
      left: 70,
      child: downloading
          ? SizedBox(
              height: 100.0,
              width: 220.0,
              child: Card(
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LinearProgressIndicator(
                        value: double.parse(res!.replaceAll("%", "")),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Downloading File : $res",
                        style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Text(""),
    );
  }
}
