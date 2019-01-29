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
                  imageUrl: widget.alert.pieces[index].piece,
                  placeholder: Center(child: new CircularProgressIndicator()),
                  fit: BoxFit.cover,
                );
              },
              itemCount: widget.alert.pieces.length,
              itemHeight: 90.0,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
            Positioned(
              top: 550.0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 450.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Material(
                    child: ListTile(
                      leading: CachedNetworkImage(
                        height: 50.0,
                        width: 50.0,
                        imageUrl: widget.alert.category.icone,
                        placeholder:
                            Center(child: new CircularProgressIndicator()),
                      ),
                      title: Text(widget.alert.title),
                      subtitle: Text(widget.alert.content),
                    ),
                  )),
            )
          ]),
        ],
      ),
    );
  }
}
