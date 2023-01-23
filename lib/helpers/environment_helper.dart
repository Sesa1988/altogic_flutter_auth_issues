class EnvironmentHelper {
  static const String envName = String.fromEnvironment('env_name');

  static const String backendUrl = String.fromEnvironment('backend_url');
  static const String backendApiKey = String.fromEnvironment('backend_api_key');
  static const String backendClientApiKey =
      String.fromEnvironment('backend_client_api_key');
}
