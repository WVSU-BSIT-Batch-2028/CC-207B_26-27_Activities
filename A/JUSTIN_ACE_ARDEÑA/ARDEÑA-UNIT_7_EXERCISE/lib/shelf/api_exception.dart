/// A problem the user should read: no internet, a bad answer, and so on.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

