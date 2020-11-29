class FirebaseException implements Exception {
  final String cause;
  const FirebaseException(this.cause);

  @override
  String toString() {
    return cause;
  }
}