import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/enums/PracticeStatusEnum.dart';

class PracticeStatusNotifier extends StateNotifier<PracticeStatus> {
    PracticeStatusNotifier() : super(PracticeStatus.stop); // Initial state: not running

    PracticeStatus get practiceStatus => state;

    void startPractice() => state = PracticeStatus.start;

    void stopPractice() => state = PracticeStatus.stop;

    // void togglePractice() => state = !state;

    void pausePractice()  => state = PracticeStatus.pause;

    void resumePractice()  => state = PracticeStatus.resume;
}

final practiceStatusProvider =
    StateNotifierProvider<PracticeStatusNotifier, PracticeStatus>(
        (ref) => PracticeStatusNotifier(),
    );
