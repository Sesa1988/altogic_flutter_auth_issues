import 'package:altogic_flutter_auth_issues/blocs/cloud_auth/cloud_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: Colors.grey[300],
      textColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      onPressed: () => context.read<CloudAuthBloc>().add(CloudSignout()),
      color: Theme.of(context).primaryColor,
      child: const Text(
        'Sign out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
