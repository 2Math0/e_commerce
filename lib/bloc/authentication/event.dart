part of 'bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthenticationEvent {}

class UserLoggedInEvent extends AuthenticationEvent {
  final User user;

  const UserLoggedInEvent(this.user);

  @override
  List<Object> get props => [user];
}

class UserLoggedOutEvent extends AuthenticationEvent {}

