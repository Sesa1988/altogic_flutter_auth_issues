import 'dart:async';

import 'package:altogic/altogic.dart';
import 'package:altogic_flutter_auth_issues/models/app_user.dart';
import 'package:altogic_flutter_auth_issues/services/altogic_client_service.dart';

abstract class ICloudAuthService {
  Stream<AppUser> get userStream;
  Future<AppUser> getCurrentUser();

  Future<void> signInWithEmail(String email, String password);
  Future<AppUser> signUpWithEmail(String email, String password);
  Future<void> resetEmailPassword(String email);
  Future<void> sendMagicLink(String email);
  Future<void> changePassword(String oldPassword, String password);

  Future<void> signInWithGoogle();
  Future<void> updateSessionFromToken(String accessToken);
  Future<void> deleteUserAccount();

  Future<void> signout();
  void dispose();
}

class CloudAuthService implements ICloudAuthService {
  final IAltogicClientService _altogicClientService;

  final controller = StreamController<AppUser>();
  late final StreamSubscription<AuthState> _authSubscription;
  AppUser _appUser = AppUser.empty();

  CloudAuthService(this._altogicClientService) {
    _altogicClientService.get().auth.authStateChanges.listen((event) async {
      final user = event.user;

      final provider = user?.provider ?? '';
      final isEmailConfirmed = user?.emailVerified != null;

      _appUser = _getAppUser(user, false, isEmailConfirmed, provider);
      controller.sink.add(_appUser);
    });
  }

  @override
  Stream<AppUser> get userStream {
    return controller.stream;
  }

  @override
  Future<AppUser> getCurrentUser() async {
    var user = _altogicClientService.get().auth.currentState.user;

    final isEmailConfirmed = user?.emailVerified != null;

    _appUser = _getAppUser(user, false, isEmailConfirmed, user?.provider ?? '');
    return _appUser;
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    var result =
        await _altogicClientService.get().auth.signInWithEmail(email, password);

    if ((result.errors?.items ?? []).isNotEmpty) {
      throw Exception();
    }
  }

  @override
  Future<AppUser> signUpWithEmail(String email, String password) async {
    try {
      var authResult = await _altogicClientService
          .get()
          .auth
          .signUpWithEmail(email, password);
      final user = authResult.user;

      final isEmailConfirmed = user?.emailVerified != null;

      _appUser =
          _getAppUser(user, false, isEmailConfirmed, user?.provider ?? '');
      return _appUser;
    } catch (e) {
      return AppUser.empty();
    }
  }

  @override
  Future<void> resetEmailPassword(String email) async {
    var result =
        await _altogicClientService.get().auth.sendResetPwdEmail(email);
    if ((result?.items ?? []).isNotEmpty) {
      throw Exception();
    }
  }

  @override
  Future<void> sendMagicLink(String email) async {
    var result =
        await _altogicClientService.get().auth.sendMagicLinkEmail(email);
    if ((result?.items ?? []).isNotEmpty) {
      throw Exception();
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String password) async {
    var result = await _altogicClientService
        .get()
        .auth
        .changePassword(password, oldPassword);
    if ((result?.items ?? []).isNotEmpty) {
      throw Exception();
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    _altogicClientService.get().auth.signInWithProvider('google');
  }

  @override
  Future<void> updateSessionFromToken(String accessToken) async {
    var result =
        await _altogicClientService.get().auth.getAuthGrant(accessToken);

    if ((result.errors?.items ?? []).isNotEmpty) {
      throw Exception();
    }

    // if (result.session != null && result.user != null) {
    //   _altogicClientService.get().auth.setSession(result.session!);
    //   _altogicClientService.get().auth.setUser(result.user!);
    // }
  }

  @override
  Future<void> deleteUserAccount() async {
    try {
      var result =
          await _altogicClientService.get().endpoint.delete('/user').asMap();

      if (result.errors != null) throw Exception();

      await _altogicClientService.get().auth.signOutAll();
    } catch (e) {
      throw Exception("Error while deleting user account");
    }
  }

  @override
  Future<void> signout() async {
    await _altogicClientService.get().auth.signOut();
  }

  AppUser _getAppUser(
      User? user, bool isPremium, bool isEmailConfirmed, String provider) {
    return AppUser(
      user?.id ?? '',
      user?.email ?? '',
      user?.email ?? '',
      isPremium,
      isEmailConfirmed,
      provider,
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
  }
}
