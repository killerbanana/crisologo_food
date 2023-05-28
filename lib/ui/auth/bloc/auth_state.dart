part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable {
  final AuthenticationState? auth;
  final bool withError;
  final List<String> categoryList;
  @override
  List<Object?> get props => [
        auth,
        withError,
      ];

  const AuthState({
    this.auth,
    required this.withError,
    required this.categoryList,
  });

  AuthState copyWith({
    AuthenticationState? auth,
    bool? withError,
    List<String>? categoryList,
  }) {
    return AuthState(
        auth: auth ?? this.auth,
        withError: withError ?? this.withError,
        categoryList: categoryList ?? this.categoryList);
  }
}
