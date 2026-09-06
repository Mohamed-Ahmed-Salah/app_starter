// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_products_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetProductsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GetProductsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'GetProductsState()';
}


}

/// @nodoc
class $GetProductsStateCopyWith<$Res>  {
$GetProductsStateCopyWith(GetProductsState _, $Res Function(GetProductsState) __);
}


/// Adds pattern-matching-related methods to [GetProductsState].
extension GetProductsStatePatterns on GetProductsState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Failure failure)?  failed,TResult Function( List<Product> products)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial();case _loadingState() when loading != null:
return loading();case _failedState() when failed != null:
return failed(_that.failure);case _successState() when success != null:
return success(_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Failure failure)  failed,required TResult Function( List<Product> products)  success,}) {final _that = this;
switch (_that) {
case _initialState():
return initial();case _loadingState():
return loading();case _failedState():
return failed(_that.failure);case _successState():
return success(_that.products);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Failure failure)?  failed,TResult? Function( List<Product> products)?  success,}) {final _that = this;
switch (_that) {
case _initialState() when initial != null:
return initial();case _loadingState() when loading != null:
return loading();case _failedState() when failed != null:
return failed(_that.failure);case _successState() when success != null:
return success(_that.products);case _:
  return null;

}
}

}

/// @nodoc


class _initialState implements GetProductsState {
  const _initialState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _initialState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'GetProductsState.initial()';
}


}




/// @nodoc


class _loadingState implements GetProductsState {
  const _loadingState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _loadingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'GetProductsState.loading()';
}


}




/// @nodoc


class _failedState implements GetProductsState {
  const _failedState({required this.failure});
  

 final  Failure failure;

/// Create a copy of GetProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$failedStateCopyWith<_failedState> get copyWith => __$failedStateCopyWithImpl<_failedState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _failedState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'GetProductsState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$failedStateCopyWith<$Res> implements $GetProductsStateCopyWith<$Res> {
  factory _$failedStateCopyWith(_failedState value, $Res Function(_failedState) _then) = __$failedStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class __$failedStateCopyWithImpl<$Res>
    implements _$failedStateCopyWith<$Res> {
  __$failedStateCopyWithImpl(this._self, this._then);

  final _failedState _self;
  final $Res Function(_failedState) _then;

/// Create a copy of GetProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_failedState(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

/// @nodoc


class _successState implements GetProductsState {
  const _successState({required  List<Product> products}): _products = products;
  

 final  List<Product> _products;
 List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of GetProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$successStateCopyWith<_successState> get copyWith => __$successStateCopyWithImpl<_successState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _successState&&const DeepCollectionEquality().equals(other.products, _products));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'GetProductsState.success(products: $products)';
}


}

/// @nodoc
abstract mixin class _$successStateCopyWith<$Res> implements $GetProductsStateCopyWith<$Res> {
  factory _$successStateCopyWith(_successState value, $Res Function(_successState) _then) = __$successStateCopyWithImpl;
@useResult
$Res call({
 List<Product> products
});




}
/// @nodoc
class __$successStateCopyWithImpl<$Res>
    implements _$successStateCopyWith<$Res> {
  __$successStateCopyWithImpl(this._self, this._then);

  final _successState _self;
  final $Res Function(_successState) _then;

/// Create a copy of GetProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,}) {
  return _then(_successState(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}


}

// dart format on
