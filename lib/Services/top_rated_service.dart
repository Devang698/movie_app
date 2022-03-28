import 'dart:convert';
import 'package:movie_app/Model/top_rated_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/get_state_manager.dart';

class Top_Rated_Service {
  static var client = http.Client();

  static Future<List<Results>?> fetch_top_rated() async {
    var response = await client.get(Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"));
    if (response.statusCode == 200) {
      var json = response.body;
      var topplayingResp = topratedFromJson(json);
      return topplayingResp.results;
    } else {
      return null;
    }
  }

}