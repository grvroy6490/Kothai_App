import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/enums/StreakModeEnum.dart';

class StreakModeState {
  final StreakModeEnum mode;
  final DateTime? missingDayDate; // The date of the missing streak to restore

  StreakModeState({this.mode = StreakModeEnum.normal, this.missingDayDate});

  StreakModeState copyWith({StreakModeEnum? mode, DateTime? missingDayDate}) {
    return StreakModeState(
      mode: mode ?? this.mode,
      missingDayDate: missingDayDate ?? this.missingDayDate,
    );
  }
}

class StreakModeController extends StateNotifier<StreakModeState> {
  StreakModeController() : super(StreakModeState());

  void setNormalMode() {
    state = StreakModeState(mode: StreakModeEnum.normal);
  }

  void setRestoreMode(DateTime? missingDayDate) {
    state = StreakModeState(
      mode: StreakModeEnum.restore,
      missingDayDate: missingDayDate,
    );
  }

  void toggle() {
    state = state.mode == StreakModeEnum.normal
        ? StreakModeState(
            mode: StreakModeEnum.restore,
            missingDayDate: state.missingDayDate,
          )
        : StreakModeState(mode: StreakModeEnum.normal);
  }

  DateTime? get missingDayDate => state.missingDayDate;
}

final streakModeProvider =
    StateNotifierProvider<StreakModeController, StreakModeState>(
      (ref) => StreakModeController(),
    );
