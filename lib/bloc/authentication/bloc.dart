import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Stream<AuthenticationState> _mapAuthCheckRequestedToState(
      AuthCheckRequested event, Emitter<AuthenticationState> emit) async* {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
      UserLoggedInEvent event, Emitter<AuthenticationState> emit) async* {
    emit(Authenticated(event.user));
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
      UserLoggedOutEvent event, Emitter<AuthenticationState> emit) async* {
    emit(Unauthenticated());
    _firebaseAuth.signOut();
  }
}
