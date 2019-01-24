import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:wedetect/bloc/authentication/authentication.dart';
import 'package:wedetect/bloc/login/login_page.dart';
import 'package:wedetect/pages/dashboard_page.dart';
import 'package:wedetect/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(userRepository: UserRepository()));
}

class App extends StatefulWidget {
  final UserRepository userRepository;
  const App({Key key, this.userRepository}) : super(key: key);
  // This widget is the root of your application.
  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  AuthenticationBloc _authenticationBloc;
  UserRepository _userRepository;

  @override
  void initState() {
    _userRepository = widget.userRepository ?? UserRepository();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Authenticated) {
              return DashBoardPage();
            }
            if (state is Unauthenticated) {
              return LoginPage(
                userRepository: _userRepository,
              );
            }
            if (state is Loading || state is Uninitialized) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  )
                );
            }
          },
        ),
      ),
    );
  }
}
