

import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';

class ConfigSwitchOption {
    final String title;
    final bool Function(PracticeConfig) select;                 // read value
    final PracticeConfig Function(PracticeConfig) toggle;
    // compute next config
    const ConfigSwitchOption({
        required this.title,
        required this.select,
        required this.toggle
    });
}