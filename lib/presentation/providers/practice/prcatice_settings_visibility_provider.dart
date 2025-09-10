


import 'package:flutter_riverpod/flutter_riverpod.dart';

class PracticeSettingsVisibilityNotifier extends StateNotifier<bool>{
  PracticeSettingsVisibilityNotifier() : super(false);

  bool get practiceSettingStatus =>  state;

  void showSettings() => state = true;

  void hideSetting() => state = false;

}

final practiceSettingsVisibilityProvider =
StateNotifierProvider<PracticeSettingsVisibilityNotifier, bool>(
        (ref) => PracticeSettingsVisibilityNotifier()
);
