// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_me_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetUserMeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetUserMeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetUserMeState()';
}


}

/// @nodoc
class $GetUserMeStateCopyWith<$Res>  {
$GetUserMeStateCopyWith(GetUserMeState _, $Res Function(GetUserMeState) __);
}


/// Adds pattern-matching-related methods to [GetUserMeState].
extension GetUserMeStatePatterns on GetUserMeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _initialState value)?  initial,TResult Function( _loadingState value)?  loading,TResult Function( _failedState value)?  failed,TResult Function( _successState value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial(_that);case _loadingState() when loading != null:
return loading(_that);case _failedState() when failed != null:
return failed(_that);case _successState() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _initialState value)  initial,required TResult Function( _loadingState value)  loading,required TResult Function( _failedState value)  failed,required TResult Function( _successState value)  success,}){
final _that = this;
switch (_that) {
case _initialState():
return initial(_that);case _loadingState():
return loading(_that);case _failedState():
return failed(_that);case _successState():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _initialState value)?  initial,TResult? Function( _loadingState value)?  loading,TResult? Function( _failedState value)?  failed,TResult? Function( _successState value)?  success,}){
final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial(_that);case _loadingState() when loading != null:
return loading(_that);case _failedState() when failed != null:
return failed(_that);case _successState() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  failed,TResult Function( UserMe userMe)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial();case _loadingState() when loading != null:
return loading();case _failedState() when failed != null:
return failed(_that.message);case _successState() when success != null:
return success(_that.userMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  failed,required TResult Function( UserMe userMe)  success,}) {final _that = this;
switch (_that) {
case _initialState():
return initial();case _loadingState():
return loading();case _failedState():
return failed(_that.message);case _successState():
return success(_that.userMe);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  failed,TResult? Function( UserMe userMe)?  success,}) {final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial();case _loadingState() when loading != null:
return loading();case _failedState() when failed != null:
return failed(_that.message);case _successState() when success != null:
return success(_that.userMe);case _:
  return null;

}
}

}

/// @nodoc


class _initialState implements GetUserMeState {
  const _initialState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _initialState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetUserMeState.initial()';
}


}




/// @nodoc


class _loadingState implements GetUserMeState {
  const _loadingState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _loadingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetUserMeState.loading()';
}


}




/// @nodoc


class _failedState implements GetUserMeState {
  const _failedState({required this.message});
  

 final  String message;

/// Create a copy of GetUserMeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$failedStateCopyWith<_failedState> get copyWith => __$failedStateCopyWithImpl<_failedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _failedState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GetUserMeState.failed(message: $message)';
}


}

/// @nodoc
abstract mixin class _$failedStateCopyWith<$Res> implements $GetUserMeStateCopyWith<$Res> {
  factory _$failedStateCopyWith(_failedState value, $Res Function(_failedState) _then) = __$failedStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$failedStateCopyWithImpl<$Res>
    implements _$failedStateCopyWith<$Res> {
  __$failedStateCopyWithImpl(this._self, this._then);

  final _failedState _self;
  final $Res Function(_failedState) _then;

/// Create a copy of GetUserMeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_failedState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _successState implements GetUserMeState {
  const _successState({required this.userMe});
  

 final  UserMe userMe;

/// Create a copy of GetUserMeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$successStateCopyWith<_successState> get copyWith => __$successStateCopyWithImpl<_successState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _successState&&(identical(other.userMe, userMe) || other.userMe == userMe));
}


@override
int get hashCode => Object.hash(runtimeType,userMe);

@override
String toString() {
  return 'GetUserMeState.success(userMe: $userMe)';
}


}

/// @nodoc
abstract mixin class _$successStateCopyWith<$Res> implements $GetUserMeStateCopyWith<$Res> {
  factory _$successStateCopyWith(_successState value, $Res Function(_successState) _then) = __$successStateCopyWithImpl;
@useResult
$Res call({
 UserMe userMe
});




}
/// @nodoc
class __$successStateCopyWithImpl<$Res>
    implements _$successStateCopyWith<$Res> {
  __$successStateCopyWithImpl(this._self, this._then);

  final _successState _self;
  final $Res Function(_successState) _then;

/// Create a copy of GetUserMeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userMe = null,}) {
  return _then(_successState(
userMe: null == userMe ? _self.userMe : userMe // ignore: cast_nullable_to_non_nullable
as UserMe,
  ));
}


}

// dart format on
