
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/presentation/providers/session/session_state_provider.dart';


final sessionElapsedProvider = Provider<Duration>(
      (ref) => ref.watch(sessionStateProvider.select((s) => s.elapsed)),
);
final sessionProgressProvider = Provider<double>(
    (ref) => ref.watch(sessionStateProvider.select((s) => s.progress)),
);

final sessionAccuracyProvider = Provider<double>(
    (ref) => ref.watch(sessionStateProvider.select((s) => s.accuracy)),
);

final sessionWpmProvider = Provider<double>(
    (ref) => ref.watch(sessionStateProvider.select((s) => s.wpm)),
);
