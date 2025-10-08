

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_status_enum.dart';

part 'session_handler_entity.freezed.dart';

@freezed
abstract class SessionHandler with _$SessionHandler {
    const factory SessionHandler({
        @Default(SessionMode.none) SessionMode mode,
        @Default(SessionStatusEnum.stop) SessionStatusEnum status
    }) = _SessionHandler;

    const SessionHandler._(); // Optional private constructor for custom getters
}