# altogic_flutter_auth_issues

## macOS

- `flutter build macos --release -t lib/main_desktop.dart --dart-define=backend_url=<REPLACE> --dart-define=backend_api_key=<REPLACE> --dart-define=backend_client_api_key=<REPLACE> --dart-define=env_name=dev`

## Web

- `flutter run web --web-renderer canvaskit --release -t lib/main_web.dart --web-port=3000 --dart-define=backend_url=<REPLACE> --dart-define=backend_api_key=<REPLACE> --dart-define=backend_client_api_key=<REPLACE> --dart-define=env_name=dev`