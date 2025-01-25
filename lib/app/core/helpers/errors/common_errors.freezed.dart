// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common_errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommonError {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() connection,
    required TResult Function() badRequest,
    required TResult Function() notFound,
    required TResult Function() undefined,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? connection,
    TResult? Function()? badRequest,
    TResult? Function()? notFound,
    TResult? Function()? undefined,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? connection,
    TResult Function()? badRequest,
    TResult Function()? notFound,
    TResult Function()? undefined,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommonErrorUnauthenticated value) unauthenticated,
    required TResult Function(CommonErrorConnection value) connection,
    required TResult Function(CommonErrorBadRequest value) badRequest,
    required TResult Function(CommonErrorNotFound value) notFound,
    required TResult Function(CommonErrorUndefined value) undefined,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult? Function(CommonErrorConnection value)? connection,
    TResult? Function(CommonErrorBadRequest value)? badRequest,
    TResult? Function(CommonErrorNotFound value)? notFound,
    TResult? Function(CommonErrorUndefined value)? undefined,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult Function(CommonErrorConnection value)? connection,
    TResult Function(CommonErrorBadRequest value)? badRequest,
    TResult Function(CommonErrorNotFound value)? notFound,
    TResult Function(CommonErrorUndefined value)? undefined,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonErrorCopyWith<$Res> {
  factory $CommonErrorCopyWith(
          CommonError value, $Res Function(CommonError) then) =
      _$CommonErrorCopyWithImpl<$Res, CommonError>;
}

/// @nodoc
class _$CommonErrorCopyWithImpl<$Res, $Val extends CommonError>
    implements $CommonErrorCopyWith<$Res> {
  _$CommonErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CommonErrorUnauthenticatedImplCopyWith<$Res> {
  factory _$$CommonErrorUnauthenticatedImplCopyWith(
          _$CommonErrorUnauthenticatedImpl value,
          $Res Function(_$CommonErrorUnauthenticatedImpl) then) =
      __$$CommonErrorUnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommonErrorUnauthenticatedImplCopyWithImpl<$Res>
    extends _$CommonErrorCopyWithImpl<$Res, _$CommonErrorUnauthenticatedImpl>
    implements _$$CommonErrorUnauthenticatedImplCopyWith<$Res> {
  __$$CommonErrorUnauthenticatedImplCopyWithImpl(
      _$CommonErrorUnauthenticatedImpl _value,
      $Res Function(_$CommonErrorUnauthenticatedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CommonErrorUnauthenticatedImpl implements CommonErrorUnauthenticated {
  const _$CommonErrorUnauthenticatedImpl();

  @override
  String toString() {
    return 'CommonError.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonErrorUnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() connection,
    required TResult Function() badRequest,
    required TResult Function() notFound,
    required TResult Function() undefined,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? connection,
    TResult? Function()? badRequest,
    TResult? Function()? notFound,
    TResult? Function()? undefined,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? connection,
    TResult Function()? badRequest,
    TResult Function()? notFound,
    TResult Function()? undefined,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommonErrorUnauthenticated value) unauthenticated,
    required TResult Function(CommonErrorConnection value) connection,
    required TResult Function(CommonErrorBadRequest value) badRequest,
    required TResult Function(CommonErrorNotFound value) notFound,
    required TResult Function(CommonErrorUndefined value) undefined,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult? Function(CommonErrorConnection value)? connection,
    TResult? Function(CommonErrorBadRequest value)? badRequest,
    TResult? Function(CommonErrorNotFound value)? notFound,
    TResult? Function(CommonErrorUndefined value)? undefined,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult Function(CommonErrorConnection value)? connection,
    TResult Function(CommonErrorBadRequest value)? badRequest,
    TResult Function(CommonErrorNotFound value)? notFound,
    TResult Function(CommonErrorUndefined value)? undefined,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class CommonErrorUnauthenticated implements CommonError {
  const factory CommonErrorUnauthenticated() = _$CommonErrorUnauthenticatedImpl;
}

/// @nodoc
abstract class _$$CommonErrorConnectionImplCopyWith<$Res> {
  factory _$$CommonErrorConnectionImplCopyWith(
          _$CommonErrorConnectionImpl value,
          $Res Function(_$CommonErrorConnectionImpl) then) =
      __$$CommonErrorConnectionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommonErrorConnectionImplCopyWithImpl<$Res>
    extends _$CommonErrorCopyWithImpl<$Res, _$CommonErrorConnectionImpl>
    implements _$$CommonErrorConnectionImplCopyWith<$Res> {
  __$$CommonErrorConnectionImplCopyWithImpl(_$CommonErrorConnectionImpl _value,
      $Res Function(_$CommonErrorConnectionImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CommonErrorConnectionImpl implements CommonErrorConnection {
  const _$CommonErrorConnectionImpl();

  @override
  String toString() {
    return 'CommonError.connection()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonErrorConnectionImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() connection,
    required TResult Function() badRequest,
    required TResult Function() notFound,
    required TResult Function() undefined,
  }) {
    return connection();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? connection,
    TResult? Function()? badRequest,
    TResult? Function()? notFound,
    TResult? Function()? undefined,
  }) {
    return connection?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? connection,
    TResult Function()? badRequest,
    TResult Function()? notFound,
    TResult Function()? undefined,
    required TResult orElse(),
  }) {
    if (connection != null) {
      return connection();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommonErrorUnauthenticated value) unauthenticated,
    required TResult Function(CommonErrorConnection value) connection,
    required TResult Function(CommonErrorBadRequest value) badRequest,
    required TResult Function(CommonErrorNotFound value) notFound,
    required TResult Function(CommonErrorUndefined value) undefined,
  }) {
    return connection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult? Function(CommonErrorConnection value)? connection,
    TResult? Function(CommonErrorBadRequest value)? badRequest,
    TResult? Function(CommonErrorNotFound value)? notFound,
    TResult? Function(CommonErrorUndefined value)? undefined,
  }) {
    return connection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult Function(CommonErrorConnection value)? connection,
    TResult Function(CommonErrorBadRequest value)? badRequest,
    TResult Function(CommonErrorNotFound value)? notFound,
    TResult Function(CommonErrorUndefined value)? undefined,
    required TResult orElse(),
  }) {
    if (connection != null) {
      return connection(this);
    }
    return orElse();
  }
}

abstract class CommonErrorConnection implements CommonError {
  const factory CommonErrorConnection() = _$CommonErrorConnectionImpl;
}

/// @nodoc
abstract class _$$CommonErrorBadRequestImplCopyWith<$Res> {
  factory _$$CommonErrorBadRequestImplCopyWith(
          _$CommonErrorBadRequestImpl value,
          $Res Function(_$CommonErrorBadRequestImpl) then) =
      __$$CommonErrorBadRequestImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommonErrorBadRequestImplCopyWithImpl<$Res>
    extends _$CommonErrorCopyWithImpl<$Res, _$CommonErrorBadRequestImpl>
    implements _$$CommonErrorBadRequestImplCopyWith<$Res> {
  __$$CommonErrorBadRequestImplCopyWithImpl(_$CommonErrorBadRequestImpl _value,
      $Res Function(_$CommonErrorBadRequestImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CommonErrorBadRequestImpl implements CommonErrorBadRequest {
  const _$CommonErrorBadRequestImpl();

  @override
  String toString() {
    return 'CommonError.badRequest()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonErrorBadRequestImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() connection,
    required TResult Function() badRequest,
    required TResult Function() notFound,
    required TResult Function() undefined,
  }) {
    return badRequest();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? connection,
    TResult? Function()? badRequest,
    TResult? Function()? notFound,
    TResult? Function()? undefined,
  }) {
    return badRequest?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? connection,
    TResult Function()? badRequest,
    TResult Function()? notFound,
    TResult Function()? undefined,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommonErrorUnauthenticated value) unauthenticated,
    required TResult Function(CommonErrorConnection value) connection,
    required TResult Function(CommonErrorBadRequest value) badRequest,
    required TResult Function(CommonErrorNotFound value) notFound,
    required TResult Function(CommonErrorUndefined value) undefined,
  }) {
    return badRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult? Function(CommonErrorConnection value)? connection,
    TResult? Function(CommonErrorBadRequest value)? badRequest,
    TResult? Function(CommonErrorNotFound value)? notFound,
    TResult? Function(CommonErrorUndefined value)? undefined,
  }) {
    return badRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult Function(CommonErrorConnection value)? connection,
    TResult Function(CommonErrorBadRequest value)? badRequest,
    TResult Function(CommonErrorNotFound value)? notFound,
    TResult Function(CommonErrorUndefined value)? undefined,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(this);
    }
    return orElse();
  }
}

abstract class CommonErrorBadRequest implements CommonError {
  const factory CommonErrorBadRequest() = _$CommonErrorBadRequestImpl;
}

/// @nodoc
abstract class _$$CommonErrorNotFoundImplCopyWith<$Res> {
  factory _$$CommonErrorNotFoundImplCopyWith(_$CommonErrorNotFoundImpl value,
          $Res Function(_$CommonErrorNotFoundImpl) then) =
      __$$CommonErrorNotFoundImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommonErrorNotFoundImplCopyWithImpl<$Res>
    extends _$CommonErrorCopyWithImpl<$Res, _$CommonErrorNotFoundImpl>
    implements _$$CommonErrorNotFoundImplCopyWith<$Res> {
  __$$CommonErrorNotFoundImplCopyWithImpl(_$CommonErrorNotFoundImpl _value,
      $Res Function(_$CommonErrorNotFoundImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CommonErrorNotFoundImpl implements CommonErrorNotFound {
  const _$CommonErrorNotFoundImpl();

  @override
  String toString() {
    return 'CommonError.notFound()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonErrorNotFoundImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() connection,
    required TResult Function() badRequest,
    required TResult Function() notFound,
    required TResult Function() undefined,
  }) {
    return notFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? connection,
    TResult? Function()? badRequest,
    TResult? Function()? notFound,
    TResult? Function()? undefined,
  }) {
    return notFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? connection,
    TResult Function()? badRequest,
    TResult Function()? notFound,
    TResult Function()? undefined,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommonErrorUnauthenticated value) unauthenticated,
    required TResult Function(CommonErrorConnection value) connection,
    required TResult Function(CommonErrorBadRequest value) badRequest,
    required TResult Function(CommonErrorNotFound value) notFound,
    required TResult Function(CommonErrorUndefined value) undefined,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult? Function(CommonErrorConnection value)? connection,
    TResult? Function(CommonErrorBadRequest value)? badRequest,
    TResult? Function(CommonErrorNotFound value)? notFound,
    TResult? Function(CommonErrorUndefined value)? undefined,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult Function(CommonErrorConnection value)? connection,
    TResult Function(CommonErrorBadRequest value)? badRequest,
    TResult Function(CommonErrorNotFound value)? notFound,
    TResult Function(CommonErrorUndefined value)? undefined,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class CommonErrorNotFound implements CommonError {
  const factory CommonErrorNotFound() = _$CommonErrorNotFoundImpl;
}

/// @nodoc
abstract class _$$CommonErrorUndefinedImplCopyWith<$Res> {
  factory _$$CommonErrorUndefinedImplCopyWith(_$CommonErrorUndefinedImpl value,
          $Res Function(_$CommonErrorUndefinedImpl) then) =
      __$$CommonErrorUndefinedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommonErrorUndefinedImplCopyWithImpl<$Res>
    extends _$CommonErrorCopyWithImpl<$Res, _$CommonErrorUndefinedImpl>
    implements _$$CommonErrorUndefinedImplCopyWith<$Res> {
  __$$CommonErrorUndefinedImplCopyWithImpl(_$CommonErrorUndefinedImpl _value,
      $Res Function(_$CommonErrorUndefinedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CommonErrorUndefinedImpl implements CommonErrorUndefined {
  const _$CommonErrorUndefinedImpl();

  @override
  String toString() {
    return 'CommonError.undefined()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonErrorUndefinedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() connection,
    required TResult Function() badRequest,
    required TResult Function() notFound,
    required TResult Function() undefined,
  }) {
    return undefined();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? connection,
    TResult? Function()? badRequest,
    TResult? Function()? notFound,
    TResult? Function()? undefined,
  }) {
    return undefined?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? connection,
    TResult Function()? badRequest,
    TResult Function()? notFound,
    TResult Function()? undefined,
    required TResult orElse(),
  }) {
    if (undefined != null) {
      return undefined();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommonErrorUnauthenticated value) unauthenticated,
    required TResult Function(CommonErrorConnection value) connection,
    required TResult Function(CommonErrorBadRequest value) badRequest,
    required TResult Function(CommonErrorNotFound value) notFound,
    required TResult Function(CommonErrorUndefined value) undefined,
  }) {
    return undefined(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult? Function(CommonErrorConnection value)? connection,
    TResult? Function(CommonErrorBadRequest value)? badRequest,
    TResult? Function(CommonErrorNotFound value)? notFound,
    TResult? Function(CommonErrorUndefined value)? undefined,
  }) {
    return undefined?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommonErrorUnauthenticated value)? unauthenticated,
    TResult Function(CommonErrorConnection value)? connection,
    TResult Function(CommonErrorBadRequest value)? badRequest,
    TResult Function(CommonErrorNotFound value)? notFound,
    TResult Function(CommonErrorUndefined value)? undefined,
    required TResult orElse(),
  }) {
    if (undefined != null) {
      return undefined(this);
    }
    return orElse();
  }
}

abstract class CommonErrorUndefined implements CommonError {
  const factory CommonErrorUndefined() = _$CommonErrorUndefinedImpl;
}
