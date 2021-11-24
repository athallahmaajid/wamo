import 'package:http/http.dart' as http;
import 'dart:convert';

class WallpaperImage {
  String url;
  WallpaperImage(this.url);

  static Future<List<WallpaperImage>> searchWallpaper(query, page) async {
    var response = await http.get(Uri.parse("http://maajid-wallpaper-api.deta.dev/wallpapers/search?query=$query?mobile=true&page=$page"));
    var jsonObject = json.decode(response.body)["result"] as List;
    return jsonObject.map((item) => WallpaperImage(item["result"])).toList();
  }

  static Future<List<WallpaperImage>> getWallpaper(page) async {
    var response = await http.get(Uri.parse("http://maajid-wallpaper-api.deta.dev/wallpapers?mobile=true&page=$page"));
    var jsonObject = json.decode(response.body)["result"] as List;
    return jsonObject.map((item) => WallpaperImage(item)).toList();
  }
}
