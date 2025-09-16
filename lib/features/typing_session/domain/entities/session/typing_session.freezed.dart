// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'typing_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TypingSession {

 String get id;// unique id (uuid)
 SessionMode get mode; DifficultyEnum get difficulty; DateTime get startedAt; DateTime get endedAt; Metrics get metrics;
/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypingSessionCopyWith<TypingSession> get copyWith => _$TypingSessionCopyWithImpl<TypingSession>(this as TypingSession, _$identity);

  /// Serializes this TypingSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.metrics, metrics) || other.metrics == metrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mode,difficulty,startedAt,endedAt,metrics);

@override
String toString() {
  return 'TypingSession(id: $id, mode: $mode, difficulty: $difficulty, startedAt: $startedAt, endedAt: $endedAt, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class $TypingSessionCopyWith<$Res>  {
  factory $TypingSessionCopyWith(TypingSession value, $Res Function(TypingSession) _then) = _$TypingSessionCopyWithImpl;
@useResult
$Res call({
 String id, SessionMode mode, DifficultyEnum difficulty, DateTime startedAt, DateTime endedAt, Metrics metrics
});


$MetricsCopyWith<$Res> get metrics;

}
/// @nodoc
class _$TypingSessionCopyWithImpl<$Res>
    implements $TypingSessionCopyWith<$Res> {
  _$TypingSessionCopyWithImpl(this._self, this._then);

  final TypingSession _self;
  final $Res Function(TypingSession) _then;

/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mode = null,Object? difficulty = null,Object? startedAt = null,Object? endedAt = null,Object? metrics = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as Metrics,
  ));
}
/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetricsCopyWith<$Res> get metrics {
  
  return $MetricsCopyWith<$Res>(_self.metrics, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}
}


/// Adds pattern-matching-related methods to [TypingSession].
extension TypingSessionPatterns on TypingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypingSession value)  $default,){
final _that = this;
switch (_that) {
case _TypingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypingSession value)?  $default,){
final _that = this;
switch (_that) {
case _TypingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SessionMode mode,  DifficultyEnum difficulty,  DateTime startedAt,  DateTime endedAt,  Metrics metrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypingSession() when $default != null:
return $default(_that.id,_that.mode,_that.difficulty,_that.startedAt,_that.endedAt,_that.metrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SessionMode mode,  DifficultyEnum difficulty,  DateTime startedAt,  DateTime endedAt,  Metrics metrics)  $default,) {final _that = this;
switch (_that) {
case _TypingSession():
return $default(_that.id,_that.mode,_that.difficulty,_that.startedAt,_that.endedAt,_that.metrics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SessionMode mode,  DifficultyEnum difficulty,  DateTime startedAt,  DateTime endedAt,  Metrics metrics)?  $default,) {final _that = this;
switch (_that) {
case _TypingSession() when $default != null:
return $default(_that.id,_that.mode,_that.difficulty,_that.startedAt,_that.endedAt,_that.metrics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TypingSession implements TypingSession {
  const _TypingSession({required this.id, required this.mode, required this.difficulty, required this.startedAt, required this.endedAt, required this.metrics});
  factory _TypingSession.fromJson(Map<String, dynamic> json) => _$TypingSessionFromJson(json);

@override final  String id;
// unique id (uuid)
@override final  SessionMode mode;
@override final  DifficultyEnum difficulty;
@override final  DateTime startedAt;
@override final  DateTime endedAt;
@override final  Metrics metrics;

/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypingSessionCopyWith<_TypingSession> get copyWith => __$TypingSessionCopyWithImpl<_TypingSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TypingSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.metrics, metrics) || other.metrics == metrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mode,difficulty,startedAt,endedAt,metrics);

@override
String toString() {
  return 'TypingSession(id: $id, mode: $mode, difficulty: $difficulty, startedAt: $startedAt, endedAt: $endedAt, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class _$TypingSessionCopyWith<$Res> implements $TypingSessionCopyWith<$Res> {
  factory _$TypingSessionCopyWith(_TypingSession value, $Res Function(_TypingSession) _then) = __$TypingSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, SessionMode mode, DifficultyEnum difficulty, DateTime startedAt, DateTime endedAt, Metrics metrics
});


@override $MetricsCopyWith<$Res> get metrics;

}
/// @nodoc
class __$TypingSessionCopyWithImpl<$Res>
    implements _$TypingSessionCopyWith<$Res> {
  __$TypingSessionCopyWithImpl(this._self, this._then);

  final _TypingSession _self;
  final $Res Function(_TypingSession) _then;

/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mode = null,Object? difficulty = null,Object? startedAt = null,Object? endedAt = null,Object? metrics = null,}) {
  return _then(_TypingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as Metrics,
  ));
}

/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetricsCopyWith<$Res> get metrics {
  
  return $MetricsCopyWith<$Res>(_self.metrics, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}
}

// dart format on
