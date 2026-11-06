import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';

/// One-thumb PIN pad (4–6 digits). Submits automatically at [maxLength]
/// or with the ✓ key once [minLength] digits are entered.
class PinPad extends StatefulWidget {
  const PinPad({
    super.key,
    required this.onSubmit,
    this.enabled = true,
    this.minLength = 4,
    this.maxLength = 6,
  });

  final ValueChanged<String> onSubmit;
  final bool enabled;
  final int minLength;
  final int maxLength;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  static const double _keySize = 72;
  static const List<String> _digits = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  String _pin = '';

  void _press(String digit) {
    if (!widget.enabled || _pin.length >= widget.maxLength) return;
    setState(() => _pin += digit);
    if (_pin.length == widget.maxLength) _submit();
  }

  void _backspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _submit() {
    if (!widget.enabled || _pin.length < widget.minLength) return;
    final pin = _pin;
    setState(() => _pin = '');
    widget.onSubmit(pin);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            key: const Key('pin-dots'),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.maxLength; i++)
                Container(
                  margin: const EdgeInsets.all(6),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _pin.length
                        ? scheme.primary
                        : scheme.outlineVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var row = 0; row < 3; row++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final d in _digits.sublist(row * 3, row * 3 + 3))
                  _key(Text(d), () => _press(d)),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _key(
                const Icon(Icons.backspace_outlined),
                _backspace,
                semantics: context.l10n.pinDelete,
              ),
              _key(const Text('0'), () => _press('0')),
              _key(
                const Icon(Icons.check_rounded),
                _pin.length >= widget.minLength ? _submit : null,
                semantics: context.l10n.login,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _key(Widget child, VoidCallback? onTap, {String? semantics}) =>
      Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: SizedBox(
          width: _keySize,
          height: _keySize,
          child: FilledButton.tonal(
            onPressed: widget.enabled ? onTap : null,
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
            child: Semantics(label: semantics, child: child),
          ),
        ),
      );
}
