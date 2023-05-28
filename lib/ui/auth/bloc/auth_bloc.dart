import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/common/enum.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth firebaseAuth;
  AuthBloc(this.firebaseAuth)
      : super(const AuthState(
          withError: false,
          categoryList: [],
        )) {
    on<LoginEvent>(_onLogIn);
    on<LogOut>(_logOut);
    on<GetAuth>(_getAuth);
    on<AddError>(_addError);
  }

  void _getAuth(
    GetAuth event,
    Emitter<AuthState> emit,
  ) async {
    final User? user = firebaseAuth.currentUser;

    emit(
      state.copyWith(
        auth: user == null
            ? AuthenticationState.unauthenticated
            : AuthenticationState.authenticated,
      ),
    );
  }

  void _addError(
    AddError event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        withError: event.withError,
      ),
    );
  }

  void _onLogIn(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: event.email, password: event.password)
        .then((value) {
      emit(
        state.copyWith(
          auth: AuthenticationState.authenticated,
          withError: false,
        ),
      );
    }).onError((error, stackTrace) {
      emit(
        state.copyWith(
          auth: AuthenticationState.unauthenticated,
          withError: true,
        ),
      );
    });
  }

  void _logOut(
    LogOut event,
    Emitter<AuthState> emit,
  ) async {
    await firebaseAuth.signOut().then((value) {
      emit(
        state.copyWith(
          auth: AuthenticationState.unauthenticated,
          withError: false,
        ),
      );
    }).onError((error, stackTrace) {});
  }
}
