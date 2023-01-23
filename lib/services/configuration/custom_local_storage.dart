import 'package:altogic/altogic.dart';
import 'package:altogic_flutter_auth_issues/helpers/environment_helper.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _hiveBoxName =
    'CryptoWulf.altogic_authentication.${EnvironmentHelper.envName}';
const altogicPersistSessionKey =
    'CryptoWulf.ALTOGIC_PERSIST_SESSION_KEY.${EnvironmentHelper.envName}';

class CustomHiveLocalStorage extends ClientStorage {
  Future<void> initialize() async {
    await Hive.initFlutter('auth_${EnvironmentHelper.envName}');
    await Hive.openBox(_hiveBoxName);
  }

  @override
  Future<String?> getItem(String key) {
    return Future.value(
      Hive.box(_hiveBoxName).get(key + altogicPersistSessionKey) as String?,
    );
  }

  @override
  Future<void> removeItem(String key) {
    return Hive.box(_hiveBoxName).delete(key + altogicPersistSessionKey);
  }

  @override
  Future<void> setItem(String key, String value) {
    return Hive.box(_hiveBoxName).put(key + altogicPersistSessionKey, value);
  }
}
