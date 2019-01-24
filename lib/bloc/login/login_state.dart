import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error) : super([error]);

  @override
  String toString() => 'LoginFailure';
}

class LoginSuccess extends LoginState {
  final String token;

  LoginSuccess(this.token) : super([token]);

  @override
  String toString() => 'LoginSuccess: $token';
}
