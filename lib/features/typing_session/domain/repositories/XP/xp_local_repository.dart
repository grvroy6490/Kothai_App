
import 'package:kothai_app/features/typing_session/domain/entities/XP/xp.dart';

abstract class XpLocalRepository {
    Future<XpTotals> loadTotals();
    Future<void> saveTotals(XpTotals totals);
    Future<void> addEntry(XpEntry entry);
    Future<List<XpEntry>> listEntries({bool onlyPending = false, int? limit});
    Future<void> markSynced(List<String> ids);
}
