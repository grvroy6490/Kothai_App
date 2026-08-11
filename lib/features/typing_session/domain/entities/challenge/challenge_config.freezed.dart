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

 bool get soundEnabled; bool get hapticEnabled; bool get darkMode;/// Master switch — gates all OS + in-app notification surfaces.
 bool get notificationsEnabled;/// Daily practice reminder at the configured time.
 bool get dailyRemindersEnabled;/// Evening streak-at-risk + comeback win-back reminders.
 bool get streakAlertsEnabled;/// Badge unlock + level-up local notifications (and in-app feed rows).
 bool get achievementAlertsEnabled;/// Remote FCM product / content announcements.
 bool get productUpdatesEnabled;
/// Create a copy of ChallengeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeConfigCopyWith<ChallengeConfig> get copyWith => _$ChallengeConfigCopyWithImpl<ChallengeConfig>(this as ChallengeConfig, _$identity);

  /// Serializes this ChallengeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeConfig&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailyRemindersEnabled, dailyRemindersEnabled) || other.dailyRemindersEnabled == dailyRemindersEnabled)&&(identical(other.streakAlertsEnabled, streakAlertsEnabled) || other.streakAlertsEnabled == streakAlertsEnabled)&&(identical(other.achievementAlertsEnabled, achievementAlertsEnabled) || other.achievementAlertsEnabled == achievementAlertsEnabled)&&(identical(other.productUpdatesEnabled, productUpdatesEnabled) || other.productUpdatesEnabled == productUpdatesEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soundEnabled,hapticEnabled,darkMode,notificationsEnabled,dailyRemindersEnabled,streakAlertsEnabled,achievementAlertsEnabled,productUpdatesEnabled);

@override
String toString() {
  return 'ChallengeConfig(soundEnabled: $soundEnabled, hapticEnabled: $hapticEnabled, darkMode: $darkMode, notificationsEnabled: $notificationsEnabled, dailyRemindersEnabled: $dailyRemindersEnabled, streakAlertsEnabled: $streakAlertsEnabled, achievementAlertsEnabled: $achievementAlertsEnabled, productUpdatesEnabled: $productUpdatesEnabled)';
}


}

/// @nodoc
abstract mixin class $ChallengeConfigCopyWith<$Res>  {
  factory $ChallengeConfigCopyWith(ChallengeConfig value, $Res Function(ChallengeConfig) _then) = _$ChallengeConfigCopyWithImpl;
@useResult
$Res call({
 bool soundEnabled, bool hapticEnabled, bool darkMode, bool notificationsEnabled, bool dailyRemindersEnabled, bool streakAlertsEnabled, bool achievementAlertsEnabled, bool productUpdatesEnabled
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
@pragma('vm:prefer-inline') @override $Res call({Object? soundEnabled = null,Object? hapticEnabled = null,Object? darkMode = null,Object? notificationsEnabled = null,Object? dailyRemindersEnabled = null,Object? streakAlertsEnabled = null,Object? achievementAlertsEnabled = null,Object? productUpdatesEnabled = null,}) {
  return _then(_self.copyWith(
soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyRemindersEnabled: null == dailyRemindersEnabled ? _self.dailyRemindersEnabled : dailyRemindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,streakAlertsEnabled: null == streakAlertsEnabled ? _self.streakAlertsEnabled : streakAlertsEnabled // ignore: cast_nullable_to_non_nullable
as bool,achievementAlertsEnabled: null == achievementAlertsEnabled ? _self.achievementAlertsEnabled : achievementAlertsEnabled // ignore: cast_nullable_to_non_nullable
as bool,productUpdatesEnabled: null == productUpdatesEnabled ? _self.productUpdatesEnabled : productUpdatesEnabled // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool soundEnabled,  bool hapticEnabled,  bool darkMode,  bool notificationsEnabled,  bool dailyRemindersEnabled,  bool streakAlertsEnabled,  bool achievementAlertsEnabled,  bool productUpdatesEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeConfig() when $default != null:
return $default(_that.soundEnabled,_that.hapticEnabled,_that.darkMode,_that.notificationsEnabled,_that.dailyRemindersEnabled,_that.streakAlertsEnabled,_that.achievementAlertsEnabled,_that.productUpdatesEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool soundEnabled,  bool hapticEnabled,  bool darkMode,  bool notificationsEnabled,  bool dailyRemindersEnabled,  bool streakAlertsEnabled,  bool achievementAlertsEnabled,  bool productUpdatesEnabled)  $default,) {final _that = this;
switch (_that) {
case _ChallengeConfig():
return $default(_that.soundEnabled,_that.hapticEnabled,_that.darkMode,_that.notificationsEnabled,_that.dailyRemindersEnabled,_that.streakAlertsEnabled,_that.achievementAlertsEnabled,_that.productUpdatesEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool soundEnabled,  bool hapticEnabled,  bool darkMode,  bool notificationsEnabled,  bool dailyRemindersEnabled,  bool streakAlertsEnabled,  bool achievementAlertsEnabled,  bool productUpdatesEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeConfig() when $default != null:
return $default(_that.soundEnabled,_that.hapticEnabled,_that.darkMode,_that.notificationsEnabled,_that.dailyRemindersEnabled,_that.streakAlertsEnabled,_that.achievementAlertsEnabled,_that.productUpdatesEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengeConfig implements ChallengeConfig {
  const _ChallengeConfig({this.soundEnabled = false, this.hapticEnabled = false, this.darkMode = true, this.notificationsEnabled = true, this.dailyRemindersEnabled = true, this.streakAlertsEnabled = true, this.achievementAlertsEnabled = true, this.productUpdatesEnabled = true});
  factory _ChallengeConfig.fromJson(Map<String, dynamic> json) => _$ChallengeConfigFromJson(json);

@override@JsonKey() final  bool soundEnabled;
@override@JsonKey() final  bool hapticEnabled;
@override@JsonKey() final  bool darkMode;
/// Master switch — gates all OS + in-app notification surfaces.
@override@JsonKey() final  bool notificationsEnabled;
/// Daily practice reminder at the configured time.
@override@JsonKey() final  bool dailyRemindersEnabled;
/// Evening streak-at-risk + comeback win-back reminders.
@override@JsonKey() final  bool streakAlertsEnabled;
/// Badge unlock + level-up local notifications (and in-app feed rows).
@override@JsonKey() final  bool achievementAlertsEnabled;
/// Remote FCM product / content announcements.
@override@JsonKey() final  bool productUpdatesEnabled;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeConfig&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailyRemindersEnabled, dailyRemindersEnabled) || other.dailyRemindersEnabled == dailyRemindersEnabled)&&(identical(other.streakAlertsEnabled, streakAlertsEnabled) || other.streakAlertsEnabled == streakAlertsEnabled)&&(identical(other.achievementAlertsEnabled, achievementAlertsEnabled) || other.achievementAlertsEnabled == achievementAlertsEnabled)&&(identical(other.productUpdatesEnabled, productUpdatesEnabled) || other.productUpdatesEnabled == productUpdatesEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soundEnabled,hapticEnabled,darkMode,notificationsEnabled,dailyRemindersEnabled,streakAlertsEnabled,achievementAlertsEnabled,productUpdatesEnabled);

@override
String toString() {
  return 'ChallengeConfig(soundEnabled: $soundEnabled, hapticEnabled: $hapticEnabled, darkMode: $darkMode, notificationsEnabled: $notificationsEnabled, dailyRemindersEnabled: $dailyRemindersEnabled, streakAlertsEnabled: $streakAlertsEnabled, achievementAlertsEnabled: $achievementAlertsEnabled, productUpdatesEnabled: $productUpdatesEnabled)';
}


}

/// @nodoc
abstract mixin class _$ChallengeConfigCopyWith<$Res> implements $ChallengeConfigCopyWith<$Res> {
  factory _$ChallengeConfigCopyWith(_ChallengeConfig value, $Res Function(_ChallengeConfig) _then) = __$ChallengeConfigCopyWithImpl;
@override @useResult
$Res call({
 bool soundEnabled, bool hapticEnabled, bool darkMode, bool notificationsEnabled, bool dailyRemindersEnabled, bool streakAlertsEnabled, bool achievementAlertsEnabled, bool productUpdatesEnabled
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
@override @pragma('vm:prefer-inline') $Res call({Object? soundEnabled = null,Object? hapticEnabled = null,Object? darkMode = null,Object? notificationsEnabled = null,Object? dailyRemindersEnabled = null,Object? streakAlertsEnabled = null,Object? achievementAlertsEnabled = null,Object? productUpdatesEnabled = null,}) {
  return _then(_ChallengeConfig(
soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyRemindersEnabled: null == dailyRemindersEnabled ? _self.dailyRemindersEnabled : dailyRemindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,streakAlertsEnabled: null == streakAlertsEnabled ? _self.streakAlertsEnabled : streakAlertsEnabled // ignore: cast_nullable_to_non_nullable
as bool,achievementAlertsEnabled: null == achievementAlertsEnabled ? _self.achievementAlertsEnabled : achievementAlertsEnabled // ignore: cast_nullable_to_non_nullable
as bool,productUpdatesEnabled: null == productUpdatesEnabled ? _self.productUpdatesEnabled : productUpdatesEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
