

import 'package:visai/features/typing_session/domain/entities/session/session_handler_entity.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_status_provider.g.dart';

@riverpod
class SessionStatusController extends _$SessionStatusController {
    @override
    SessionHandler build() => const SessionHandler();

    void updateMode(SessionMode mode) =>
        state = state.copyWith(mode: mode);

    void updateStatus(SessionStatusEnum status) =>
        state = state.copyWith(status: status);

    void reset() => {
        ref.read(userInputProvider.notifier).clear(),
        state = const SessionHandler()
    };
}

