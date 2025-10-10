

import 'package:kothai_app/features/typing_session/domain/entities/challenge/challenge_tracking_entity.dart';


abstract class StoreChallengeToPrefs {
    Future<void> save(ChallengeTrackingEntity challenge, String key);
    Future<ChallengeTrackingEntity?> load(String key);
    Future<void> clear(String key);
}