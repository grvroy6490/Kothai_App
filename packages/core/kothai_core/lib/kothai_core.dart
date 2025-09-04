library kothai_core;

class Result<T> {
  final T? value;
  final Object? error;
  const Result.success(this.value) : error = null;
  const Result.failure(this.error) : value = null;
  bool get isSuccess => error == null;
}
