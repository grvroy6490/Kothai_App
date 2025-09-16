// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'xp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$XpTotals {

 int get totalXp; int get level;// derived from totalXp; stored for convenience
 int get xpIntoLevel;// totalXp % xpPerLevel
 int get xpPerLevel;
/// Create a copy of XpTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XpTotalsCopyWith<XpTotals> get copyWith => _$XpTotalsCopyWithImpl<XpTotals>(this as XpTotals, _$identity);

  /// Serializes this XpTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XpTotals&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.level, level) || other.level == level)&&(identical(other.xpIntoLevel, xpIntoLevel) || other.xpIntoLevel == xpIntoLevel)&&(identical(other.xpPerLevel, xpPerLevel) || other.xpPerLevel == xpPerLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalXp,level,xpIntoLevel,xpPerLevel);

@override
String toString() {
  return 'XpTotals(totalXp: $totalXp, level: $level, xpIntoLevel: $xpIntoLevel, xpPerLevel: $xpPerLevel)';
}


}

/// @nodoc
abstract mixin class $XpTotalsCopyWith<$Res>  {
  factory $XpTotalsCopyWith(XpTotals value, $Res Function(XpTotals) _then) = _$XpTotalsCopyWithImpl;
@useResult
$Res call({
 int totalXp, int level, int xpIntoLevel, int xpPerLevel
});




}
/// @nodoc
class _$XpTotalsCopyWithImpl<$Res>
    implements $XpTotalsCopyWith<$Res> {
  _$XpTotalsCopyWithImpl(this._self, this._then);

  final XpTotals _self;
  final $Res Function(XpTotals) _then;

/// Create a copy of XpTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalXp = null,Object? level = null,Object? xpIntoLevel = null,Object? xpPerLevel = null,}) {
  return _then(_self.copyWith(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,xpIntoLevel: null == xpIntoLevel ? _self.xpIntoLevel : xpIntoLevel // ignore: cast_nullable_to_non_nullable
as int,xpPerLevel: null == xpPerLevel ? _self.xpPerLevel : xpPerLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [XpTotals].
extension XpTotalsPatterns on XpTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XpTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XpTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XpTotals value)  $default,){
final _that = this;
switch (_that) {
case _XpTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XpTotals value)?  $default,){
final _that = this;
switch (_that) {
case _XpTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalXp,  int level,  int xpIntoLevel,  int xpPerLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XpTotals() when $default != null:
return $default(_that.totalXp,_that.level,_that.xpIntoLevel,_that.xpPerLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalXp,  int level,  int xpIntoLevel,  int xpPerLevel)  $default,) {final _that = this;
switch (_that) {
case _XpTotals():
return $default(_that.totalXp,_that.level,_that.xpIntoLevel,_that.xpPerLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalXp,  int level,  int xpIntoLevel,  int xpPerLevel)?  $default,) {final _that = this;
switch (_that) {
case _XpTotals() when $default != null:
return $default(_that.totalXp,_that.level,_that.xpIntoLevel,_that.xpPerLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XpTotals extends XpTotals {
  const _XpTotals({this.totalXp = 0, this.level = 1, this.xpIntoLevel = 0, this.xpPerLevel = 200}): super._();
  factory _XpTotals.fromJson(Map<String, dynamic> json) => _$XpTotalsFromJson(json);

@override@JsonKey() final  int totalXp;
@override@JsonKey() final  int level;
// derived from totalXp; stored for convenience
@override@JsonKey() final  int xpIntoLevel;
// totalXp % xpPerLevel
@override@JsonKey() final  int xpPerLevel;

/// Create a copy of XpTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XpTotalsCopyWith<_XpTotals> get copyWith => __$XpTotalsCopyWithImpl<_XpTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XpTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XpTotals&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.level, level) || other.level == level)&&(identical(other.xpIntoLevel, xpIntoLevel) || other.xpIntoLevel == xpIntoLevel)&&(identical(other.xpPerLevel, xpPerLevel) || other.xpPerLevel == xpPerLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalXp,level,xpIntoLevel,xpPerLevel);

@override
String toString() {
  return 'XpTotals(totalXp: $totalXp, level: $level, xpIntoLevel: $xpIntoLevel, xpPerLevel: $xpPerLevel)';
}


}

/// @nodoc
abstract mixin class _$XpTotalsCopyWith<$Res> implements $XpTotalsCopyWith<$Res> {
  factory _$XpTotalsCopyWith(_XpTotals value, $Res Function(_XpTotals) _then) = __$XpTotalsCopyWithImpl;
@override @useResult
$Res call({
 int totalXp, int level, int xpIntoLevel, int xpPerLevel
});




}
/// @nodoc
class __$XpTotalsCopyWithImpl<$Res>
    implements _$XpTotalsCopyWith<$Res> {
  __$XpTotalsCopyWithImpl(this._self, this._then);

  final _XpTotals _self;
  final $Res Function(_XpTotals) _then;

/// Create a copy of XpTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalXp = null,Object? level = null,Object? xpIntoLevel = null,Object? xpPerLevel = null,}) {
  return _then(_XpTotals(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,xpIntoLevel: null == xpIntoLevel ? _self.xpIntoLevel : xpIntoLevel // ignore: cast_nullable_to_non_nullable
as int,xpPerLevel: null == xpPerLevel ? _self.xpPerLevel : xpPerLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$XpEntry {

 String get id;// uuid
 DateTime get at; String get mode;// "practice", "challenge", etc.
 int get amount;// e.g., 50
 bool get synced;// uploaded to cloud?
 String? get sessionId;
/// Create a copy of XpEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XpEntryCopyWith<XpEntry> get copyWith => _$XpEntryCopyWithImpl<XpEntry>(this as XpEntry, _$identity);

  /// Serializes this XpEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XpEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.synced, synced) || other.synced == synced)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,at,mode,amount,synced,sessionId);

@override
String toString() {
  return 'XpEntry(id: $id, at: $at, mode: $mode, amount: $amount, synced: $synced, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $XpEntryCopyWith<$Res>  {
  factory $XpEntryCopyWith(XpEntry value, $Res Function(XpEntry) _then) = _$XpEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime at, String mode, int amount, bool synced, String? sessionId
});




}
/// @nodoc
class _$XpEntryCopyWithImpl<$Res>
    implements $XpEntryCopyWith<$Res> {
  _$XpEntryCopyWithImpl(this._self, this._then);

  final XpEntry _self;
  final $Res Function(XpEntry) _then;

/// Create a copy of XpEntry
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


/// Adds pattern-matching-related methods to [XpEntry].
extension XpEntryPatterns on XpEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XpEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XpEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XpEntry value)  $default,){
final _that = this;
switch (_that) {
case _XpEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XpEntry value)?  $default,){
final _that = this;
switch (_that) {
case _XpEntry() when $default != null:
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
case _XpEntry() when $default != null:
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
case _XpEntry():
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
case _XpEntry() when $default != null:
return $default(_that.id,_that.at,_that.mode,_that.amount,_that.synced,_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XpEntry implements XpEntry {
  const _XpEntry({required this.id, required this.at, required this.mode, required this.amount, this.synced = false, this.sessionId});
  factory _XpEntry.fromJson(Map<String, dynamic> json) => _$XpEntryFromJson(json);

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

/// Create a copy of XpEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XpEntryCopyWith<_XpEntry> get copyWith => __$XpEntryCopyWithImpl<_XpEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XpEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XpEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.synced, synced) || other.synced == synced)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,at,mode,amount,synced,sessionId);

@override
String toString() {
  return 'XpEntry(id: $id, at: $at, mode: $mode, amount: $amount, synced: $synced, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$XpEntryCopyWith<$Res> implements $XpEntryCopyWith<$Res> {
  factory _$XpEntryCopyWith(_XpEntry value, $Res Function(_XpEntry) _then) = __$XpEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime at, String mode, int amount, bool synced, String? sessionId
});




}
/// @nodoc
class __$XpEntryCopyWithImpl<$Res>
    implements _$XpEntryCopyWith<$Res> {
  __$XpEntryCopyWithImpl(this._self, this._then);

  final _XpEntry _self;
  final $Res Function(_XpEntry) _then;

/// Create a copy of XpEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? at = null,Object? mode = null,Object? amount = null,Object? synced = null,Object? sessionId = freezed,}) {
  return _then(_XpEntry(
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
