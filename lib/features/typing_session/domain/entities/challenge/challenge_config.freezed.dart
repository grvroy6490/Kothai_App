// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChallengeConfig {

 bool get soundEnabled; bool get hapticEnabled; bool get darkMode; bool get notificationsEnabled;
/// Create a copy of ChallengeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeConfigCopyWith<ChallengeConfig> get copyWith => _$ChallengeConfigCopyWithImpl<ChallengeConfig>(this as ChallengeConfig, _$identity);

  /// Serializes this ChallengeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeConfig&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soundEnabled,hapticEnabled,darkMode,notificationsEnabled);

@override
String toString() {
  return 'ChallengeConfig(soundEnabled: $soundEnabled, hapticEnabled: $hapticEnabled, darkMode: $darkMode, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class $ChallengeConfigCopyWith<$Res>  {
  factory $ChallengeConfigCopyWith(ChallengeConfig value, $Res Function(ChallengeConfig) _then) = _$ChallengeConfigCopyWithImpl;
@useResult
$Res call({
 bool soundEnabled, bool hapticEnabled, bool darkMode, bool notificationsEnabled
});




}
/// @nodoc
class _$ChallengeConfigCopyWithImpl<$Res>
    implements $ChallengeConfigCopyWith<$Res> {
  _$ChallengeConfigCopyWithImpl(this._self, this._then);

  final ChallengeConfig _self;
  final $Res Function(ChallengeConfig) _then;

/// Create a copy of ChallengeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? soundEnabled = null,Object? hapticEnabled = null,Object? darkMode = null,Object? notificationsEnabled = null,}) {
  return _then(_self.copyWith(
soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengeConfig].
extension ChallengeConfigPatterns on ChallengeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeConfig value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool soundEnabled,  bool hapticEnabled,  bool darkMode,  bool notificationsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeConfig() when $default != null:
return $default(_that.soundEnabled,_that.hapticEnabled,_that.darkMode,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool soundEnabled,  bool hapticEnabled,  bool darkMode,  bool notificationsEnabled)  $default,) {final _that = this;
switch (_that) {
case _ChallengeConfig():
return $default(_that.soundEnabled,_that.hapticEnabled,_that.darkMode,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool soundEnabled,  bool hapticEnabled,  bool darkMode,  bool notificationsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeConfig() when $default != null:
return $default(_that.soundEnabled,_that.hapticEnabled,_that.darkMode,_that.notificationsEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengeConfig implements ChallengeConfig {
  const _ChallengeConfig({this.soundEnabled = false, this.hapticEnabled = false, this.darkMode = true, this.notificationsEnabled = true});
  factory _ChallengeConfig.fromJson(Map<String, dynamic> json) => _$ChallengeConfigFromJson(json);

@override@JsonKey() final  bool soundEnabled;
@override@JsonKey() final  bool hapticEnabled;
@override@JsonKey() final  bool darkMode;
@override@JsonKey() final  bool notificationsEnabled;

/// Create a copy of ChallengeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeConfigCopyWith<_ChallengeConfig> get copyWith => __$ChallengeConfigCopyWithImpl<_ChallengeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeConfig&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soundEnabled,hapticEnabled,darkMode,notificationsEnabled);

@override
String toString() {
  return 'ChallengeConfig(soundEnabled: $soundEnabled, hapticEnabled: $hapticEnabled, darkMode: $darkMode, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class _$ChallengeConfigCopyWith<$Res> implements $ChallengeConfigCopyWith<$Res> {
  factory _$ChallengeConfigCopyWith(_ChallengeConfig value, $Res Function(_ChallengeConfig) _then) = __$ChallengeConfigCopyWithImpl;
@override @useResult
$Res call({
 bool soundEnabled, bool hapticEnabled, bool darkMode, bool notificationsEnabled
});




}
/// @nodoc
class __$ChallengeConfigCopyWithImpl<$Res>
    implements _$ChallengeConfigCopyWith<$Res> {
  __$ChallengeConfigCopyWithImpl(this._self, this._then);

  final _ChallengeConfig _self;
  final $Res Function(_ChallengeConfig) _then;

/// Create a copy of ChallengeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? soundEnabled = null,Object? hapticEnabled = null,Object? darkMode = null,Object? notificationsEnabled = null,}) {
  return _then(_ChallengeConfig(
soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
