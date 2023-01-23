import 'dart:async';
import 'package:altogic_flutter_auth_issues/helpers/error_messages.dart';
import 'package:altogic_flutter_auth_issues/models/app_user.dart';
import 'package:altogic_flutter_auth_issues/services/cloud_auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'cloud_auth_event.dart';
part 'cloud_auth_state.dart';

class CloudAuthBloc extends Bloc<CloudAuthEvent, CloudAuthState> {
  final ICloudAuthService cloudAuthService;

  AppUser user = AppUser.empty();

  CloudAuthBloc({
    required this.cloudAuthService,
  }) : super(const CloudAuthInitial()) {
    cloudAuthService.userStream.listen(
      (AppUser event) => add(ReturnCloudAuthStatus(event)),
    );

    on<ReturnCloudAuthStatus>(
        (event, emit) => _returnCloudAuthStatus(event, emit));
    on<CheckCloudAuthStatus>((event, emit) => _getAuthStatus(emit));
    on<SignInWithEmail>((event, emit) => _signInWithEmail(event, emit));
    on<ResetEmailPassword>((event, emit) => _resetEmailPassword(event, emit));
    on<SignUpWithEmail>((event, emit) => _signUpWithEmail(event, emit));
    on<SignInWithGoogle>((event, emit) => _signInWithGoogle(event, emit));
    on<CloudSignout>((event, emit) => _signout(emit));
    on<UpdateSessionFromToken>(
        ((event, emit) => _updateSessionFromToken(event, emit)));
    on<DeleteUserAccount>(((event, emit) => _deleteUserAccount(emit)));
  }

  Future<void> _returnCloudAuthStatus(
      ReturnCloudAuthStatus event, Emitter<CloudAuthState> emit) async {
    user = event.user;
    emit(CloudAuthStatus(user.isSignedIn, user.isPremium, user));
  }

  Future<void> _getAuthStatus(Emitter<CloudAuthState> emit) async {
    try {
      emit(const CloudAuthLoading());

      user = await cloudAuthService.getCurrentUser();

      emit(CloudAuthStatus(user.isSignedIn, user.isPremium, user));
    } catch (e) {
      emit(CloudAuthError(ErrorMessages.unknownError, DateTime.now()));
      rethrow;
    }
  }

  Future<void> _signInWithEmail(
    SignInWithEmail event,
    Emitter<CloudAuthState> emit,
  ) async {
    try {
      emit(const CloudAuthLoading());

      await cloudAuthService.signInWithEmail(
        event.email,
        event.password,
      );
    } catch (error) {
      emit(CloudAuthError(ErrorMessages.unknownError, DateTime.now()));
      rethrow;
    }
  }

  Future<void> _resetEmailPassword(
    ResetEmailPassword event,
    Emitter<CloudAuthState> emit,
  ) async {
    try {
      emit(const CloudAuthLoading());

      await cloudAuthService.sendMagicLink(event.email);

      emit(const PasswordReseted(true));
    } catch (e) {
      emit(CloudAuthError(ErrorMessages.unknownError, DateTime.now()));
      rethrow;
    }
  }

  Future<void> _signUpWithEmail(
    SignUpWithEmail event,
    Emitter<CloudAuthState> emit,
  ) async {
    try {
      emit(const CloudAuthLoading());

      user = await cloudAuthService.signUpWithEmail(
        event.email,
        event.password,
      );

      if (user.isEmailConfirmed == false) {
        user = AppUser.empty();
        emit(CloudAuthStatus(
          false,
          false,
          user,
          needsEmailConfirmation: true,
        ));
        return;
      }
    } catch (error) {
      emit(CloudAuthError(ErrorMessages.unknownError, DateTime.now()));
      rethrow;
    }
  }

  Future<void> _signInWithGoogle(
    SignInWithGoogle event,
    Emitter<CloudAuthState> emit,
  ) async {
    try {
      emit(const CloudAuthLoading());

      await cloudAuthService.signInWithGoogle();
    } catch (error) {
      emit(CloudAuthError(ErrorMessages.unknownError, DateTime.now()));
      rethrow;
    }
  }

  Future<void> _updateSessionFromToken(
    UpdateSessionFromToken event,
    Emitter<CloudAuthState> emit,
  ) async {
    try {
      emit(const CloudAuthLoading());

      await cloudAuthService.updateSessionFromToken(event.accessToken);
    } catch (error) {
      emit(CloudAuthError(ErrorMessages.unknownError, DateTime.now()));
      rethrow;
    }
  }

  _deleteUserAccount(Emitter<CloudAuthState> emit) async {
    try {
      emit(const CloudAuthLoading());

      await cloudAuthService.deleteUserAccount();

      emit(UserAcountDeleted());
      add(CheckCloudAuthStatus());
    } catch (error) {
      emit(CloudAuthError(ErrorMessages.unknownError, DateTime.now()));
      rethrow;
    }
  }

  Future<void> _signout(Emitter<CloudAuthState> emit) async {
    try {
      emit(const CloudAuthLoading());
      await cloudAuthService.signout();
    } catch (error) {
      emit(CloudAuthError(ErrorMessages.unknownError, DateTime.now()));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    cloudAuthService.dispose();
    return super.close();
  }
}
