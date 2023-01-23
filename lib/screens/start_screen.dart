import 'package:altogic_flutter_auth_issues/blocs/cloud_auth/cloud_auth_bloc.dart';
import 'package:altogic_flutter_auth_issues/screens/widgets/main_progress.dart';
import 'package:altogic_flutter_auth_issues/screens/widgets/sign_in_button.dart';
import 'package:altogic_flutter_auth_issues/screens/widgets/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    context.read<CloudAuthBloc>().add(CheckCloudAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CloudAuthBloc, CloudAuthState>(
        builder: (context, state) {
          if (state is CloudAuthLoading) {
            return _main(const MainProgress());
          }
          if (state is CloudAuthStatus) {
            if (state.isAuthenticated) {
              return _main(SignOutButton());
            }
            return _main(SignInButton());
          }
          if (state is PasswordReseted) {
            return _main(SignInButton());
          }
          if (state is CloudAuthError) {
            return _main(SignInButton());
          }
          return Container();
        },
      ),
    );
  }

  Widget _main(Widget content) {
    return Center(child: content);
  }
}
