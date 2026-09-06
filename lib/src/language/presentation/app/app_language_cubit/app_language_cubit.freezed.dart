// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_language_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppLanguageState {

 Locale? get locale;
/// Create a copy of AppLanguageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLanguageStateCopyWith<AppLanguageState> get copyWith => _$AppLanguageStateCopyWithImpl<AppLanguageState>(this as AppLanguageState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppLanguageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLanguageState&&(identical(other.locale, _this.locale) || other.locale == _this.locale));
}


@override
int get hashCode {
  final _this = this as AppLanguageState;
  return Object.hash(runtimeType,_this.locale);
}

@override
String toString() {
  final _this = this as AppLanguageState;
  return 'AppLanguageState(locale: ${_this.locale})';
}


}

/// @nodoc
abstract mixin class $AppLanguageStateCopyWith<$Res>  {
  factory $AppLanguageStateCopyWith(AppLanguageState value, $Res Function(AppLanguageState) _then) = _$AppLanguageStateCopyWithImpl;
@useResult
$Res call({
 Locale? locale
});




}
/// @nodoc
class _$AppLanguageStateCopyWithImpl<$Res>
    implements $AppLanguageStateCopyWith<$Res> {
  _$AppLanguageStateCopyWithImpl(this._self, this._then);

  final AppLanguageState _self;
  final $Res Function(AppLanguageState) _then;

/// Create a copy of AppLanguageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locale = freezed,}) {
  return _then(AppLanguageState.initial(
freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppLanguageState].
extension AppLanguageStatePatterns on AppLanguageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _initialState value)?  initial,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _initialState value)  initial,}){
final _that = this;
switch (_that) {
case _initialState():
return initial(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _initialState value)?  initial,}){
final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Locale? locale)?  initial,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial(_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Locale? locale)  initial,}) {final _that = this;
switch (_that) {
case _initialState():
return initial(_that.locale);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Locale? locale)?  initial,}) {final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial(_that.locale);case _:
  return null;

}
}

}

/// @nodoc


class _initialState implements AppLanguageState {
  const _initialState(this.locale);
  

@override final  Locale? locale;

/// Create a copy of AppLanguageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$initialStateCopyWith<_initialState> get copyWith => __$initialStateCopyWithImpl<_initialState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _initialState&&(identical(other.locale, locale) || other.locale == locale));
}


@override
int get hashCode {
    return Object.hash(runtimeType,locale);
}

@override
String toString() {
    return 'AppLanguageState.initial(locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$initialStateCopyWith<$Res> implements $AppLanguageStateCopyWith<$Res> {
  factory _$initialStateCopyWith(_initialState value, $Res Function(_initialState) _then) = __$initialStateCopyWithImpl;
@override @useResult
$Res call({
 Locale? locale
});




}
/// @nodoc
class __$initialStateCopyWithImpl<$Res>
    implements _$initialStateCopyWith<$Res> {
  __$initialStateCopyWithImpl(this._self, this._then);

  final _initialState _self;
  final $Res Function(_initialState) _then;

/// Create a copy of AppLanguageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locale = freezed,}) {
  return _then(_initialState(
freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,
  ));
}


}

// dart format on
