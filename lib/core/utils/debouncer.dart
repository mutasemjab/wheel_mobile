import 'dart:async';

/// Emits an event only after [duration] passed without a newer one.
extension DebounceStream<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    Timer? timer;
    late T latest;
    var hasLatest = false;
    StreamSubscription<T>? subscription;
    late final StreamController<T> controller;

    void flush() {
      if (!hasLatest) return;
      hasLatest = false;
      controller.add(latest);
    }

    controller = StreamController<T>(
      onListen: () {
        subscription = listen(
          (event) {
            latest = event;
            hasLatest = true;
            timer?.cancel();
            timer = Timer(duration, flush);
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            flush();
            controller.close();
          },
        );
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () {
        timer?.cancel();
        return subscription?.cancel();
      },
    );
    return controller.stream;
  }
}
