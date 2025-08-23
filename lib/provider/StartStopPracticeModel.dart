import 'package:flutter/material.dart';

class StartStopPracticeModel with ChangeNotifier {
    bool _isPracticeRunning = false;

    bool get isPracticeRunning => _isPracticeRunning;

    void startPractice() {
        _isPracticeRunning = true;
        print(_isPracticeRunning);
        notifyListeners();
    }

    void stopPractice() {
        _isPracticeRunning = false;
        notifyListeners();
    }
}
