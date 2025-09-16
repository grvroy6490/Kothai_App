import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_input_provider.g.dart';

@riverpod
class UserInput extends _$UserInput {
  @override
  String build() => '';

  void set(String value) => state = value;
  void clear() => state = '';
}
