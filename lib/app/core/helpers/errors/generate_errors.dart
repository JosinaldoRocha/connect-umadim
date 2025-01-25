import 'common_errors.dart';

class GenerateError {
  static CommonError fromException(Exception error) {
    // if (error is DioException) {
    //   switch (error.response?.statusCode) {
    //     case 400:
    //       return const CommonError.badRequest();
    //     case 404:
    //       return const CommonError.notFound();
    //     case 401:
    //       return const CommonError.unauthenticated();
    //     default:
    //       return const CommonError.undefined();
    //   }
    // } else if (error is SocketException) {
    //   return const CommonError.connection();
    // } else {
    return const CommonError.undefined();
    //  }
  }
}
