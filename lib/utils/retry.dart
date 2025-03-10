Future<T> retry<T>(
  Future<T> Function() action, {
  int maxAttempts = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempts = 0;
  while (true) {
    try {
      attempts++;
      return await action();
    } catch (e) {
      if (attempts >= maxAttempts) {
        rethrow; // Propagate the error after max retries
      }
      await Future.delayed(delay);
    }
  }
}
