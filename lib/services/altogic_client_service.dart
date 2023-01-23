import 'package:altogic/altogic.dart';
import 'package:altogic_flutter_auth_issues/helpers/environment_helper.dart';
import 'package:altogic_flutter_auth_issues/services/configuration/custom_local_storage.dart';

abstract class IAltogicClientService {
  Future<void> init();
  AltogicClient get();
  Future<void> restore();
}

class AltogicClientService implements IAltogicClientService {
  final storage = CustomHiveLocalStorage();
  late final AltogicClient supabaseClient;

  @override
  Future<void> init() async {
    await storage.initialize();
    supabaseClient = createClient(
      EnvironmentHelper.backendUrl,
      EnvironmentHelper.backendClientApiKey,
      ClientOptions(
        apiKey: EnvironmentHelper.backendApiKey,
        localStorage: CustomHiveLocalStorage(),
      ),
    );
  }

  @override
  AltogicClient get() {
    return supabaseClient;
  }

  @override
  Future<void> restore() async {
    await supabaseClient.restoreAuthSession();
  }
}
