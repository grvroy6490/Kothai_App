// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScoreEntity {

 int get totalXp; int get level;// derived from totalXp; stored for convenience
 int get xpIntoLevel; int get xpNextLevel;
/// Create a copy of ScoreEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreEntityCopyWith<ScoreEntity> get copyWith => _$ScoreEntityCopyWithImpl<ScoreEntity>(this as ScoreEntity, _$identity);

  /// Serializes this ScoreEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreEntity&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.level, level) || other.level == level)&&(identical(other.xpIntoLevel, xpIntoLevel) || other.xpIntoLevel == xpIntoLevel)&&(identical(other.xpNextLevel, xpNextLevel) || other.xpNextLevel == xpNextLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalXp,level,xpIntoLevel,xpNextLevel);

@override
String toString() {
  return 'ScoreEntity(totalXp: $totalXp, level: $level, xpIntoLevel: $xpIntoLevel, xpNextLevel: $xpNextLevel)';
}


}

/// @nodoc
abstract mixin class $ScoreEntityCopyWith<$Res>  {
  factory $ScoreEntityCopyWith(ScoreEntity value, $Res Function(ScoreEntity) _then) = _$ScoreEntityCopyWithImpl;
@useResult
$Res call({
 int totalXp, int level, int xpIntoLevel, int xpNextLevel
});




}
/// @nodoc
class _$ScoreEntityCopyWithImpl<$Res>
    implements $ScoreEntityCopyWith<$Res> {
  _$ScoreEntityCopyWithImpl(this._self, this._then);

  final ScoreEntity _self;
  final $Res Function(ScoreEntity) _then;

/// Create a copy of ScoreEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalXp = null,Object? level = null,Object? xpIntoLevel = null,Object? xpNextLevel = null,}) {
  return _then(_self.copyWith(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,xpIntoLevel: null == xpIntoLevel ? _self.xpIntoLevel : xpIntoLevel // ignore: cast_nullable_to_non_nullable
as int,xpNextLevel: null == xpNextLevel ? _self.xpNextLevel : xpNextLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreEntity].
extension ScoreEntityPatterns on ScoreEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreEntity value)  $default,){
final _that = this;
switch (_that) {
case _ScoreEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalXp,  int level,  int xpIntoLevel,  int xpNextLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreEntity() when $default != null:
return $default(_that.totalXp,_that.level,_that.xpIntoLevel,_that.xpNextLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalXp,  int level,  int xpIntoLevel,  int xpNextLevel)  $default,) {final _that = this;
switch (_that) {
case _ScoreEntity():
return $default(_that.totalXp,_that.level,_that.xpIntoLevel,_that.xpNextLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalXp,  int level,  int xpIntoLevel,  int xpNextLevel)?  $default,) {final _that = this;
switch (_that) {
case _ScoreEntity() when $default != null:
return $default(_that.totalXp,_that.level,_that.xpIntoLevel,_that.xpNextLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoreEntity extends ScoreEntity {
  const _ScoreEntity({this.totalXp = 0, this.level = 1, this.xpIntoLevel = 1000, this.xpNextLevel = 0}): super._();
  factory _ScoreEntity.fromJson(Map<String, dynamic> json) => _$ScoreEntityFromJson(json);

@override@JsonKey() final  int totalXp;
@override@JsonKey() final  int level;
// derived from totalXp; stored for convenience
@override@JsonKey() final  int xpIntoLevel;
@override@JsonKey() final  int xpNextLevel;

/// Create a copy of ScoreEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreEntityCopyWith<_ScoreEntity> get copyWith => __$ScoreEntityCopyWithImpl<_ScoreEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoreEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreEntity&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.level, level) || other.level == level)&&(identical(other.xpIntoLevel, xpIntoLevel) || other.xpIntoLevel == xpIntoLevel)&&(identical(other.xpNextLevel, xpNextLevel) || other.xpNextLevel == xpNextLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalXp,level,xpIntoLevel,xpNextLevel);

@override
String toString() {
  return 'ScoreEntity(totalXp: $totalXp, level: $level, xpIntoLevel: $xpIntoLevel, xpNextLevel: $xpNextLevel)';
}


}

/// @nodoc
abstract mixin class _$ScoreEntityCopyWith<$Res> implements $ScoreEntityCopyWith<$Res> {
  factory _$ScoreEntityCopyWith(_ScoreEntity value, $Res Function(_ScoreEntity) _then) = __$ScoreEntityCopyWithImpl;
@override @useResult
$Res call({
 int totalXp, int level, int xpIntoLevel, int xpNextLevel
});




}
/// @nodoc
class __$ScoreEntityCopyWithImpl<$Res>
    implements _$ScoreEntityCopyWith<$Res> {
  __$ScoreEntityCopyWithImpl(this._self, this._then);

  final _ScoreEntity _self;
  final $Res Function(_ScoreEntity) _then;

/// Create a copy of ScoreEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalXp = null,Object? level = null,Object? xpIntoLevel = null,Object? xpNextLevel = null,}) {
  return _then(_ScoreEntity(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,xpIntoLevel: null == xpIntoLevel ? _self.xpIntoLevel : xpIntoLevel // ignore: cast_nullable_to_non_nullable
as int,xpNextLevel: null == xpNextLevel ? _self.xpNextLevel : xpNextLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ScoreEntry {

 String get id;// uuid
 DateTime get at; String get mode;// "practice", "challenge", etc.
 int get amount;// e.g., 50
 bool get synced;// uploaded to cloud?
 String? get sessionId;
/// Create a copy of ScoreEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreEntryCopyWith<ScoreEntry> get copyWith => _$ScoreEntryCopyWithImpl<ScoreEntry>(this as ScoreEntry, _$identity);

  /// Serializes this ScoreEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.synced, synced) || other.synced == synced)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,at,mode,amount,synced,sessionId);

@override
String toString() {
  return 'ScoreEntry(id: $id, at: $at, mode: $mode, amount: $amount, synced: $synced, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $ScoreEntryCopyWith<$Res>  {
  factory $ScoreEntryCopyWith(ScoreEntry value, $Res Function(ScoreEntry) _then) = _$ScoreEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime at, String mode, int amount, bool synced, String? sessionId
});




}
/// @nodoc
class _$ScoreEntryCopyWithImpl<$Res>
    implements $ScoreEntryCopyWith<$Res> {
  _$ScoreEntryCopyWithImpl(this._self, this._then);

  final ScoreEntry _self;
  final $Res Function(ScoreEntry) _then;

/// Create a copy of ScoreEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? at = null,Object? mode = null,Object? amount = null,Object? synced = null,Object? sessionId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreEntry].
extension ScoreEntryPatterns on ScoreEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreEntry value)  $default,){
final _that = this;
switch (_that) {
case _ScoreEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime at,  String mode,  int amount,  bool synced,  String? sessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreEntry() when $default != null:
return $default(_that.id,_that.at,_that.mode,_that.amount,_that.synced,_that.sessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime at,  String mode,  int amount,  bool synced,  String? sessionId)  $default,) {final _that = this;
switch (_that) {
case _ScoreEntry():
return $default(_that.id,_that.at,_that.mode,_that.amount,_that.synced,_that.sessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime at,  String mode,  int amount,  bool synced,  String? sessionId)?  $default,) {final _that = this;
switch (_that) {
case _ScoreEntry() when $default != null:
return $default(_that.id,_that.at,_that.mode,_that.amount,_that.synced,_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoreEntry implements ScoreEntry {
  const _ScoreEntry({required this.id, required this.at, required this.mode, required this.amount, this.synced = false, this.sessionId});
  factory _ScoreEntry.fromJson(Map<String, dynamic> json) => _$ScoreEntryFromJson(json);

@override final  String id;
// uuid
@override final  DateTime at;
@override final  String mode;
// "practice", "challenge", etc.
@override final  int amount;
// e.g., 50
@override@JsonKey() final  bool synced;
// uploaded to cloud?
@override final  String? sessionId;

/// Create a copy of ScoreEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreEntryCopyWith<_ScoreEntry> get copyWith => __$ScoreEntryCopyWithImpl<_ScoreEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoreEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.synced, synced) || other.synced == synced)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,at,mode,amount,synced,sessionId);

@override
String toString() {
  return 'ScoreEntry(id: $id, at: $at, mode: $mode, amount: $amount, synced: $synced, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$ScoreEntryCopyWith<$Res> implements $ScoreEntryCopyWith<$Res> {
  factory _$ScoreEntryCopyWith(_ScoreEntry value, $Res Function(_ScoreEntry) _then) = __$ScoreEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime at, String mode, int amount, bool synced, String? sessionId
});




}
/// @nodoc
class __$ScoreEntryCopyWithImpl<$Res>
    implements _$ScoreEntryCopyWith<$Res> {
  __$ScoreEntryCopyWithImpl(this._self, this._then);

  final _ScoreEntry _self;
  final $Res Function(_ScoreEntry) _then;

/// Create a copy of ScoreEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? at = null,Object? mode = null,Object? amount = null,Object? synced = null,Object? sessionId = freezed,}) {
  return _then(_ScoreEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
