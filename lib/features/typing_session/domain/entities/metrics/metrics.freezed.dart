// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Metrics {

 int get typed;// total keystrokes (correct + errors)
 int get correct;// correct chars
 int get errors;// wrong chars
 int get elapsedMs;// elapsed in ms
 int get totalChars;
/// Create a copy of Metrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetricsCopyWith<Metrics> get copyWith => _$MetricsCopyWithImpl<Metrics>(this as Metrics, _$identity);

  /// Serializes this Metrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Metrics&&(identical(other.typed, typed) || other.typed == typed)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.elapsedMs, elapsedMs) || other.elapsedMs == elapsedMs)&&(identical(other.totalChars, totalChars) || other.totalChars == totalChars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typed,correct,errors,elapsedMs,totalChars);

@override
String toString() {
  return 'Metrics(typed: $typed, correct: $correct, errors: $errors, elapsedMs: $elapsedMs, totalChars: $totalChars)';
}


}

/// @nodoc
abstract mixin class $MetricsCopyWith<$Res>  {
  factory $MetricsCopyWith(Metrics value, $Res Function(Metrics) _then) = _$MetricsCopyWithImpl;
@useResult
$Res call({
 int typed, int correct, int errors, int elapsedMs, int totalChars
});




}
/// @nodoc
class _$MetricsCopyWithImpl<$Res>
    implements $MetricsCopyWith<$Res> {
  _$MetricsCopyWithImpl(this._self, this._then);

  final Metrics _self;
  final $Res Function(Metrics) _then;

/// Create a copy of Metrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? typed = null,Object? correct = null,Object? errors = null,Object? elapsedMs = null,Object? totalChars = null,}) {
  return _then(_self.copyWith(
typed: null == typed ? _self.typed : typed // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,elapsedMs: null == elapsedMs ? _self.elapsedMs : elapsedMs // ignore: cast_nullable_to_non_nullable
as int,totalChars: null == totalChars ? _self.totalChars : totalChars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Metrics].
extension MetricsPatterns on Metrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Metrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Metrics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Metrics value)  $default,){
final _that = this;
switch (_that) {
case _Metrics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Metrics value)?  $default,){
final _that = this;
switch (_that) {
case _Metrics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int typed,  int correct,  int errors,  int elapsedMs,  int totalChars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Metrics() when $default != null:
return $default(_that.typed,_that.correct,_that.errors,_that.elapsedMs,_that.totalChars);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int typed,  int correct,  int errors,  int elapsedMs,  int totalChars)  $default,) {final _that = this;
switch (_that) {
case _Metrics():
return $default(_that.typed,_that.correct,_that.errors,_that.elapsedMs,_that.totalChars);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int typed,  int correct,  int errors,  int elapsedMs,  int totalChars)?  $default,) {final _that = this;
switch (_that) {
case _Metrics() when $default != null:
return $default(_that.typed,_that.correct,_that.errors,_that.elapsedMs,_that.totalChars);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Metrics extends Metrics {
  const _Metrics({this.typed = 0, this.correct = 0, this.errors = 0, this.elapsedMs = 0, this.totalChars = 0}): super._();
  factory _Metrics.fromJson(Map<String, dynamic> json) => _$MetricsFromJson(json);

@override@JsonKey() final  int typed;
// total keystrokes (correct + errors)
@override@JsonKey() final  int correct;
// correct chars
@override@JsonKey() final  int errors;
// wrong chars
@override@JsonKey() final  int elapsedMs;
// elapsed in ms
@override@JsonKey() final  int totalChars;

/// Create a copy of Metrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetricsCopyWith<_Metrics> get copyWith => __$MetricsCopyWithImpl<_Metrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Metrics&&(identical(other.typed, typed) || other.typed == typed)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.elapsedMs, elapsedMs) || other.elapsedMs == elapsedMs)&&(identical(other.totalChars, totalChars) || other.totalChars == totalChars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typed,correct,errors,elapsedMs,totalChars);

@override
String toString() {
  return 'Metrics(typed: $typed, correct: $correct, errors: $errors, elapsedMs: $elapsedMs, totalChars: $totalChars)';
}


}

/// @nodoc
abstract mixin class _$MetricsCopyWith<$Res> implements $MetricsCopyWith<$Res> {
  factory _$MetricsCopyWith(_Metrics value, $Res Function(_Metrics) _then) = __$MetricsCopyWithImpl;
@override @useResult
$Res call({
 int typed, int correct, int errors, int elapsedMs, int totalChars
});




}
/// @nodoc
class __$MetricsCopyWithImpl<$Res>
    implements _$MetricsCopyWith<$Res> {
  __$MetricsCopyWithImpl(this._self, this._then);

  final _Metrics _self;
  final $Res Function(_Metrics) _then;

/// Create a copy of Metrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? typed = null,Object? correct = null,Object? errors = null,Object? elapsedMs = null,Object? totalChars = null,}) {
  return _then(_Metrics(
typed: null == typed ? _self.typed : typed // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,elapsedMs: null == elapsedMs ? _self.elapsedMs : elapsedMs // ignore: cast_nullable_to_non_nullable
as int,totalChars: null == totalChars ? _self.totalChars : totalChars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
