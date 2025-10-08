

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/data/sources/db_helper.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
        return AppDatabase.open();
    });
