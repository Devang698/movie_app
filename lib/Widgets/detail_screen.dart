import 'package:movie_app/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieDetail extends StatefulWidget {
  final imageUrl;
  final title;
  final releaseDate;
  final overView;
   MovieDetail({this.imageUrl,this.title,this.releaseDate,this.overView});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Global.default_color.value,
        elevation: 0,
        title: Text(
          "Back",
          style: TextStyle(
            color:Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body:SafeArea(
        child: Container(
          width:MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Image.network(
                widget.imageUrl,
                width:MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Global.text_color.value.withOpacity(0.5),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(widget.title.toString(), style: TextStyle(fontSize: 28,color:Colors.white)),
                      SizedBox(height:5),
                      Text(DateFormat("MMMM dd,yyyy").format(DateTime.parse(widget.releaseDate)), style: TextStyle(fontSize:16,color:Colors.white)),
                      SizedBox(height:10),
                      Flexible(//newly added
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                            child: Text(
                                widget.overView,
                                style: TextStyle(color:Colors.white),
                                softWrap: true
                            ),
                          )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
