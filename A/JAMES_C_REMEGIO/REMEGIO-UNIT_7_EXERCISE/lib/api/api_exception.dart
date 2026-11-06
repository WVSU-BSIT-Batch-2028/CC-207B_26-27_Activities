/// A problem the reader can act on: no network, a bad status, a missing key.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// OMDb was not given a key at startup, so movie requests must not be sent.
class MissingOmdbKey implements Exception {
  const MissingOmdbKey();
}

/// Turns an exception into the sentence shown on an error screen.
String messageOf(Object error) {
  if (error is ApiException) return error.message;
  if (error is MissingOmdbKey) {
    return 'OMDb is not configured. Add OMDB_KEY and start the app again.';
  }
  return 'Something went wrong. Try again.';
}
