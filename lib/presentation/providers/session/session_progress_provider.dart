


import 'package:flutter_riverpod/flutter_riverpod.dart';


class SessionProgressNotifier extends StateNotifier<double> {
    SessionProgressNotifier() : super(0.0);

    double get practiceStatus => state;

    void updateProgress(double progress) {
        state = progress;
    }

    void resetProgress() {
        state = 0.0;
    }
}


final sessionProgressProvider = StateNotifierProvider<SessionProgressNotifier, double>(
    (ref) => SessionProgressNotifier(),
);
