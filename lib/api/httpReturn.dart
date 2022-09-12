class HttpReturn<int, String> {
  final int? error;
  final String? json;

  HttpReturn(
    this.error,
    this.json,
  );
}