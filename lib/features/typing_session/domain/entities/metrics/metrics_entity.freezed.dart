// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metrics_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetricsEntity {

 int get typed;// total keystrokes (correct + errors)
 int get correct;// correct chars
 int get errors;// wrong chars
 int get elapsedMs;// elapsed in ms
 int get totalChars;
/// Create a copy of MetricsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetricsEntityCopyWith<MetricsEntity> get copyWith => _$MetricsEntityCopyWithImpl<MetricsEntity>(this as MetricsEntity, _$identity);

  /// Serializes this MetricsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetricsEntity&&(identical(other.typed, typed) || other.typed == typed)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.elapsedMs, elapsedMs) || other.elapsedMs == elapsedMs)&&(identical(other.totalChars, totalChars) || other.totalChars == totalChars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typed,correct,errors,elapsedMs,totalChars);

@override
String toString() {
  return 'MetricsEntity(typed: $typed, correct: $correct, errors: $errors, elapsedMs: $elapsedMs, totalChars: $totalChars)';
}


}

/// @nodoc
abstract mixin class $MetricsEntityCopyWith<$Res>  {
  factory $MetricsEntityCopyWith(MetricsEntity value, $Res Function(MetricsEntity) _then) = _$MetricsEntityCopyWithImpl;
@useResult
$Res call({
 int typed, int correct, int errors, int elapsedMs, int totalChars
});




}
/// @nodoc
class _$MetricsEntityCopyWithImpl<$Res>
    implements $MetricsEntityCopyWith<$Res> {
  _$MetricsEntityCopyWithImpl(this._self, this._then);

  final MetricsEntity _self;
  final $Res Function(MetricsEntity) _then;

/// Create a copy of MetricsEntity
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


/// Adds pattern-matching-related methods to [MetricsEntity].
extension MetricsEntityPatterns on MetricsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetricsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetricsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetricsEntity value)  $default,){
final _that = this;
switch (_that) {
case _MetricsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetricsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MetricsEntity() when $default != null:
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
case _MetricsEntity() when $default != null:
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
case _MetricsEntity():
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
case _MetricsEntity() when $default != null:
return $default(_that.typed,_that.correct,_that.errors,_that.elapsedMs,_that.totalChars);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetricsEntity extends MetricsEntity {
  const _MetricsEntity({this.typed = 0, this.correct = 0, this.errors = 0, this.elapsedMs = 0, this.totalChars = 0}): super._();
  factory _MetricsEntity.fromJson(Map<String, dynamic> json) => _$MetricsEntityFromJson(json);

@override@JsonKey() final  int typed;
// total keystrokes (correct + errors)
@override@JsonKey() final  int correct;
// correct chars
@override@JsonKey() final  int errors;
// wrong chars
@override@JsonKey() final  int elapsedMs;
// elapsed in ms
@override@JsonKey() final  int totalChars;

/// Create a copy of MetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetricsEntityCopyWith<_MetricsEntity> get copyWith => __$MetricsEntityCopyWithImpl<_MetricsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetricsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetricsEntity&&(identical(other.typed, typed) || other.typed == typed)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.elapsedMs, elapsedMs) || other.elapsedMs == elapsedMs)&&(identical(other.totalChars, totalChars) || other.totalChars == totalChars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typed,correct,errors,elapsedMs,totalChars);

@override
String toString() {
  return 'MetricsEntity(typed: $typed, correct: $correct, errors: $errors, elapsedMs: $elapsedMs, totalChars: $totalChars)';
}


}

/// @nodoc
abstract mixin class _$MetricsEntityCopyWith<$Res> implements $MetricsEntityCopyWith<$Res> {
  factory _$MetricsEntityCopyWith(_MetricsEntity value, $Res Function(_MetricsEntity) _then) = __$MetricsEntityCopyWithImpl;
@override @useResult
$Res call({
 int typed, int correct, int errors, int elapsedMs, int totalChars
});




}
/// @nodoc
class __$MetricsEntityCopyWithImpl<$Res>
    implements _$MetricsEntityCopyWith<$Res> {
  __$MetricsEntityCopyWithImpl(this._self, this._then);

  final _MetricsEntity _self;
  final $Res Function(_MetricsEntity) _then;

/// Create a copy of MetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? typed = null,Object? correct = null,Object? errors = null,Object? elapsedMs = null,Object? totalChars = null,}) {
  return _then(_MetricsEntity(
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
