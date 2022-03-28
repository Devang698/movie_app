import 'package:movie_app/Controller/top_rated_controller.dart';
import 'package:movie_app/Global/global.dart';
import 'package:movie_app/Model/now_playing_model.dart';
import 'package:movie_app/Widgets/detail_screen.dart';
import 'package:movie_app/Widgets/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Controller/now_playing_controller.dart';

class Now_Playing_Screen extends StatefulWidget {
  const Now_Playing_Screen({Key? key}) : super(key: key);

  @override
  _Now_Playing_ScreenState createState() => _Now_Playing_ScreenState();
}

class _Now_Playing_ScreenState extends State<Now_Playing_Screen> {
  final Now_Playing_Controller now_playing_controller = Get.put(Now_Playing_Controller());
  final Top_Rated_Controller top_rated_controller =
  Get.put(Top_Rated_Controller());
  Rx<List<Results>> searchResult = Rx<List<Results>>([]);

  void filter_from_nowplaying(String title) {
    List<Results> results = [];
    if (title.isEmpty) {
      results = now_playing_controller.now_playing;
    } else {
      results = now_playing_controller.now_playing
          .where((element) => element.title
          .toString()
          .toLowerCase()
          .contains(title.toLowerCase()))
          .toList();
    }
    searchResult.value = results;
  }
  Widget appBarTitle = new Text("Search by title",style:TextStyle(color:Global.default_textColor),);
  Icon actionIcon = new Icon(Icons.search,color:Global.default_textColor);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (now_playing_controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        if(now_playing_controller.isInternet_on == true)
          {
            return Scaffold(
              backgroundColor:Global.default_color.value,
              appBar: new AppBar(
                  centerTitle: true,
                  title:appBarTitle,
                  backgroundColor:Colors.white,
                  leading:GestureDetector(
                      onTap: (){
                          if(Global.default_color.value == Colors.amber)
                            {
                              Global.default_color(Colors.grey);
                              Global.text_color(Colors.white);
                            }else{
                            Global.default_color(Colors.amber);
                            Global.text_color(Colors.black);
                          }
                      },
                      child: Icon(Icons.dark_mode_sharp,color:Global.default_textColor,size:30)),
                  actions: <Widget>[
                    new IconButton(icon: actionIcon,onPressed:(){
                      setState(() {
                        if ( this.actionIcon.icon == Icons.search){
                          this.actionIcon = new Icon(Icons.close,color:Global.default_textColor);
                          this.appBarTitle = new TextField(
                            style: new TextStyle(
                              color: Global.default_textColor,
                            ),
                            onChanged: (value) {
                              filter_from_nowplaying(value);
                            },
                            decoration: new InputDecoration(
                                prefixIcon: new Icon(Icons.search,color: Global.default_textColor),
                                hintText: "Search...",
                                hintStyle: new TextStyle(color: Global.default_textColor)
                            ),
                          );}
                        else {
                          filter_from_nowplaying("");
                          this.actionIcon = new Icon(Icons.search,color:Global.default_textColor);
                          this.appBarTitle = new Text("AppBar Title",style:TextStyle(color:Global.default_textColor));
                        }
                      });
                    } ,),
                  ]
              ),
              body:searchResult.value.isEmpty ?
              ListView.builder(
                  itemCount:now_playing_controller.now_playing.length,
                  itemBuilder:(context,int i){
                    return  Dismissible(
                      key:UniqueKey(),
                      onDismissed: (direction) {
                        now_playing_controller.now_playing.removeAt(i);
                        now_playing_controller.refresh();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            duration: const Duration(milliseconds:100),
                            content: Text("Item Dismissed")));
                      },
                      background: Container(
                        color: Colors.red,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context){
                            return MovieDetail(
                              imageUrl:"https://image.tmdb.org/t/p/w342/"+now_playing_controller.now_playing[i].posterPath!,
                              title: now_playing_controller.now_playing[i].title,
                              releaseDate:now_playing_controller.now_playing[i].releaseDate,
                              overView:now_playing_controller.now_playing[i].overview,
                            );
                          }));
                        },
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:  EdgeInsets.all(0.0),
                                  child:  Container(
                                    margin:  EdgeInsets.all(16.0),
                                    child:Container(
                                      width:120.0,
                                      height:150.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Global.grey_color.value,
                                      image: DecorationImage(
                                          image: NetworkImage("https://image.tmdb.org/t/p/w342/"+now_playing_controller.now_playing[i].backdropPath!),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child:Container(
                                      child:Column(
                                        children: [
                                          Text(
                                            now_playing_controller.now_playing[i].originalTitle!,
                                            style:TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Global.text_color.value),
                                          ),
                                          Padding(padding: const EdgeInsets.all(2.0)),
                                          Text(
                                            now_playing_controller.now_playing[i].overview!,
                                            maxLines: 3,
                                            style:TextStyle(
                                                color:Global.text_color.value),
                                          )
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }):
              ListView.builder(
                  itemCount:searchResult.value.length,
                  itemBuilder:(context,int i){
                    return  GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context){
                          return MovieDetail(
                            imageUrl:"https://image.tmdb.org/t/p/w342/"+searchResult.value[i].posterPath!,
                            title: searchResult.value[i].title,
                            releaseDate:searchResult.value[i].releaseDate,
                            overView:searchResult.value[i].overview,
                          );
                        }));
                      },
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:  EdgeInsets.all(0.0),
                                child:  Container(
                                  margin:  EdgeInsets.all(16.0),
                                  child:Container(
                                    width:120.0,
                                    height:150.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Global.grey_color.value,
                                    image: DecorationImage(
                                        image: NetworkImage("https://image.tmdb.org/t/p/w342/"+searchResult.value[i].backdropPath!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child:Container(
                                    child:Column(
                                      children: [
                                        Text(
                                          searchResult.value[i].originalTitle!,
                                          style:TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Global.text_color.value),
                                        ),
                                        Padding(padding: const EdgeInsets.all(2.0)),
                                        Text(
                                          searchResult.value[i].overview!,
                                          maxLines: 3,
                                          style:TextStyle(
                                              color:Global.text_color.value),
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
                now_playing_controller.fetchCasts();
                top_rated_controller.fetchTopCasts();
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
