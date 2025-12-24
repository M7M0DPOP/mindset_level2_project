part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticatonState {}

final class AuthenticatonInitial extends AuthenticatonState {}

final class AuthenticatonLoading extends AuthenticatonState {}

final class AuthenticatonSuccess extends AuthenticatonState {}

final class AuthenticatonFailure extends AuthenticatonState {
  final String errorMessage;
  AuthenticatonFailure(this.errorMessage);
}
