import 'package:movie_app/Controller/now_playing_controller.dart';
import 'package:movie_app/Controller/top_rated_controller.dart';
import 'package:movie_app/Global/global.dart';
import 'package:movie_app/Model/top_rated_model.dart';
import 'package:movie_app/Widgets/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Top_Rated_Screen extends StatefulWidget {
  const Top_Rated_Screen({Key? key}) : super(key: key);

  @override
  _Top_Rated_ScreenState createState() => _Top_Rated_ScreenState();
}

class _Top_Rated_ScreenState extends State<Top_Rated_Screen> {
  final Top_Rated_Controller top_rated_controller =
      Get.put(Top_Rated_Controller());
  final Now_Playing_Controller now_playing_controller = Get.put(Now_Playing_Controller());
  Rx<List<Results>> searchResult = Rx<List<Results>>([]);

  void filter_from_toprated(String title) {
    List<Results> results = [];
    if (title.isEmpty) {
      results = top_rated_controller.top_playing;
    } else {
      results = top_rated_controller.top_playing
          .where((element) => element.title
              .toString()
              .toLowerCase()
              .contains(title.toLowerCase()))
          .toList();
    }
    searchResult.value = results;
  }

  Widget appBarTitle = new Text(
    "Search by title",
    style: TextStyle(color: Global.default_textColor),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Global.default_textColor,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (top_rated_controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        if(top_rated_controller.is_internet_on == true)
          {
            return Scaffold(
              backgroundColor: Global.default_color.value,
              appBar: new AppBar(
                  centerTitle: true,
                  title: appBarTitle,
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    new IconButton(
                      icon: actionIcon,
                      onPressed: () {
                        setState(() {
                          if (this.actionIcon.icon == Icons.search) {
                            this.actionIcon =
                            new Icon(Icons.close, color: Global.default_textColor);
                            this.appBarTitle = new TextField(
                              style: new TextStyle(
                                color: Global.default_textColor,
                              ),
                              onChanged: (value) {
                                filter_from_toprated(value);
                              },
                              decoration: new InputDecoration(
                                  prefixIcon:
                                  new Icon(Icons.search, color: Global.default_textColor),
                                  hintText: "Search...",
                                  hintStyle: new TextStyle(color: Global.default_textColor)),
                            );
                          } else {
                            filter_from_toprated("");
                            this.actionIcon =
                            new Icon(Icons.search, color: Global.default_textColor);
                            this.appBarTitle = new Text("AppBar Title",
                                style: TextStyle(color: Global.default_textColor));
                          }
                        });
                      },
                    ),
                  ]),
              body: searchResult.value.isEmpty
                  ? ListView.builder(
                  itemCount: top_rated_controller.top_playing.length,
                  itemBuilder: (context, int i) {
                    return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          top_rated_controller.top_playing.removeAt(i);
                          top_rated_controller.refresh();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 100),
                              content: Text("Item Dismissed")));
                        },
                        background: Container(
                          color: Colors.red,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return MovieDetail(
                                    imageUrl: "https://image.tmdb.org/t/p/w342/" +
                                        top_rated_controller
                                            .top_playing[i].posterPath!,
                                    title:
                                    top_rated_controller.top_playing[i].title,
                                    releaseDate: top_rated_controller
                                        .top_playing[i].releaseDate,
                                    overView: top_rated_controller
                                        .top_playing[i].overview,
                                  );
                                }));
                          },
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      margin: EdgeInsets.all(16.0),
//                                child: new Image.network(image_url+movies[i]['poster_path'],width: 100.0,height: 100.0),
                                      child: Container(
                                        width: 120.0,
                                        height: 150.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Global.grey_color.value,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://image.tmdb.org/t/p/w342/" +
                                                    top_rated_controller
                                                        .top_playing[i]
                                                        .backdropPath!),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              top_rated_controller
                                                  .top_playing[i].originalTitle!,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Global.text_color.value),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.all(2.0)),
                                            Text(
                                              top_rated_controller
                                                  .top_playing[i].overview!,
                                              maxLines: 3,
                                              style: TextStyle(color: Global.text_color.value),
                                            )
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ));
                  })
                  : ListView.builder(
                  itemCount: searchResult.value.length,
                  itemBuilder: (context, int i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return MovieDetail(
                                imageUrl: "https://image.tmdb.org/t/p/w342/" +
                                    searchResult.value[i].posterPath!,
                                title: searchResult.value[i].title,
                                releaseDate: searchResult.value[i].releaseDate,
                                overView: searchResult.value[i].overview,
                              );
                            }));
                      },
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
//                                child: new Image.network(image_url+movies[i]['poster_path'],width: 100.0,height: 100.0),
                                  child: Container(
                                    width: 120.0,
                                    height: 150.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Global.grey_color.value,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://image.tmdb.org/t/p/w342/" +
                                                searchResult
                                                    .value[i].backdropPath!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          searchResult.value[i].originalTitle!,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Global.text_color.value),
                                        ),
                                        Padding(padding: const EdgeInsets.all(2.0)),
                                        Text(
                                          searchResult.value[i].overview!,
                                          maxLines: 3,
                                          style: TextStyle(color: Global.text_color.value),
                                        )
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }else{
          return Center(
            child:FlatButton(
              minWidth:150,
              height:50,
              onPressed: () {
                top_rated_controller.fetchTopCasts();
                now_playing_controller.fetchCasts();
              },
              child: Text('Try Again',style:TextStyle(fontSize:18),),
              shape: StadiumBorder(),
              color: Colors.white,
              textColor: Global.text_color.value,
            ),
          );
        }
      }
    });
  }
}
