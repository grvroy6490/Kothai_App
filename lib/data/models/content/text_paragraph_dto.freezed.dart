// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_paragraph_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextParagraphDto {

 DifficultyEnum get difficulty; String get content;
/// Create a copy of TextParagraphDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextParagraphDtoCopyWith<TextParagraphDto> get copyWith => _$TextParagraphDtoCopyWithImpl<TextParagraphDto>(this as TextParagraphDto, _$identity);

  /// Serializes this TextParagraphDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextParagraphDto&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,difficulty,content);

@override
String toString() {
  return 'TextParagraphDto(difficulty: $difficulty, content: $content)';
}


}

/// @nodoc
abstract mixin class $TextParagraphDtoCopyWith<$Res>  {
  factory $TextParagraphDtoCopyWith(TextParagraphDto value, $Res Function(TextParagraphDto) _then) = _$TextParagraphDtoCopyWithImpl;
@useResult
$Res call({
 DifficultyEnum difficulty, String content
});




}
/// @nodoc
class _$TextParagraphDtoCopyWithImpl<$Res>
    implements $TextParagraphDtoCopyWith<$Res> {
  _$TextParagraphDtoCopyWithImpl(this._self, this._then);

  final TextParagraphDto _self;
  final $Res Function(TextParagraphDto) _then;

/// Create a copy of TextParagraphDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficulty = null,Object? content = null,}) {
  return _then(_self.copyWith(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TextParagraphDto].
extension TextParagraphDtoPatterns on TextParagraphDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextParagraphDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextParagraphDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextParagraphDto value)  $default,){
final _that = this;
switch (_that) {
case _TextParagraphDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextParagraphDto value)?  $default,){
final _that = this;
switch (_that) {
case _TextParagraphDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DifficultyEnum difficulty,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextParagraphDto() when $default != null:
return $default(_that.difficulty,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DifficultyEnum difficulty,  String content)  $default,) {final _that = this;
switch (_that) {
case _TextParagraphDto():
return $default(_that.difficulty,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DifficultyEnum difficulty,  String content)?  $default,) {final _that = this;
switch (_that) {
case _TextParagraphDto() when $default != null:
return $default(_that.difficulty,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextParagraphDto extends TextParagraphDto {
  const _TextParagraphDto({required this.difficulty, required this.content}): super._();
  factory _TextParagraphDto.fromJson(Map<String, dynamic> json) => _$TextParagraphDtoFromJson(json);

@override final  DifficultyEnum difficulty;
@override final  String content;

/// Create a copy of TextParagraphDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextParagraphDtoCopyWith<_TextParagraphDto> get copyWith => __$TextParagraphDtoCopyWithImpl<_TextParagraphDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextParagraphDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextParagraphDto&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,difficulty,content);

@override
String toString() {
  return 'TextParagraphDto(difficulty: $difficulty, content: $content)';
}


}

/// @nodoc
abstract mixin class _$TextParagraphDtoCopyWith<$Res> implements $TextParagraphDtoCopyWith<$Res> {
  factory _$TextParagraphDtoCopyWith(_TextParagraphDto value, $Res Function(_TextParagraphDto) _then) = __$TextParagraphDtoCopyWithImpl;
@override @useResult
$Res call({
 DifficultyEnum difficulty, String content
});




}
/// @nodoc
class __$TextParagraphDtoCopyWithImpl<$Res>
    implements _$TextParagraphDtoCopyWith<$Res> {
  __$TextParagraphDtoCopyWithImpl(this._self, this._then);

  final _TextParagraphDto _self;
  final $Res Function(_TextParagraphDto) _then;

/// Create a copy of TextParagraphDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficulty = null,Object? content = null,}) {
  return _then(_TextParagraphDto(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
