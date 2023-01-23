part of 'cloud_auth_bloc.dart';

abstract class CloudAuthEvent extends Equatable {
  const CloudAuthEvent();
}

class ReturnCloudAuthStatus extends CloudAuthEvent {
  final AppUser user;

  const ReturnCloudAuthStatus(this.user);
  @override
  List<Object> get props => [user];
}

class CheckCloudAuthStatus extends CloudAuthEvent {
  @override
  List<Object> get props => [];
}

class SignInWithEmail extends CloudAuthEvent {
  final String email;
  final String password;

  const SignInWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmail extends CloudAuthEvent {
  final String email;
  final String password;

  const SignUpWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class ResetEmailPassword extends CloudAuthEvent {
  final String email;

  const ResetEmailPassword(this.email);

  @override
  List<Object> get props => [email];
}

class SignInWithGoogle extends CloudAuthEvent {
  @override
  List<Object> get props => [];
}

class CloudSignout extends CloudAuthEvent {
  @override
  List<Object> get props => [];
}

class UpdateSessionFromToken extends CloudAuthEvent {
  final String accessToken;

  const UpdateSessionFromToken(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}

class DeleteUserAccount extends CloudAuthEvent {
  @override
  List<Object?> get props => [];
}
