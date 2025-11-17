
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/services/toast_service.dart';

final toastServiceProvider = Provider((ref) => ToastService());