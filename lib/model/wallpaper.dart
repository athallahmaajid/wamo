import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
part 'wallpaper.g.dart';

@HiveType(typeId: 1)
class WallpaperImage {
  @HiveField(0)
  String url;
  WallpaperImage(this.url);

  static Future<List<WallpaperImage>> searchWallpaper({required String query, int page = 1}) async {
    var response =
        await http.get(Uri.parse("http://maajid-wallpaper-api.deta.dev/wallpapers/search?query=$query&mobile=true&page=${page.toString()}"));
    var jsonObject = json.decode(response.body)["result"] as List;
    return jsonObject.map((item) => WallpaperImage(item)).toList();
  }

  static Future<List<WallpaperImage>> getWallpaper(int page) async {
    var response = await http.get(Uri.parse("http://maajid-wallpaper-api.deta.dev/wallpapers?mobile=true&page=$page"));
    var jsonObject = json.decode(response.body)["result"] as List;
    return jsonObject.map((item) => WallpaperImage(item)).toList();
  }
}
