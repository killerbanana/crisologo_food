part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];

  const AuthEvent();
}

class GetAuth extends AuthEvent {
  @override
  List<Object?> get props => [];
  const GetAuth();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  @override
  List<Object?> get props => [];

  const LoginEvent({
    required this.email,
    required this.password,
  });
}

class LogOut extends AuthEvent {
  @override
  List<Object?> get props => [];
  const LogOut();
}

class AddError extends AuthEvent {
  final bool withError;
  @override
  List<Object?> get props => [withError];
  const AddError({required this.withError});
}
