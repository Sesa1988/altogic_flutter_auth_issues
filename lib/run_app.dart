import 'package:altogic/altogic.dart';
import 'package:altogic_flutter_auth_issues/app_localizations.dart';
import 'package:altogic_flutter_auth_issues/blocs/cloud_auth/cloud_auth_bloc.dart';
import 'package:altogic_flutter_auth_issues/routes/named_routes.dart';
import 'package:altogic_flutter_auth_issues/services/cloud_auth_service.dart';
import 'package:altogic_flutter_auth_issues/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void runTestApp(CloudAuthService cloudAuthService) {
  runApp(BlocProvider<CloudAuthBloc>(
    create: (context) {
      return CloudAuthBloc(cloudAuthService: cloudAuthService);
    },
    child: TestApp(),
  ));
}

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends AltogicState<TestApp> {
  @override
  void onOauthProviderLink(BuildContext? context, OauthRedirect redirect) {
    updateSession(context, redirect.error, redirect.token);
  }

  @override
  void onEmailVerificationLink(
      BuildContext? context, EmailVerificationRedirect redirect) {
    updateSession(context, redirect.error, redirect.token);
  }

  @override
  void onMagicLink(BuildContext? context, MagicLinkRedirect redirect) async {
    updateSession(context, redirect.error, redirect.token);
  }

  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    var materialApp = MaterialApp(
      title: 'TestApp',
      navigatorObservers: [navigatorObserver],
      debugShowCheckedModeBanner: false,
      theme: themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(secondary: Colors.blue),
      ),
      initialRoute: StartScreen.routeName,
      routes: NamedRoutes.get(),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
    return materialApp;
  }

  void updateSession(BuildContext? localContext, String? error, String token) {
    if (error?.isEmpty ?? true && localContext != null) {
      localContext!.read<CloudAuthBloc>().add(UpdateSessionFromToken(token));
    }
  }
}
