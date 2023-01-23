import 'dart:async';

import 'package:altogic_flutter_auth_issues/run_app.dart';
import 'package:altogic_flutter_auth_issues/services/altogic_client_service.dart';
import 'package:altogic_flutter_auth_issues/services/cloud_auth_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final altogicClientService = AltogicClientService();
  await altogicClientService.init();
  await altogicClientService.restore();

  runTestApp(CloudAuthService(altogicClientService));
}
