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

 int get totalWords; int get correctWords; int get incorrectWords; int get totalCharacters; int get correctCharacters; int get incorrectCharacters; double get accuracy; double get wpm; double get cpm;@DurationConverter() Duration get duration;
/// Create a copy of Metrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetricsCopyWith<Metrics> get copyWith => _$MetricsCopyWithImpl<Metrics>(this as Metrics, _$identity);

  /// Serializes this Metrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Metrics&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.correctWords, correctWords) || other.correctWords == correctWords)&&(identical(other.incorrectWords, incorrectWords) || other.incorrectWords == incorrectWords)&&(identical(other.totalCharacters, totalCharacters) || other.totalCharacters == totalCharacters)&&(identical(other.correctCharacters, correctCharacters) || other.correctCharacters == correctCharacters)&&(identical(other.incorrectCharacters, incorrectCharacters) || other.incorrectCharacters == incorrectCharacters)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.wpm, wpm) || other.wpm == wpm)&&(identical(other.cpm, cpm) || other.cpm == cpm)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalWords,correctWords,incorrectWords,totalCharacters,correctCharacters,incorrectCharacters,accuracy,wpm,cpm,duration);

@override
String toString() {
  return 'Metrics(totalWords: $totalWords, correctWords: $correctWords, incorrectWords: $incorrectWords, totalCharacters: $totalCharacters, correctCharacters: $correctCharacters, incorrectCharacters: $incorrectCharacters, accuracy: $accuracy, wpm: $wpm, cpm: $cpm, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $MetricsCopyWith<$Res>  {
  factory $MetricsCopyWith(Metrics value, $Res Function(Metrics) _then) = _$MetricsCopyWithImpl;
@useResult
$Res call({
 int totalWords, int correctWords, int incorrectWords, int totalCharacters, int correctCharacters, int incorrectCharacters, double accuracy, double wpm, double cpm,@DurationConverter() Duration duration
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
@pragma('vm:prefer-inline') @override $Res call({Object? totalWords = null,Object? correctWords = null,Object? incorrectWords = null,Object? totalCharacters = null,Object? correctCharacters = null,Object? incorrectCharacters = null,Object? accuracy = null,Object? wpm = null,Object? cpm = null,Object? duration = null,}) {
  return _then(_self.copyWith(
totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,correctWords: null == correctWords ? _self.correctWords : correctWords // ignore: cast_nullable_to_non_nullable
as int,incorrectWords: null == incorrectWords ? _self.incorrectWords : incorrectWords // ignore: cast_nullable_to_non_nullable
as int,totalCharacters: null == totalCharacters ? _self.totalCharacters : totalCharacters // ignore: cast_nullable_to_non_nullable
as int,correctCharacters: null == correctCharacters ? _self.correctCharacters : correctCharacters // ignore: cast_nullable_to_non_nullable
as int,incorrectCharacters: null == incorrectCharacters ? _self.incorrectCharacters : incorrectCharacters // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,wpm: null == wpm ? _self.wpm : wpm // ignore: cast_nullable_to_non_nullable
as double,cpm: null == cpm ? _self.cpm : cpm // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalWords,  int correctWords,  int incorrectWords,  int totalCharacters,  int correctCharacters,  int incorrectCharacters,  double accuracy,  double wpm,  double cpm, @DurationConverter()  Duration duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Metrics() when $default != null:
return $default(_that.totalWords,_that.correctWords,_that.incorrectWords,_that.totalCharacters,_that.correctCharacters,_that.incorrectCharacters,_that.accuracy,_that.wpm,_that.cpm,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalWords,  int correctWords,  int incorrectWords,  int totalCharacters,  int correctCharacters,  int incorrectCharacters,  double accuracy,  double wpm,  double cpm, @DurationConverter()  Duration duration)  $default,) {final _that = this;
switch (_that) {
case _Metrics():
return $default(_that.totalWords,_that.correctWords,_that.incorrectWords,_that.totalCharacters,_that.correctCharacters,_that.incorrectCharacters,_that.accuracy,_that.wpm,_that.cpm,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalWords,  int correctWords,  int incorrectWords,  int totalCharacters,  int correctCharacters,  int incorrectCharacters,  double accuracy,  double wpm,  double cpm, @DurationConverter()  Duration duration)?  $default,) {final _that = this;
switch (_that) {
case _Metrics() when $default != null:
return $default(_that.totalWords,_that.correctWords,_that.incorrectWords,_that.totalCharacters,_that.correctCharacters,_that.incorrectCharacters,_that.accuracy,_that.wpm,_that.cpm,_that.duration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Metrics implements Metrics {
  const _Metrics({required this.totalWords, required this.correctWords, required this.incorrectWords, required this.totalCharacters, required this.correctCharacters, required this.incorrectCharacters, required this.accuracy, required this.wpm, required this.cpm, @DurationConverter() required this.duration});
  factory _Metrics.fromJson(Map<String, dynamic> json) => _$MetricsFromJson(json);

@override final  int totalWords;
@override final  int correctWords;
@override final  int incorrectWords;
@override final  int totalCharacters;
@override final  int correctCharacters;
@override final  int incorrectCharacters;
@override final  double accuracy;
@override final  double wpm;
@override final  double cpm;
@override@DurationConverter() final  Duration duration;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Metrics&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.correctWords, correctWords) || other.correctWords == correctWords)&&(identical(other.incorrectWords, incorrectWords) || other.incorrectWords == incorrectWords)&&(identical(other.totalCharacters, totalCharacters) || other.totalCharacters == totalCharacters)&&(identical(other.correctCharacters, correctCharacters) || other.correctCharacters == correctCharacters)&&(identical(other.incorrectCharacters, incorrectCharacters) || other.incorrectCharacters == incorrectCharacters)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.wpm, wpm) || other.wpm == wpm)&&(identical(other.cpm, cpm) || other.cpm == cpm)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalWords,correctWords,incorrectWords,totalCharacters,correctCharacters,incorrectCharacters,accuracy,wpm,cpm,duration);

@override
String toString() {
  return 'Metrics(totalWords: $totalWords, correctWords: $correctWords, incorrectWords: $incorrectWords, totalCharacters: $totalCharacters, correctCharacters: $correctCharacters, incorrectCharacters: $incorrectCharacters, accuracy: $accuracy, wpm: $wpm, cpm: $cpm, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$MetricsCopyWith<$Res> implements $MetricsCopyWith<$Res> {
  factory _$MetricsCopyWith(_Metrics value, $Res Function(_Metrics) _then) = __$MetricsCopyWithImpl;
@override @useResult
$Res call({
 int totalWords, int correctWords, int incorrectWords, int totalCharacters, int correctCharacters, int incorrectCharacters, double accuracy, double wpm, double cpm,@DurationConverter() Duration duration
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
@override @pragma('vm:prefer-inline') $Res call({Object? totalWords = null,Object? correctWords = null,Object? incorrectWords = null,Object? totalCharacters = null,Object? correctCharacters = null,Object? incorrectCharacters = null,Object? accuracy = null,Object? wpm = null,Object? cpm = null,Object? duration = null,}) {
  return _then(_Metrics(
totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,correctWords: null == correctWords ? _self.correctWords : correctWords // ignore: cast_nullable_to_non_nullable
as int,incorrectWords: null == incorrectWords ? _self.incorrectWords : incorrectWords // ignore: cast_nullable_to_non_nullable
as int,totalCharacters: null == totalCharacters ? _self.totalCharacters : totalCharacters // ignore: cast_nullable_to_non_nullable
as int,correctCharacters: null == correctCharacters ? _self.correctCharacters : correctCharacters // ignore: cast_nullable_to_non_nullable
as int,incorrectCharacters: null == incorrectCharacters ? _self.incorrectCharacters : incorrectCharacters // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,wpm: null == wpm ? _self.wpm : wpm // ignore: cast_nullable_to_non_nullable
as double,cpm: null == cpm ? _self.cpm : cpm // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
