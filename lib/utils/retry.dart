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
        print("Max retry attempts reached: ${e.toString()}");
        rethrow; // Propagate the error after max retries
      }
      print(
          "Attempt $attempts failed, retrying in ${delay.inSeconds} seconds...");
      await Future.delayed(delay);
    }
  }
}
