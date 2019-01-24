import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedetect/bloc/authentication/authentication.dart';
import 'package:wedetect/bloc/login/login.dart';
import 'package:wedetect/models/alert.dart';
import 'package:wedetect/repository/alert_repository.dart';
import 'package:wedetect/repository/user_repository.dart';

class DashBoardPage extends StatefulWidget {
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  LoginBloc loginBloc;
  AuthenticationBloc authenticationBloc;
  AlertRepository alertRepository;
  List<Alert> alerts = [];
  ScrollController _scrollcontroller = new ScrollController();
  Icon _searchIcon = new Icon(Icons.search);

  @override
  void initState() {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    alertRepository = AlertRepository();
    loginBloc = LoginBloc(
        userRepository: UserRepository(),
        authenticationBloc: authenticationBloc);

    _scrollcontroller.addListener(() {
      print(_scrollcontroller.position.pixels);
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        alertRepository.getAlerts(url: alertRepository.next);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      bloc: loginBloc,
      child: Scaffold(
       
        drawer: new Drawer(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text("Profil"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Parametres"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.close),
                    title: Text("Quitter"),
                    onTap: () {},
                  ),
                  MaterialButton(
                    minWidth: 250.0,
                    color: Colors.blue,
                    elevation: 15.0,
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      loginBloc.dispatch(LogoutButtonPressed());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background:Image.network('https://wallpapershome.com/images/pages/pic_h/1160.jpg',fit: BoxFit.cover),
                title: Text('Alerts List'),
              ),
            ),
            SliverFillRemaining(
              child: listAlerts(),
            )
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () => exit(0),
          tooltip: 'Close app',
          child: new Icon(Icons.close),
        ),
      ),
    );
  }

  Widget listAlerts() {
    return StreamBuilder(
        initialData: alerts,
        stream: alertRepository.next == null
            ? alertRepository.getAlerts().asStream()
            : alertRepository.getAlerts(url: alertRepository.next).asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
                itemExtent: 100.0,
                itemCount: snapshot.data.length,
                controller: _scrollcontroller,
                itemBuilder: (BuildContext ctx, int index) {
                  return ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].contenu),
                    onTap: () {
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(snapshot.data[index].title),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(snapshot.data[index].contenu),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    loginBloc.dispose();
    authenticationBloc.dispose();
    super.dispose();
  }
}
