import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_errors.freezed.dart';

@freezed
class CommonError with _$CommonError {
  const factory CommonError.unauthenticated() = CommonErrorUnauthenticated;
  const factory CommonError.connection() = CommonErrorConnection;
  const factory CommonError.badRequest() = CommonErrorBadRequest;
  const factory CommonError.notFound() = CommonErrorNotFound;
  const factory CommonError.undefined() = CommonErrorUndefined;
}
