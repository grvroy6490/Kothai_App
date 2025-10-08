// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_handler_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionHandler {

 SessionMode get mode; SessionStatusEnum get status;
/// Create a copy of SessionHandler
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionHandlerCopyWith<SessionHandler> get copyWith => _$SessionHandlerCopyWithImpl<SessionHandler>(this as SessionHandler, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionHandler&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,mode,status);

@override
String toString() {
  return 'SessionHandler(mode: $mode, status: $status)';
}


}

/// @nodoc
abstract mixin class $SessionHandlerCopyWith<$Res>  {
  factory $SessionHandlerCopyWith(SessionHandler value, $Res Function(SessionHandler) _then) = _$SessionHandlerCopyWithImpl;
@useResult
$Res call({
 SessionMode mode, SessionStatusEnum status
});




}
/// @nodoc
class _$SessionHandlerCopyWithImpl<$Res>
    implements $SessionHandlerCopyWith<$Res> {
  _$SessionHandlerCopyWithImpl(this._self, this._then);

  final SessionHandler _self;
  final $Res Function(SessionHandler) _then;

/// Create a copy of SessionHandler
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? status = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatusEnum,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionHandler].
extension SessionHandlerPatterns on SessionHandler {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionHandler value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionHandler() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionHandler value)  $default,){
final _that = this;
switch (_that) {
case _SessionHandler():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionHandler value)?  $default,){
final _that = this;
switch (_that) {
case _SessionHandler() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionMode mode,  SessionStatusEnum status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionHandler() when $default != null:
return $default(_that.mode,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionMode mode,  SessionStatusEnum status)  $default,) {final _that = this;
switch (_that) {
case _SessionHandler():
return $default(_that.mode,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionMode mode,  SessionStatusEnum status)?  $default,) {final _that = this;
switch (_that) {
case _SessionHandler() when $default != null:
return $default(_that.mode,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _SessionHandler extends SessionHandler {
  const _SessionHandler({this.mode = SessionMode.none, this.status = SessionStatusEnum.stop}): super._();
  

@override@JsonKey() final  SessionMode mode;
@override@JsonKey() final  SessionStatusEnum status;

/// Create a copy of SessionHandler
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionHandlerCopyWith<_SessionHandler> get copyWith => __$SessionHandlerCopyWithImpl<_SessionHandler>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionHandler&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,mode,status);

@override
String toString() {
  return 'SessionHandler(mode: $mode, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SessionHandlerCopyWith<$Res> implements $SessionHandlerCopyWith<$Res> {
  factory _$SessionHandlerCopyWith(_SessionHandler value, $Res Function(_SessionHandler) _then) = __$SessionHandlerCopyWithImpl;
@override @useResult
$Res call({
 SessionMode mode, SessionStatusEnum status
});




}
/// @nodoc
class __$SessionHandlerCopyWithImpl<$Res>
    implements _$SessionHandlerCopyWith<$Res> {
  __$SessionHandlerCopyWithImpl(this._self, this._then);

  final _SessionHandler _self;
  final $Res Function(_SessionHandler) _then;

/// Create a copy of SessionHandler
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? status = null,}) {
  return _then(_SessionHandler(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatusEnum,
  ));
}


}

// dart format on
