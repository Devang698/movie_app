import 'dart:convert';
import 'package:movie_app/Model/now_playing_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/get_state_manager.dart';

class Now_Playing_Service {
  static var client = http.Client();

  static Future<List<Results>?> fetchCastOfMovie() async {
    var response = await client.get(Uri.parse("https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"));
    if (response.statusCode == 200) {
      var json = response.body;
      var nowplayingResp = nowFromJson(json);
      return nowplayingResp.results;
    } else {
      return null;
    }
  }

}