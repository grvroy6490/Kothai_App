├─ di/ # Dependency wiring in one place (Riverpod)
│ ├─ providers.dart # Top-level Provider/ProviderFamily declarations
│ └─ service_locator.dart # Any manual wiring/helpers

## Examles:

> di/providers.dart

``
final dioProvider = Provider<Dio>((ref) {
final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));
// add interceptors etc.
return dio;
});

    final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
        throw UnimplementedError('Override in main before runApp');
    });

``


> main.dart

``
    void main() async {
        WidgetsFlutterBinding.ensureInitialized();
        final prefs = await SharedPreferences.getInstance();

        runApp(
            ProviderScope(
                overrides: [
                    sharedPrefsProvider.overrideWithValue(prefs),
                ],
                child: const App(),
            ),
        );
    }
``