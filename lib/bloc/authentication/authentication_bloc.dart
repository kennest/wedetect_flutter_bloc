import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:wedetect/bloc/authentication/authentication.dart';
import 'package:wedetect/repository/alert_repository.dart';
import 'package:wedetect/repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final AlertRepository alertRepository;

  AuthenticationBloc({this.alertRepository,@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationState currentState,
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield Loading();
      await userRepository.persistToken(event.token);
      yield Authenticated();
      //
    }

    if (event is LoggedOut) {
      yield Loading();
      await userRepository.deleteToken();
      yield Unauthenticated();
    }
  }
}
