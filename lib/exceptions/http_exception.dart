class HttpException implements Exception {
  final String cause;
  const HttpException(this.cause);

  @override
  String toString() {
    return cause;
  }
}