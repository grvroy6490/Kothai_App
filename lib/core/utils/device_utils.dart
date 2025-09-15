import 'dart:io' show Platform;

class DeviceUtils {
    static bool get isAndroid => Platform.isAndroid;
    static bool get isIOS => Platform.isIOS;

    static String get platformName {
        if (Platform.isAndroid) return "Android";
        if (Platform.isIOS) return "iOS";
        return "Other";
    }
}
