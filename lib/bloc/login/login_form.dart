import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedetect/bloc/authentication/authentication.dart';
import 'package:wedetect/bloc/login/login.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authBloc;

  LoginForm({
    Key key,
    @required this.loginBloc,
    @required this.authBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: widget.loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://wallpapershome.com/images/wallpapers/space-ship-1280x720-4k-hd-wallpaper-8k-matte-painting-art-transporter-258.jpg'),
                      fit: BoxFit.cover)),
            ),
            Positioned(
                top: 160.0,
                left: 15.0,
                right: 15.0,
                child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 3.0,
                    child: Container(
                        height: 250.0,
                        padding: EdgeInsets.all(15.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Column(children: <Widget>[
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _usernameController,
                            decoration: InputDecoration(hintText: 'username',border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)
                            ),labelText: 'Enter username'),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                        
                            decoration: InputDecoration(hintText: 'password',border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)
                            ),labelText: 'Enter password'),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          state is LoginInitial?
                          RaisedButton(
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blueAccent,
                            onPressed: () {
                              widget.loginBloc.dispatch(LoginButtonPressed(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              ));
                            },
                          ):Container(
                            child: CircularProgressIndicator(),
                          )
                        ]))))
          ],
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    widget.loginBloc.dispatch(LoginButtonPressed(
      username: _usernameController.text,
      password: _passwordController.text,
    ));
  }

  @override
    void dispose() {
      widget.loginBloc.dispose();
      super.dispose();
    }
}
