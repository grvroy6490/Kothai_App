

import 'package:visai/features/navigation/usecase/select_nav.dart';
import 'package:riverpod/riverpod.dart';

final selectNavProvider =
NotifierProvider<SelectNavNotifier, int>(SelectNavNotifier.new);
