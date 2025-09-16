import 'package:kothai_app/features/typing_session/domain/entities/XP/xp.dart';

abstract class XpCloudRepository {
    Future<void> uploadEntries(List<XpEntry> entries);
}