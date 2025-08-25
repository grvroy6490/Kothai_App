import 'package:flutter/foundation.dart';

class HoldKeyModel extends ChangeNotifier {
    String? _hold; // e.g. 'ெ' / 'ே' / 'ை'
    String? get hold => _hold;
    bool get isHolding => _hold != null;

    void holdFor(String ch) {
        if (_hold == ch) return;
        _hold = ch;
        notifyListeners();
    }

    void clear() {
        if (_hold == null) return;
        _hold = null;
        notifyListeners();
    }
}
