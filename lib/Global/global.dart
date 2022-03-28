import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Global  extends GetxController {
  static Rx<MaterialColor> default_color =  Colors.amber.obs;
  static Rx<Color> text_color =  Colors.black.obs;
  static Rx<Color> grey_color =  Colors.grey.obs;
  static Color default_textColor = Colors.black;
}