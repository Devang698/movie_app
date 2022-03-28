import 'package:movie_app/Controller/now_playing_controller.dart';
import 'package:movie_app/Controller/top_rated_controller.dart';
import 'package:movie_app/Global/global.dart';
import 'package:movie_app/Widgets/top_rated_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'now_playing_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Now_Playing_Controller now_playing_controller = Get.put(Now_Playing_Controller());
  final Top_Rated_Controller top_rated_controller = Get.put(Top_Rated_Controller());

  @override
  void initState() {
    now_playing_controller.fetchCasts();
    top_rated_controller.fetchTopCasts();
    // TODO: implement initState
    super.initState();
  }


  Widget build(BuildContext context) {
    return Obx(() {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Global.default_color.value,
            bottomNavigationBar: menu(),
            body: TabBarView(
              children: [
                Now_Playing_Screen(),
                Top_Rated_Screen(),
              ],
            ),
          ),
        ));
    });
  }

  Widget menu() {
    return Container(
      color: Global.default_color.value,
      child: TabBar(
        labelColor: Global.text_color.value,
        unselectedLabelColor:Colors.grey.shade700,
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(
            text: "Now Playing",
            icon: Icon(Icons.movie),
          ),
          Tab(
            text: "Top Rated",
            icon: Icon(Icons.star_border),
          )
        ],
      ),
    );}
}
