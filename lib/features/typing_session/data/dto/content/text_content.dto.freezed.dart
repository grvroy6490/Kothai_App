// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_content.dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextContentDto {

 DifficultyEnum get difficulty; String get content; String? get topic; int? get wordCount;
/// Create a copy of TextContentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextContentDtoCopyWith<TextContentDto> get copyWith => _$TextContentDtoCopyWithImpl<TextContentDto>(this as TextContentDto, _$identity);

  /// Serializes this TextContentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextContentDto&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.content, content) || other.content == content)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,difficulty,content,topic,wordCount);

@override
String toString() {
  return 'TextContentDto(difficulty: $difficulty, content: $content, topic: $topic, wordCount: $wordCount)';
}


}

/// @nodoc
abstract mixin class $TextContentDtoCopyWith<$Res>  {
  factory $TextContentDtoCopyWith(TextContentDto value, $Res Function(TextContentDto) _then) = _$TextContentDtoCopyWithImpl;
@useResult
$Res call({
 DifficultyEnum difficulty, String content, String? topic, int? wordCount
});




}
/// @nodoc
class _$TextContentDtoCopyWithImpl<$Res>
    implements $TextContentDtoCopyWith<$Res> {
  _$TextContentDtoCopyWithImpl(this._self, this._then);

  final TextContentDto _self;
  final $Res Function(TextContentDto) _then;

/// Create a copy of TextContentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficulty = null,Object? content = null,Object? topic = freezed,Object? wordCount = freezed,}) {
  return _then(_self.copyWith(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TextContentDto].
extension TextContentDtoPatterns on TextContentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextContentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextContentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextContentDto value)  $default,){
final _that = this;
switch (_that) {
case _TextContentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextContentDto value)?  $default,){
final _that = this;
switch (_that) {
case _TextContentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DifficultyEnum difficulty,  String content,  String? topic,  int? wordCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextContentDto() when $default != null:
return $default(_that.difficulty,_that.content,_that.topic,_that.wordCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DifficultyEnum difficulty,  String content,  String? topic,  int? wordCount)  $default,) {final _that = this;
switch (_that) {
case _TextContentDto():
return $default(_that.difficulty,_that.content,_that.topic,_that.wordCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DifficultyEnum difficulty,  String content,  String? topic,  int? wordCount)?  $default,) {final _that = this;
switch (_that) {
case _TextContentDto() when $default != null:
return $default(_that.difficulty,_that.content,_that.topic,_that.wordCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextContentDto extends TextContentDto {
  const _TextContentDto({required this.difficulty, required this.content, this.topic, this.wordCount}): super._();
  factory _TextContentDto.fromJson(Map<String, dynamic> json) => _$TextContentDtoFromJson(json);

@override final  DifficultyEnum difficulty;
@override final  String content;
@override final  String? topic;
@override final  int? wordCount;

/// Create a copy of TextContentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextContentDtoCopyWith<_TextContentDto> get copyWith => __$TextContentDtoCopyWithImpl<_TextContentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextContentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextContentDto&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.content, content) || other.content == content)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,difficulty,content,topic,wordCount);

@override
String toString() {
  return 'TextContentDto(difficulty: $difficulty, content: $content, topic: $topic, wordCount: $wordCount)';
}


}

/// @nodoc
abstract mixin class _$TextContentDtoCopyWith<$Res> implements $TextContentDtoCopyWith<$Res> {
  factory _$TextContentDtoCopyWith(_TextContentDto value, $Res Function(_TextContentDto) _then) = __$TextContentDtoCopyWithImpl;
@override @useResult
$Res call({
 DifficultyEnum difficulty, String content, String? topic, int? wordCount
});




}
/// @nodoc
class __$TextContentDtoCopyWithImpl<$Res>
    implements _$TextContentDtoCopyWith<$Res> {
  __$TextContentDtoCopyWithImpl(this._self, this._then);

  final _TextContentDto _self;
  final $Res Function(_TextContentDto) _then;

/// Create a copy of TextContentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficulty = null,Object? content = null,Object? topic = freezed,Object? wordCount = freezed,}) {
  return _then(_TextContentDto(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
