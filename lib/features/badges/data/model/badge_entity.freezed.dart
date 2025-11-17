// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BadgeEntity {

 String get id; String get name; String get tier; BadgeType get type; String get condition; String get toastMessage; String get imagePath;
/// Create a copy of BadgeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeEntityCopyWith<BadgeEntity> get copyWith => _$BadgeEntityCopyWithImpl<BadgeEntity>(this as BadgeEntity, _$identity);

  /// Serializes this BadgeEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.type, type) || other.type == type)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,tier,type,condition,toastMessage,imagePath);

@override
String toString() {
  return 'BadgeEntity(id: $id, name: $name, tier: $tier, type: $type, condition: $condition, toastMessage: $toastMessage, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class $BadgeEntityCopyWith<$Res>  {
  factory $BadgeEntityCopyWith(BadgeEntity value, $Res Function(BadgeEntity) _then) = _$BadgeEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String tier, BadgeType type, String condition, String toastMessage, String imagePath
});




}
/// @nodoc
class _$BadgeEntityCopyWithImpl<$Res>
    implements $BadgeEntityCopyWith<$Res> {
  _$BadgeEntityCopyWithImpl(this._self, this._then);

  final BadgeEntity _self;
  final $Res Function(BadgeEntity) _then;

/// Create a copy of BadgeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? tier = null,Object? type = null,Object? condition = null,Object? toastMessage = null,Object? imagePath = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BadgeType,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,toastMessage: null == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeEntity].
extension BadgeEntityPatterns on BadgeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeEntity value)  $default,){
final _that = this;
switch (_that) {
case _BadgeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String tier,  BadgeType type,  String condition,  String toastMessage,  String imagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgeEntity() when $default != null:
return $default(_that.id,_that.name,_that.tier,_that.type,_that.condition,_that.toastMessage,_that.imagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String tier,  BadgeType type,  String condition,  String toastMessage,  String imagePath)  $default,) {final _that = this;
switch (_that) {
case _BadgeEntity():
return $default(_that.id,_that.name,_that.tier,_that.type,_that.condition,_that.toastMessage,_that.imagePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String tier,  BadgeType type,  String condition,  String toastMessage,  String imagePath)?  $default,) {final _that = this;
switch (_that) {
case _BadgeEntity() when $default != null:
return $default(_that.id,_that.name,_that.tier,_that.type,_that.condition,_that.toastMessage,_that.imagePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BadgeEntity implements BadgeEntity {
  const _BadgeEntity({required this.id, required this.name, required this.tier, required this.type, required this.condition, required this.toastMessage, required this.imagePath});
  factory _BadgeEntity.fromJson(Map<String, dynamic> json) => _$BadgeEntityFromJson(json);

@override final  String id;
@override final  String name;
@override final  String tier;
@override final  BadgeType type;
@override final  String condition;
@override final  String toastMessage;
@override final  String imagePath;

/// Create a copy of BadgeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeEntityCopyWith<_BadgeEntity> get copyWith => __$BadgeEntityCopyWithImpl<_BadgeEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.type, type) || other.type == type)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,tier,type,condition,toastMessage,imagePath);

@override
String toString() {
  return 'BadgeEntity(id: $id, name: $name, tier: $tier, type: $type, condition: $condition, toastMessage: $toastMessage, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class _$BadgeEntityCopyWith<$Res> implements $BadgeEntityCopyWith<$Res> {
  factory _$BadgeEntityCopyWith(_BadgeEntity value, $Res Function(_BadgeEntity) _then) = __$BadgeEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String tier, BadgeType type, String condition, String toastMessage, String imagePath
});




}
/// @nodoc
class __$BadgeEntityCopyWithImpl<$Res>
    implements _$BadgeEntityCopyWith<$Res> {
  __$BadgeEntityCopyWithImpl(this._self, this._then);

  final _BadgeEntity _self;
  final $Res Function(_BadgeEntity) _then;

/// Create a copy of BadgeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? tier = null,Object? type = null,Object? condition = null,Object? toastMessage = null,Object? imagePath = null,}) {
  return _then(_BadgeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BadgeType,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,toastMessage: null == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
