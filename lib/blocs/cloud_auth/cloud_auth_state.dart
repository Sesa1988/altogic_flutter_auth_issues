part of 'cloud_auth_bloc.dart';

abstract class CloudAuthState extends Equatable {
  const CloudAuthState();
}

class CloudAuthInitial extends CloudAuthState {
  const CloudAuthInitial();

  @override
  List<Object> get props => [];
}

class CloudAuthLoading extends CloudAuthState {
  const CloudAuthLoading();

  @override
  List<Object> get props => [];
}

class CloudAuthStatus extends CloudAuthState {
  final bool isAuthenticated;
  final bool isPremium;
  final AppUser user;
  final bool needsEmailConfirmation;

  const CloudAuthStatus(
    this.isAuthenticated,
    this.isPremium,
    this.user, {
    this.needsEmailConfirmation = false,
  });

  @override
  List<Object> get props => [isAuthenticated, isPremium];
}

class PasswordReseted extends CloudAuthState {
  final bool isPasswordResetetMailOut;

  const PasswordReseted(this.isPasswordResetetMailOut);

  @override
  List<Object> get props => [isPasswordResetetMailOut];
}

class UserAcountDeleted extends CloudAuthState {
  @override
  List<Object> get props => [];
}

class CloudAuthError extends CloudAuthState {
  final String message;
  final DateTime time;

  const CloudAuthError(this.message, this.time);

  @override
  List<Object> get props => [message, time];
}
