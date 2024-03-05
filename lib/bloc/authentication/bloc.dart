import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'state.dart';

part 'event.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthCheckRequested>(_mapAuthCheckRequestedToState);
    on<UserLoggedInEvent>(_mapUserLoggedInToState);
    on<UserLoggedOutEvent>(_mapUserLoggedOutToState);
  }

  void _mapAuthCheckRequestedToState(
      AuthCheckRequested event, Emitter<AuthenticationState> emit) {
    Logger().i('checking for user');
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  void _mapUserLoggedInToState(
      UserLoggedInEvent event, Emitter<AuthenticationState> emit) {
    Logger().i("user load event");
    emit(Authenticated(event.user));
  }

  void _mapUserLoggedOutToState(
      UserLoggedOutEvent event, Emitter<AuthenticationState> emit) {
    emit(Unauthenticated());
    _firebaseAuth.signOut();
  }
}
