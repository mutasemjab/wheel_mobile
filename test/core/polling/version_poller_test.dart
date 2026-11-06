import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/polling/version_poller.dart';

class _FakeSource implements VersionSource {
  final List<AppVersion> replies = [];

  @override
  Future<AppVersion> fetch() async => replies.removeAt(0);
}

void main() {
  test('notifies data and live listeners only when values change', () async {
    final source = _FakeSource()
      ..replies.addAll(const [
        AppVersion(version: 1),
        AppVersion(version: 1),
        AppVersion(version: 2),
        AppVersion(version: 2, liveUpdatedAt: 't1'),
      ]);
    final poller = VersionPoller(source);
    var data = 0;
    var live = 0;
    var any = 0;
    poller.dataChanges.listen((_) => data++);
    poller.liveChanges.listen((_) => live++);
    poller.anyChanges.listen((_) => any++);

    for (var i = 0; i < 4; i++) {
      await poller.pollNow();
    }
    await Future<void>.delayed(Duration.zero);

    expect(data, 1);
    expect(live, 1);
    expect(any, 2);
    await poller.dispose();
  });

  test('pause stops the timer; resume restarts it', () async {
    final source = _FakeSource()
      ..replies.addAll(List.filled(10, const AppVersion(version: 1)));
    final poller = VersionPoller(source, interval: const Duration(hours: 1))
      ..start();
    expect(poller.isRunning, isTrue);
    poller.pause();
    expect(poller.isRunning, isFalse);
    poller.resume();
    expect(poller.isRunning, isTrue);
    await poller.dispose();
  });
}
