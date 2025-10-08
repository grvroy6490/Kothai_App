

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/domain/entities/gamification/gamification_entity.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/gamification/gamification_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gamification_controller_provider.g.dart';


@riverpod
class GamificationDataController extends _$GamificationDataController {
    @override
    GamificationEntity? build() {
        final asyncValue = ref.watch(getGamificationDataControllerProvider);

        return asyncValue.maybeWhen(
            data: (entity) => entity,
            orElse: () => null
        );
    }
}

@riverpod
Future<void> preloadGamificationController(Ref ref) async {
    ref.watch(gamificationRepositoryProvider).preloadGamificationData();
}


@riverpod
Future<GamificationEntity?> getGamificationDataController(Ref ref) async {
    return ref.read(gamificationRepositoryProvider).getGamificationData();
}


