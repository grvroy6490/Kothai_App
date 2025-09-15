


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/typing_session/domain/enums/practice_status_enum.dart';

class PracticeStatusController extends Notifier<PracticeStatusEnum>{
    @override
    PracticeStatusEnum build() => PracticeStatusEnum.stop;

    PracticeStatusEnum get practiceStatus => state;

    void startPractice() => state = PracticeStatusEnum.start;

    void stopPractice() => state = PracticeStatusEnum.stop;

    void pausePractice()  => state = PracticeStatusEnum.pause;

    void resumePractice()  => state = PracticeStatusEnum.resume;

    void completePractice()  => state = PracticeStatusEnum.complete;

}

final practiceStatusProvider = NotifierProvider<PracticeStatusController, PracticeStatusEnum>(PracticeStatusController.new);
