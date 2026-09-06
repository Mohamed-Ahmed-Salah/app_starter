// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_redirection_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppRedirectionEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppRedirectionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionEvent()';
}


}

/// @nodoc
class $AppRedirectionEventCopyWith<$Res>  {
$AppRedirectionEventCopyWith(AppRedirectionEvent _, $Res Function(AppRedirectionEvent) __);
}


/// Adds pattern-matching-related methods to [AppRedirectionEvent].
extension AppRedirectionEventPatterns on AppRedirectionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GetAppDataAndRedirect value)?  getAppDataAndRedirect,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GetAppDataAndRedirect() when getAppDataAndRedirect != null:
return getAppDataAndRedirect(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GetAppDataAndRedirect value)  getAppDataAndRedirect,}){
final _that = this;
switch (_that) {
case GetAppDataAndRedirect():
return getAppDataAndRedirect(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GetAppDataAndRedirect value)?  getAppDataAndRedirect,}){
final _that = this;
switch (_that) {
case GetAppDataAndRedirect() when getAppDataAndRedirect != null:
return getAppDataAndRedirect(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  getAppDataAndRedirect,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GetAppDataAndRedirect() when getAppDataAndRedirect != null:
return getAppDataAndRedirect();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  getAppDataAndRedirect,}) {final _that = this;
switch (_that) {
case GetAppDataAndRedirect():
return getAppDataAndRedirect();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  getAppDataAndRedirect,}) {final _that = this;
switch (_that) {
case GetAppDataAndRedirect() when getAppDataAndRedirect != null:
return getAppDataAndRedirect();case _:
  return null;

}
}

}

/// @nodoc


class GetAppDataAndRedirect implements AppRedirectionEvent {
  const GetAppDataAndRedirect();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GetAppDataAndRedirect);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionEvent.getAppDataAndRedirect()';
}


}




/// @nodoc
mixin _$AppRedirectionState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppRedirectionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionState()';
}


}

/// @nodoc
class $AppRedirectionStateCopyWith<$Res>  {
$AppRedirectionStateCopyWith(AppRedirectionState _, $Res Function(AppRedirectionState) __);
}


/// Adds pattern-matching-related methods to [AppRedirectionState].
extension AppRedirectionStatePatterns on AppRedirectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _initialState value)?  initial,TResult Function( _loadingState value)?  loading,TResult Function( _failedState value)?  failed,TResult Function( _notLoggedInState value)?  successNotLoggedIn,TResult Function( _loggedInState value)?  successLoggedIn,TResult Function( _forceUpdateState value)?  successForceUpdate,TResult Function( _onboardingState value)?  successOnboarding,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial(_that);case _loadingState() when loading != null:
return loading(_that);case _failedState() when failed != null:
return failed(_that);case _notLoggedInState() when successNotLoggedIn != null:
return successNotLoggedIn(_that);case _loggedInState() when successLoggedIn != null:
return successLoggedIn(_that);case _forceUpdateState() when successForceUpdate != null:
return successForceUpdate(_that);case _onboardingState() when successOnboarding != null:
return successOnboarding(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _initialState value)  initial,required TResult Function( _loadingState value)  loading,required TResult Function( _failedState value)  failed,required TResult Function( _notLoggedInState value)  successNotLoggedIn,required TResult Function( _loggedInState value)  successLoggedIn,required TResult Function( _forceUpdateState value)  successForceUpdate,required TResult Function( _onboardingState value)  successOnboarding,}){
final _that = this;
switch (_that) {
case _initialState():
return initial(_that);case _loadingState():
return loading(_that);case _failedState():
return failed(_that);case _notLoggedInState():
return successNotLoggedIn(_that);case _loggedInState():
return successLoggedIn(_that);case _forceUpdateState():
return successForceUpdate(_that);case _onboardingState():
return successOnboarding(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _initialState value)?  initial,TResult? Function( _loadingState value)?  loading,TResult? Function( _failedState value)?  failed,TResult? Function( _notLoggedInState value)?  successNotLoggedIn,TResult? Function( _loggedInState value)?  successLoggedIn,TResult? Function( _forceUpdateState value)?  successForceUpdate,TResult? Function( _onboardingState value)?  successOnboarding,}){
final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial(_that);case _loadingState() when loading != null:
return loading(_that);case _failedState() when failed != null:
return failed(_that);case _notLoggedInState() when successNotLoggedIn != null:
return successNotLoggedIn(_that);case _loggedInState() when successLoggedIn != null:
return successLoggedIn(_that);case _forceUpdateState() when successForceUpdate != null:
return successForceUpdate(_that);case _onboardingState() when successOnboarding != null:
return successOnboarding(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  failed,TResult Function()?  successNotLoggedIn,TResult Function()?  successLoggedIn,TResult Function()?  successForceUpdate,TResult Function()?  successOnboarding,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial();case _loadingState() when loading != null:
return loading();case _failedState() when failed != null:
return failed(_that.message);case _notLoggedInState() when successNotLoggedIn != null:
return successNotLoggedIn();case _loggedInState() when successLoggedIn != null:
return successLoggedIn();case _forceUpdateState() when successForceUpdate != null:
return successForceUpdate();case _onboardingState() when successOnboarding != null:
return successOnboarding();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  failed,required TResult Function()  successNotLoggedIn,required TResult Function()  successLoggedIn,required TResult Function()  successForceUpdate,required TResult Function()  successOnboarding,}) {final _that = this;
switch (_that) {
case _initialState():
return initial();case _loadingState():
return loading();case _failedState():
return failed(_that.message);case _notLoggedInState():
return successNotLoggedIn();case _loggedInState():
return successLoggedIn();case _forceUpdateState():
return successForceUpdate();case _onboardingState():
return successOnboarding();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  failed,TResult? Function()?  successNotLoggedIn,TResult? Function()?  successLoggedIn,TResult? Function()?  successForceUpdate,TResult? Function()?  successOnboarding,}) {final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial();case _loadingState() when loading != null:
return loading();case _failedState() when failed != null:
return failed(_that.message);case _notLoggedInState() when successNotLoggedIn != null:
return successNotLoggedIn();case _loggedInState() when successLoggedIn != null:
return successLoggedIn();case _forceUpdateState() when successForceUpdate != null:
return successForceUpdate();case _onboardingState() when successOnboarding != null:
return successOnboarding();case _:
  return null;

}
}

}

/// @nodoc


class _initialState implements AppRedirectionState {
  const _initialState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _initialState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionState.initial()';
}


}




/// @nodoc


class _loadingState implements AppRedirectionState {
  const _loadingState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _loadingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionState.loading()';
}


}




/// @nodoc


class _failedState implements AppRedirectionState {
  const _failedState({required this.message});
  

 final  String message;

/// Create a copy of AppRedirectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$failedStateCopyWith<_failedState> get copyWith => __$failedStateCopyWithImpl<_failedState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _failedState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AppRedirectionState.failed(message: $message)';
}


}

/// @nodoc
abstract mixin class _$failedStateCopyWith<$Res> implements $AppRedirectionStateCopyWith<$Res> {
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

/// Create a copy of AppRedirectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_failedState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _notLoggedInState implements AppRedirectionState {
  const _notLoggedInState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _notLoggedInState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionState.successNotLoggedIn()';
}


}




/// @nodoc


class _loggedInState implements AppRedirectionState {
  const _loggedInState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _loggedInState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionState.successLoggedIn()';
}


}




/// @nodoc


class _forceUpdateState implements AppRedirectionState {
  const _forceUpdateState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _forceUpdateState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionState.successForceUpdate()';
}


}




/// @nodoc


class _onboardingState implements AppRedirectionState {
  const _onboardingState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _onboardingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppRedirectionState.successOnboarding()';
}


}




// dart format on
