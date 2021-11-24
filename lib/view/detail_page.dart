import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';

class DetailPage extends StatefulWidget {
  final String url;
  final String tag;

  DetailPage({Key? key, required this.url, required this.tag}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Stream<String>? progressString;
  String? res;
  bool downloading = false;
  String home = "Home Screen", lock = "Lock Screen", both = "Both Screen", system = "System";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              Hero(tag: widget.tag, child: Image.network(widget.url)),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.07,
                left: MediaQuery.of(context).size.width * 0.06,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 3, 0, 3),
                    child: const Icon(
                      Icons.arrow_back_ios,
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
              Dialog(),
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
                      print("DataReceived: " + data);
                    }, onDone: () async {
                      lock = await Wallpaper.homeScreen();
                      setState(() {
                        downloading = false;
                        lock = lock;
                      });
                      print("Task Done");
                    }, onError: (error) {
                      setState(() {
                        downloading = false;
                      });
                      print("Some Error");
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wallpaper_outlined,
                        size: 32,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      Text("Set as Wallpaper", style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_outlined,
                      size: 32,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    Text("Download", style: Theme.of(context).textTheme.bodyText1),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget Dialog() {
    return Positioned(
      top: 200,
      left: 70,
      child: downloading
          ? Container(
              height: 120.0,
              width: 200.0,
              child: Card(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text(
                      "Downloading File : $res",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          : Text(""),
    );
  }
}
