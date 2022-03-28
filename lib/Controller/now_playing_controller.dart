import 'dart:io';

import 'package:movie_app/Model/now_playing_model.dart';
import 'package:movie_app/Services/now_playing_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';

class Now_Playing_Controller extends GetxController {
  var isLoading = true.obs;
  var isInternet_on = true.obs;
  var now_playing = <Results>[].obs;

  void fetchCasts() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isLoading(true);
        isInternet_on(true);
        var res = await Now_Playing_Service.fetchCastOfMovie();
        if (res != null) {
          now_playing.assignAll(res);
        }
      }
    } on SocketException catch (_) {
      isInternet_on(false);
      Fluttertoast.showToast(
          msg: "Please check your internet",  // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER,    // location
      );
    } finally {
      isLoading(false);
    }
  }
}