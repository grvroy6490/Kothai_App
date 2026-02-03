import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectNavNotifier extends Notifier<int> {
    @override
    int build() => 0;

    String routeFor(int index) {
        switch (index) {
            case 0: return '/practice';
            case 1: return '/challenge';
            case 2: return '/profile';
            case 3: return '/more';
            default: return '/practice';
        }
    }

    String get currentRoute => routeFor(state);

    void set(int index) {
        // keep state within [0,3]
        final clamped = index < 0 ? 0 : (index > 3 ? 3 : index);
        state = clamped;
    }
}


