// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'difficulty.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Difficulty {

 DifficultyEnum get level; AccuracyThresholdEnum get accuracyThreshold; DifficultyWPMEnum get wpmThreshold; DifficultyTimeLimit get timeLimit; XpMultiplier get xpMultiplier;
/// Create a copy of Difficulty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DifficultyCopyWith<Difficulty> get copyWith => _$DifficultyCopyWithImpl<Difficulty>(this as Difficulty, _$identity);

  /// Serializes this Difficulty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Difficulty&&(identical(other.level, level) || other.level == level)&&(identical(other.accuracyThreshold, accuracyThreshold) || other.accuracyThreshold == accuracyThreshold)&&(identical(other.wpmThreshold, wpmThreshold) || other.wpmThreshold == wpmThreshold)&&(identical(other.timeLimit, timeLimit) || other.timeLimit == timeLimit)&&(identical(other.xpMultiplier, xpMultiplier) || other.xpMultiplier == xpMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,accuracyThreshold,wpmThreshold,timeLimit,xpMultiplier);

@override
String toString() {
  return 'Difficulty(level: $level, accuracyThreshold: $accuracyThreshold, wpmThreshold: $wpmThreshold, timeLimit: $timeLimit, xpMultiplier: $xpMultiplier)';
}


}

/// @nodoc
abstract mixin class $DifficultyCopyWith<$Res>  {
  factory $DifficultyCopyWith(Difficulty value, $Res Function(Difficulty) _then) = _$DifficultyCopyWithImpl;
@useResult
$Res call({
 DifficultyEnum level, AccuracyThresholdEnum accuracyThreshold, DifficultyWPMEnum wpmThreshold, DifficultyTimeLimit timeLimit, XpMultiplier xpMultiplier
});




}
/// @nodoc
class _$DifficultyCopyWithImpl<$Res>
    implements $DifficultyCopyWith<$Res> {
  _$DifficultyCopyWithImpl(this._self, this._then);

  final Difficulty _self;
  final $Res Function(Difficulty) _then;

/// Create a copy of Difficulty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? accuracyThreshold = null,Object? wpmThreshold = null,Object? timeLimit = null,Object? xpMultiplier = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,accuracyThreshold: null == accuracyThreshold ? _self.accuracyThreshold : accuracyThreshold // ignore: cast_nullable_to_non_nullable
as AccuracyThresholdEnum,wpmThreshold: null == wpmThreshold ? _self.wpmThreshold : wpmThreshold // ignore: cast_nullable_to_non_nullable
as DifficultyWPMEnum,timeLimit: null == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as DifficultyTimeLimit,xpMultiplier: null == xpMultiplier ? _self.xpMultiplier : xpMultiplier // ignore: cast_nullable_to_non_nullable
as XpMultiplier,
  ));
}

}


/// Adds pattern-matching-related methods to [Difficulty].
extension DifficultyPatterns on Difficulty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Difficulty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Difficulty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Difficulty value)  $default,){
final _that = this;
switch (_that) {
case _Difficulty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Difficulty value)?  $default,){
final _that = this;
switch (_that) {
case _Difficulty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DifficultyEnum level,  AccuracyThresholdEnum accuracyThreshold,  DifficultyWPMEnum wpmThreshold,  DifficultyTimeLimit timeLimit,  XpMultiplier xpMultiplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Difficulty() when $default != null:
return $default(_that.level,_that.accuracyThreshold,_that.wpmThreshold,_that.timeLimit,_that.xpMultiplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DifficultyEnum level,  AccuracyThresholdEnum accuracyThreshold,  DifficultyWPMEnum wpmThreshold,  DifficultyTimeLimit timeLimit,  XpMultiplier xpMultiplier)  $default,) {final _that = this;
switch (_that) {
case _Difficulty():
return $default(_that.level,_that.accuracyThreshold,_that.wpmThreshold,_that.timeLimit,_that.xpMultiplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DifficultyEnum level,  AccuracyThresholdEnum accuracyThreshold,  DifficultyWPMEnum wpmThreshold,  DifficultyTimeLimit timeLimit,  XpMultiplier xpMultiplier)?  $default,) {final _that = this;
switch (_that) {
case _Difficulty() when $default != null:
return $default(_that.level,_that.accuracyThreshold,_that.wpmThreshold,_that.timeLimit,_that.xpMultiplier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Difficulty implements Difficulty {
  const _Difficulty({this.level = DifficultyEnum.easy, this.accuracyThreshold = AccuracyThresholdEnum.accuracyEasy, this.wpmThreshold = DifficultyWPMEnum.wpmEasy, this.timeLimit = DifficultyTimeLimit.limitEasy, this.xpMultiplier = XpMultiplier.easy});
  factory _Difficulty.fromJson(Map<String, dynamic> json) => _$DifficultyFromJson(json);

@override@JsonKey() final  DifficultyEnum level;
@override@JsonKey() final  AccuracyThresholdEnum accuracyThreshold;
@override@JsonKey() final  DifficultyWPMEnum wpmThreshold;
@override@JsonKey() final  DifficultyTimeLimit timeLimit;
@override@JsonKey() final  XpMultiplier xpMultiplier;

/// Create a copy of Difficulty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DifficultyCopyWith<_Difficulty> get copyWith => __$DifficultyCopyWithImpl<_Difficulty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DifficultyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Difficulty&&(identical(other.level, level) || other.level == level)&&(identical(other.accuracyThreshold, accuracyThreshold) || other.accuracyThreshold == accuracyThreshold)&&(identical(other.wpmThreshold, wpmThreshold) || other.wpmThreshold == wpmThreshold)&&(identical(other.timeLimit, timeLimit) || other.timeLimit == timeLimit)&&(identical(other.xpMultiplier, xpMultiplier) || other.xpMultiplier == xpMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,accuracyThreshold,wpmThreshold,timeLimit,xpMultiplier);

@override
String toString() {
  return 'Difficulty(level: $level, accuracyThreshold: $accuracyThreshold, wpmThreshold: $wpmThreshold, timeLimit: $timeLimit, xpMultiplier: $xpMultiplier)';
}


}

/// @nodoc
abstract mixin class _$DifficultyCopyWith<$Res> implements $DifficultyCopyWith<$Res> {
  factory _$DifficultyCopyWith(_Difficulty value, $Res Function(_Difficulty) _then) = __$DifficultyCopyWithImpl;
@override @useResult
$Res call({
 DifficultyEnum level, AccuracyThresholdEnum accuracyThreshold, DifficultyWPMEnum wpmThreshold, DifficultyTimeLimit timeLimit, XpMultiplier xpMultiplier
});




}
/// @nodoc
class __$DifficultyCopyWithImpl<$Res>
    implements _$DifficultyCopyWith<$Res> {
  __$DifficultyCopyWithImpl(this._self, this._then);

  final _Difficulty _self;
  final $Res Function(_Difficulty) _then;

/// Create a copy of Difficulty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? accuracyThreshold = null,Object? wpmThreshold = null,Object? timeLimit = null,Object? xpMultiplier = null,}) {
  return _then(_Difficulty(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,accuracyThreshold: null == accuracyThreshold ? _self.accuracyThreshold : accuracyThreshold // ignore: cast_nullable_to_non_nullable
as AccuracyThresholdEnum,wpmThreshold: null == wpmThreshold ? _self.wpmThreshold : wpmThreshold // ignore: cast_nullable_to_non_nullable
as DifficultyWPMEnum,timeLimit: null == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as DifficultyTimeLimit,xpMultiplier: null == xpMultiplier ? _self.xpMultiplier : xpMultiplier // ignore: cast_nullable_to_non_nullable
as XpMultiplier,
  ));
}


}

// dart format on
