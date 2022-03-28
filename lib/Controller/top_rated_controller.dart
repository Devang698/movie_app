import 'dart:io';

import 'package:movie_app/Model/top_rated_model.dart';
import 'package:movie_app/Services/top_rated_service.dart';
import 'package:get/state_manager.dart';

class Top_Rated_Controller extends GetxController {
  var isLoading = true.obs;
  var is_internet_on = true.obs;
  var top_playing = <Results>[].obs;

  void fetchTopCasts() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isLoading(true);
        is_internet_on(true);
        var res = await Top_Rated_Service.fetch_top_rated();
        if (res != null) {
          top_playing.assignAll(res);
        }
      }
    } on SocketException catch (_) {
      is_internet_on(false);
      print('not connected');
    } finally {
      isLoading(false);
    }
  }
}