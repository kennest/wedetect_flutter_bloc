import 'package:bloc/bloc.dart';
import 'package:wedetect/bloc/authentication/authentication.dart';
import 'package:wedetect/repository/user_repository.dart';
import 'login.dart';
import 'dart:async';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({this.userRepository, this.authenticationBloc});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
      LoginState currentState, LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      await userRepository.deleteToken();
      yield LoginLoading();
      try {
        final token = await userRepository.authenticate(
            username: event.username, password: event.password);
        if (token.isNotEmpty) {
          authenticationBloc.dispatch(LoggedIn(token: token));
        }
        yield LoginInitial();
      } catch (e) {
        yield LoginFailure(e.toString());
        yield LoginInitial();
      }
    } else if (event is LogoutButtonPressed) {
      authenticationBloc.dispatch(LoggedOut());
      yield LoginInitial();
    }
  }
}
