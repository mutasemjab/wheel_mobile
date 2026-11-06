import 'dart:async';

import 'package:flutter/widgets.dart';

/// Rebuilds [builder] every [interval] with the current device time (ms).
/// Purely visual (a running clock); no business state lives here.
class TickerBuilder extends StatefulWidget {
  const TickerBuilder({
    super.key,
    required this.builder,
    this.interval = const Duration(seconds: 1),
  });

  final Widget Function(BuildContext context, int nowMs) builder;
  final Duration interval;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, DateTime.now().millisecondsSinceEpoch);
}
