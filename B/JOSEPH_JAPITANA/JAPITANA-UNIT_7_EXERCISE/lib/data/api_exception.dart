/// A problem the user should read: no internet, bad key, API error.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}