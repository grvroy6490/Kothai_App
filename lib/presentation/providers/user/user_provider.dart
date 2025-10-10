import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/user/user.dart';

part 'user_provider.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
    final uuid = const Uuid();

    @override
    User? build() => null;

    void addUser(String name, String email) {
        state = User(
            id: uuid.v4(),
            name: name,
            email: email,
            created_at: DateTime.now(),
        );
    }
}


