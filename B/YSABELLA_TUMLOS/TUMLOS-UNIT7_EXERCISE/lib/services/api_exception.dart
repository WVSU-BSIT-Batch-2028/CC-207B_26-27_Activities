class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

String describeError(Object error) {
  if (error is ApiException) return error.message;
  return 'Could not reach the server. Check your internet connection and try again.';
}
