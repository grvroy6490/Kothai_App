// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_paragraph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextParagraph {

 DifficultyEnum get difficulty; String get content;
/// Create a copy of TextParagraph
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextParagraphCopyWith<TextParagraph> get copyWith => _$TextParagraphCopyWithImpl<TextParagraph>(this as TextParagraph, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextParagraph&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,difficulty,content);

@override
String toString() {
  return 'TextParagraph(difficulty: $difficulty, content: $content)';
}


}

/// @nodoc
abstract mixin class $TextParagraphCopyWith<$Res>  {
  factory $TextParagraphCopyWith(TextParagraph value, $Res Function(TextParagraph) _then) = _$TextParagraphCopyWithImpl;
@useResult
$Res call({
 DifficultyEnum difficulty, String content
});




}
/// @nodoc
class _$TextParagraphCopyWithImpl<$Res>
    implements $TextParagraphCopyWith<$Res> {
  _$TextParagraphCopyWithImpl(this._self, this._then);

  final TextParagraph _self;
  final $Res Function(TextParagraph) _then;

/// Create a copy of TextParagraph
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficulty = null,Object? content = null,}) {
  return _then(_self.copyWith(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TextParagraph].
extension TextParagraphPatterns on TextParagraph {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextParagraph value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextParagraph() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextParagraph value)  $default,){
final _that = this;
switch (_that) {
case _TextParagraph():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextParagraph value)?  $default,){
final _that = this;
switch (_that) {
case _TextParagraph() when $default != null:
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
case _TextParagraph() when $default != null:
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
case _TextParagraph():
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
case _TextParagraph() when $default != null:
return $default(_that.difficulty,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _TextParagraph implements TextParagraph {
  const _TextParagraph({required this.difficulty, required this.content});
  

@override final  DifficultyEnum difficulty;
@override final  String content;

/// Create a copy of TextParagraph
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextParagraphCopyWith<_TextParagraph> get copyWith => __$TextParagraphCopyWithImpl<_TextParagraph>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextParagraph&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,difficulty,content);

@override
String toString() {
  return 'TextParagraph(difficulty: $difficulty, content: $content)';
}


}

/// @nodoc
abstract mixin class _$TextParagraphCopyWith<$Res> implements $TextParagraphCopyWith<$Res> {
  factory _$TextParagraphCopyWith(_TextParagraph value, $Res Function(_TextParagraph) _then) = __$TextParagraphCopyWithImpl;
@override @useResult
$Res call({
 DifficultyEnum difficulty, String content
});




}
/// @nodoc
class __$TextParagraphCopyWithImpl<$Res>
    implements _$TextParagraphCopyWith<$Res> {
  __$TextParagraphCopyWithImpl(this._self, this._then);

  final _TextParagraph _self;
  final $Res Function(_TextParagraph) _then;

/// Create a copy of TextParagraph
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficulty = null,Object? content = null,}) {
  return _then(_TextParagraph(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
