/// One error type for both APIs and the CMS.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// A friendly message for anything a Future can throw.
String messageOf(Object error) => error is ApiException
    ? error.message
    : 'No connection. Check your internet and try again.';
