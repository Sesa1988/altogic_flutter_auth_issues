class AppUser {
  final String id;
  final String name;
  final String email;
  final bool isPremium;
  final bool isEmailConfirmed;
  final String provider;

  const AppUser(
    this.id,
    this.name,
    this.email,
    this.isPremium,
    this.isEmailConfirmed,
    this.provider,
  );

  bool get isSignedIn {
    return id.isNotEmpty;
  }

  static empty() {
    return const AppUser('', '', '', false, false, '');
  }
}
