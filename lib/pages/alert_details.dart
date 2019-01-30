import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wedetect/models/alert.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlertDetailsPage extends StatefulWidget {
  final Alert alert;
  const AlertDetailsPage({Key key, this.alert}) : super(key: key);

  _AlertDetailsPageState createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {
  @override
  void initState() {
    print(widget.alert.title);
    print(widget.alert.pieces.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Stack(children: <Widget>[
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                return new CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.alert.pieces[index].piece,
                    placeholder:
                        Center(child: new CircularProgressIndicator()));
              },
              itemCount: widget.alert.pieces.length,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
            Positioned(
              top: 350.0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 450.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Material(
                    elevation: 8.0,
                    animationDuration: Duration(seconds: 5),
                    borderRadius: BorderRadius.circular(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: CachedNetworkImage(
                            height: 50.0,
                            width: 50.0,
                            imageUrl: widget.alert.category.icone,
                            placeholder:
                                Center(child: new CircularProgressIndicator()),
                          ),
                          title: Text(widget.alert.title),
                          subtitle: Text(widget.alert.category.name),
                        ),
                        Text(widget.alert.content),
                        Container(
                          height: 100.0,
                          child: ListView.builder(
                            itemExtent: 65.0,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.alert.receivers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    height: 30.0,
                                    width: 30.0,
                                    imageUrl:
                                        widget.alert.receivers[index].photo,
                                    placeholder: Center(
                                        child: new CircularProgressIndicator()),
                                  ),
                                  Text(
                                    widget.alert.receivers[index].user.lastname,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )),
            )
          ]),
        ],
      ),
    );
  }
}
