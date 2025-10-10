// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practice_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PracticeSettings {

 PracticeMode get mode; DifficultyEnum get difficulty; ContentLength get contentLength; ContentFontSize get contentFontSize; ConfigDisplayType get configType; bool get blindMode; bool get randomize; bool get wpmEnabled; bool get accuracyEnabled; bool get timerEnabled; bool get errorsEnabled; bool get allowPauses; bool get allowTakeBacks; bool get soundEnabled; bool get soundOnError; bool get hapticEnabled; bool get hapticOnError; bool get darkMode;
/// Create a copy of PracticeSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PracticeSettingsCopyWith<PracticeSettings> get copyWith => _$PracticeSettingsCopyWithImpl<PracticeSettings>(this as PracticeSettings, _$identity);

  /// Serializes this PracticeSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeSettings&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.contentLength, contentLength) || other.contentLength == contentLength)&&(identical(other.contentFontSize, contentFontSize) || other.contentFontSize == contentFontSize)&&(identical(other.configType, configType) || other.configType == configType)&&(identical(other.blindMode, blindMode) || other.blindMode == blindMode)&&(identical(other.randomize, randomize) || other.randomize == randomize)&&(identical(other.wpmEnabled, wpmEnabled) || other.wpmEnabled == wpmEnabled)&&(identical(other.accuracyEnabled, accuracyEnabled) || other.accuracyEnabled == accuracyEnabled)&&(identical(other.timerEnabled, timerEnabled) || other.timerEnabled == timerEnabled)&&(identical(other.errorsEnabled, errorsEnabled) || other.errorsEnabled == errorsEnabled)&&(identical(other.allowPauses, allowPauses) || other.allowPauses == allowPauses)&&(identical(other.allowTakeBacks, allowTakeBacks) || other.allowTakeBacks == allowTakeBacks)&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.soundOnError, soundOnError) || other.soundOnError == soundOnError)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.hapticOnError, hapticOnError) || other.hapticOnError == hapticOnError)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,difficulty,contentLength,contentFontSize,configType,blindMode,randomize,wpmEnabled,accuracyEnabled,timerEnabled,errorsEnabled,allowPauses,allowTakeBacks,soundEnabled,soundOnError,hapticEnabled,hapticOnError,darkMode);

@override
String toString() {
  return 'PracticeSettings(mode: $mode, difficulty: $difficulty, contentLength: $contentLength, contentFontSize: $contentFontSize, configType: $configType, blindMode: $blindMode, randomize: $randomize, wpmEnabled: $wpmEnabled, accuracyEnabled: $accuracyEnabled, timerEnabled: $timerEnabled, errorsEnabled: $errorsEnabled, allowPauses: $allowPauses, allowTakeBacks: $allowTakeBacks, soundEnabled: $soundEnabled, soundOnError: $soundOnError, hapticEnabled: $hapticEnabled, hapticOnError: $hapticOnError, darkMode: $darkMode)';
}


}

/// @nodoc
abstract mixin class $PracticeSettingsCopyWith<$Res>  {
  factory $PracticeSettingsCopyWith(PracticeSettings value, $Res Function(PracticeSettings) _then) = _$PracticeSettingsCopyWithImpl;
@useResult
$Res call({
 PracticeMode mode, DifficultyEnum difficulty, ContentLength contentLength, ContentFontSize contentFontSize, ConfigDisplayType configType, bool blindMode, bool randomize, bool wpmEnabled, bool accuracyEnabled, bool timerEnabled, bool errorsEnabled, bool allowPauses, bool allowTakeBacks, bool soundEnabled, bool soundOnError, bool hapticEnabled, bool hapticOnError, bool darkMode
});




}
/// @nodoc
class _$PracticeSettingsCopyWithImpl<$Res>
    implements $PracticeSettingsCopyWith<$Res> {
  _$PracticeSettingsCopyWithImpl(this._self, this._then);

  final PracticeSettings _self;
  final $Res Function(PracticeSettings) _then;

/// Create a copy of PracticeSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? difficulty = null,Object? contentLength = null,Object? contentFontSize = null,Object? configType = null,Object? blindMode = null,Object? randomize = null,Object? wpmEnabled = null,Object? accuracyEnabled = null,Object? timerEnabled = null,Object? errorsEnabled = null,Object? allowPauses = null,Object? allowTakeBacks = null,Object? soundEnabled = null,Object? soundOnError = null,Object? hapticEnabled = null,Object? hapticOnError = null,Object? darkMode = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PracticeMode,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,contentLength: null == contentLength ? _self.contentLength : contentLength // ignore: cast_nullable_to_non_nullable
as ContentLength,contentFontSize: null == contentFontSize ? _self.contentFontSize : contentFontSize // ignore: cast_nullable_to_non_nullable
as ContentFontSize,configType: null == configType ? _self.configType : configType // ignore: cast_nullable_to_non_nullable
as ConfigDisplayType,blindMode: null == blindMode ? _self.blindMode : blindMode // ignore: cast_nullable_to_non_nullable
as bool,randomize: null == randomize ? _self.randomize : randomize // ignore: cast_nullable_to_non_nullable
as bool,wpmEnabled: null == wpmEnabled ? _self.wpmEnabled : wpmEnabled // ignore: cast_nullable_to_non_nullable
as bool,accuracyEnabled: null == accuracyEnabled ? _self.accuracyEnabled : accuracyEnabled // ignore: cast_nullable_to_non_nullable
as bool,timerEnabled: null == timerEnabled ? _self.timerEnabled : timerEnabled // ignore: cast_nullable_to_non_nullable
as bool,errorsEnabled: null == errorsEnabled ? _self.errorsEnabled : errorsEnabled // ignore: cast_nullable_to_non_nullable
as bool,allowPauses: null == allowPauses ? _self.allowPauses : allowPauses // ignore: cast_nullable_to_non_nullable
as bool,allowTakeBacks: null == allowTakeBacks ? _self.allowTakeBacks : allowTakeBacks // ignore: cast_nullable_to_non_nullable
as bool,soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,soundOnError: null == soundOnError ? _self.soundOnError : soundOnError // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticOnError: null == hapticOnError ? _self.hapticOnError : hapticOnError // ignore: cast_nullable_to_non_nullable
as bool,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PracticeSettings].
extension PracticeSettingsPatterns on PracticeSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PracticeSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PracticeSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PracticeSettings value)  $default,){
final _that = this;
switch (_that) {
case _PracticeSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PracticeSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PracticeSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PracticeMode mode,  DifficultyEnum difficulty,  ContentLength contentLength,  ContentFontSize contentFontSize,  ConfigDisplayType configType,  bool blindMode,  bool randomize,  bool wpmEnabled,  bool accuracyEnabled,  bool timerEnabled,  bool errorsEnabled,  bool allowPauses,  bool allowTakeBacks,  bool soundEnabled,  bool soundOnError,  bool hapticEnabled,  bool hapticOnError,  bool darkMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PracticeSettings() when $default != null:
return $default(_that.mode,_that.difficulty,_that.contentLength,_that.contentFontSize,_that.configType,_that.blindMode,_that.randomize,_that.wpmEnabled,_that.accuracyEnabled,_that.timerEnabled,_that.errorsEnabled,_that.allowPauses,_that.allowTakeBacks,_that.soundEnabled,_that.soundOnError,_that.hapticEnabled,_that.hapticOnError,_that.darkMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PracticeMode mode,  DifficultyEnum difficulty,  ContentLength contentLength,  ContentFontSize contentFontSize,  ConfigDisplayType configType,  bool blindMode,  bool randomize,  bool wpmEnabled,  bool accuracyEnabled,  bool timerEnabled,  bool errorsEnabled,  bool allowPauses,  bool allowTakeBacks,  bool soundEnabled,  bool soundOnError,  bool hapticEnabled,  bool hapticOnError,  bool darkMode)  $default,) {final _that = this;
switch (_that) {
case _PracticeSettings():
return $default(_that.mode,_that.difficulty,_that.contentLength,_that.contentFontSize,_that.configType,_that.blindMode,_that.randomize,_that.wpmEnabled,_that.accuracyEnabled,_that.timerEnabled,_that.errorsEnabled,_that.allowPauses,_that.allowTakeBacks,_that.soundEnabled,_that.soundOnError,_that.hapticEnabled,_that.hapticOnError,_that.darkMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PracticeMode mode,  DifficultyEnum difficulty,  ContentLength contentLength,  ContentFontSize contentFontSize,  ConfigDisplayType configType,  bool blindMode,  bool randomize,  bool wpmEnabled,  bool accuracyEnabled,  bool timerEnabled,  bool errorsEnabled,  bool allowPauses,  bool allowTakeBacks,  bool soundEnabled,  bool soundOnError,  bool hapticEnabled,  bool hapticOnError,  bool darkMode)?  $default,) {final _that = this;
switch (_that) {
case _PracticeSettings() when $default != null:
return $default(_that.mode,_that.difficulty,_that.contentLength,_that.contentFontSize,_that.configType,_that.blindMode,_that.randomize,_that.wpmEnabled,_that.accuracyEnabled,_that.timerEnabled,_that.errorsEnabled,_that.allowPauses,_that.allowTakeBacks,_that.soundEnabled,_that.soundOnError,_that.hapticEnabled,_that.hapticOnError,_that.darkMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PracticeSettings implements PracticeSettings {
  const _PracticeSettings({this.mode = PracticeMode.normal, this.difficulty = DifficultyEnum.easy, this.contentLength = ContentLength.short, this.contentFontSize = ContentFontSize.l, this.configType = ConfigDisplayType.detailed, this.blindMode = false, this.randomize = true, this.wpmEnabled = true, this.accuracyEnabled = true, this.timerEnabled = true, this.errorsEnabled = false, this.allowPauses = true, this.allowTakeBacks = false, this.soundEnabled = false, this.soundOnError = false, this.hapticEnabled = false, this.hapticOnError = false, this.darkMode = true});
  factory _PracticeSettings.fromJson(Map<String, dynamic> json) => _$PracticeSettingsFromJson(json);

@override@JsonKey() final  PracticeMode mode;
@override@JsonKey() final  DifficultyEnum difficulty;
@override@JsonKey() final  ContentLength contentLength;
@override@JsonKey() final  ContentFontSize contentFontSize;
@override@JsonKey() final  ConfigDisplayType configType;
@override@JsonKey() final  bool blindMode;
@override@JsonKey() final  bool randomize;
@override@JsonKey() final  bool wpmEnabled;
@override@JsonKey() final  bool accuracyEnabled;
@override@JsonKey() final  bool timerEnabled;
@override@JsonKey() final  bool errorsEnabled;
@override@JsonKey() final  bool allowPauses;
@override@JsonKey() final  bool allowTakeBacks;
@override@JsonKey() final  bool soundEnabled;
@override@JsonKey() final  bool soundOnError;
@override@JsonKey() final  bool hapticEnabled;
@override@JsonKey() final  bool hapticOnError;
@override@JsonKey() final  bool darkMode;

/// Create a copy of PracticeSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PracticeSettingsCopyWith<_PracticeSettings> get copyWith => __$PracticeSettingsCopyWithImpl<_PracticeSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PracticeSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PracticeSettings&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.contentLength, contentLength) || other.contentLength == contentLength)&&(identical(other.contentFontSize, contentFontSize) || other.contentFontSize == contentFontSize)&&(identical(other.configType, configType) || other.configType == configType)&&(identical(other.blindMode, blindMode) || other.blindMode == blindMode)&&(identical(other.randomize, randomize) || other.randomize == randomize)&&(identical(other.wpmEnabled, wpmEnabled) || other.wpmEnabled == wpmEnabled)&&(identical(other.accuracyEnabled, accuracyEnabled) || other.accuracyEnabled == accuracyEnabled)&&(identical(other.timerEnabled, timerEnabled) || other.timerEnabled == timerEnabled)&&(identical(other.errorsEnabled, errorsEnabled) || other.errorsEnabled == errorsEnabled)&&(identical(other.allowPauses, allowPauses) || other.allowPauses == allowPauses)&&(identical(other.allowTakeBacks, allowTakeBacks) || other.allowTakeBacks == allowTakeBacks)&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.soundOnError, soundOnError) || other.soundOnError == soundOnError)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.hapticOnError, hapticOnError) || other.hapticOnError == hapticOnError)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,difficulty,contentLength,contentFontSize,configType,blindMode,randomize,wpmEnabled,accuracyEnabled,timerEnabled,errorsEnabled,allowPauses,allowTakeBacks,soundEnabled,soundOnError,hapticEnabled,hapticOnError,darkMode);

@override
String toString() {
  return 'PracticeSettings(mode: $mode, difficulty: $difficulty, contentLength: $contentLength, contentFontSize: $contentFontSize, configType: $configType, blindMode: $blindMode, randomize: $randomize, wpmEnabled: $wpmEnabled, accuracyEnabled: $accuracyEnabled, timerEnabled: $timerEnabled, errorsEnabled: $errorsEnabled, allowPauses: $allowPauses, allowTakeBacks: $allowTakeBacks, soundEnabled: $soundEnabled, soundOnError: $soundOnError, hapticEnabled: $hapticEnabled, hapticOnError: $hapticOnError, darkMode: $darkMode)';
}


}

/// @nodoc
abstract mixin class _$PracticeSettingsCopyWith<$Res> implements $PracticeSettingsCopyWith<$Res> {
  factory _$PracticeSettingsCopyWith(_PracticeSettings value, $Res Function(_PracticeSettings) _then) = __$PracticeSettingsCopyWithImpl;
@override @useResult
$Res call({
 PracticeMode mode, DifficultyEnum difficulty, ContentLength contentLength, ContentFontSize contentFontSize, ConfigDisplayType configType, bool blindMode, bool randomize, bool wpmEnabled, bool accuracyEnabled, bool timerEnabled, bool errorsEnabled, bool allowPauses, bool allowTakeBacks, bool soundEnabled, bool soundOnError, bool hapticEnabled, bool hapticOnError, bool darkMode
});




}
/// @nodoc
class __$PracticeSettingsCopyWithImpl<$Res>
    implements _$PracticeSettingsCopyWith<$Res> {
  __$PracticeSettingsCopyWithImpl(this._self, this._then);

  final _PracticeSettings _self;
  final $Res Function(_PracticeSettings) _then;

/// Create a copy of PracticeSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? difficulty = null,Object? contentLength = null,Object? contentFontSize = null,Object? configType = null,Object? blindMode = null,Object? randomize = null,Object? wpmEnabled = null,Object? accuracyEnabled = null,Object? timerEnabled = null,Object? errorsEnabled = null,Object? allowPauses = null,Object? allowTakeBacks = null,Object? soundEnabled = null,Object? soundOnError = null,Object? hapticEnabled = null,Object? hapticOnError = null,Object? darkMode = null,}) {
  return _then(_PracticeSettings(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PracticeMode,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,contentLength: null == contentLength ? _self.contentLength : contentLength // ignore: cast_nullable_to_non_nullable
as ContentLength,contentFontSize: null == contentFontSize ? _self.contentFontSize : contentFontSize // ignore: cast_nullable_to_non_nullable
as ContentFontSize,configType: null == configType ? _self.configType : configType // ignore: cast_nullable_to_non_nullable
as ConfigDisplayType,blindMode: null == blindMode ? _self.blindMode : blindMode // ignore: cast_nullable_to_non_nullable
as bool,randomize: null == randomize ? _self.randomize : randomize // ignore: cast_nullable_to_non_nullable
as bool,wpmEnabled: null == wpmEnabled ? _self.wpmEnabled : wpmEnabled // ignore: cast_nullable_to_non_nullable
as bool,accuracyEnabled: null == accuracyEnabled ? _self.accuracyEnabled : accuracyEnabled // ignore: cast_nullable_to_non_nullable
as bool,timerEnabled: null == timerEnabled ? _self.timerEnabled : timerEnabled // ignore: cast_nullable_to_non_nullable
as bool,errorsEnabled: null == errorsEnabled ? _self.errorsEnabled : errorsEnabled // ignore: cast_nullable_to_non_nullable
as bool,allowPauses: null == allowPauses ? _self.allowPauses : allowPauses // ignore: cast_nullable_to_non_nullable
as bool,allowTakeBacks: null == allowTakeBacks ? _self.allowTakeBacks : allowTakeBacks // ignore: cast_nullable_to_non_nullable
as bool,soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,soundOnError: null == soundOnError ? _self.soundOnError : soundOnError // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticOnError: null == hapticOnError ? _self.hapticOnError : hapticOnError // ignore: cast_nullable_to_non_nullable
as bool,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
