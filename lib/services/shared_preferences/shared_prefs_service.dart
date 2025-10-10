import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefsService {
    Future<void> init();

    String? getString(String key);
    Future<void> setString(String key, String value);

    int? getInt(String key);
    Future<void> setInt(String key, int value);

    bool? getBool(String key);
    Future<void> setBool(String key, bool value);

    double? getDouble(String key);
    Future<void> setDouble(String key, double value);

    Set<String>? getSet(String key);
    Future<void> setSet(String key, Set<String> value);

    Future<void> remove(String key);
    Future<void> clear();
}

class SharedPrefsServiceImpl implements SharedPrefsService {
    late SharedPreferences _prefs;

    @override
    Future<void> init() async {
        _prefs = await SharedPreferences.getInstance();
    }

    @override
    String? getString(String key) => _prefs.getString(key);

    @override
    Future<void> setString(String key, String value) async =>
    await _prefs.setString(key, value);

    @override
    int? getInt(String key) => _prefs.getInt(key);

    @override
    Future<void> setInt(String key, int value) async =>
    await _prefs.setInt(key, value);

    @override
    bool? getBool(String key) => _prefs.getBool(key);

    @override
    Future<void> setBool(String key, bool value) async =>
    await _prefs.setBool(key, value);

    @override
    double? getDouble(String key) => _prefs.getDouble(key);

    @override
    Future<void> setDouble(String key, double value) async =>
    await _prefs.setDouble(key, value);

    @override
    Set<String>? getSet(String key) => _prefs.getStringList(key)?.toSet();

    @override
    Future<void> setSet(String key, Set<String> value) async =>
        await _prefs.setStringList(key, value.toList());

    @override
    Future<void> remove(String key) async => await _prefs.remove(key);

    @override
    Future<void> clear() async => await _prefs.clear();
}
