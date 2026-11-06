import 'package:flutter/material.dart';

import '../entities/insight.dart';
import '../theme/app_theme.dart';

/// Server-generated insight lines (icon + Arabic text), shown as-is.
class InsightsList extends StatelessWidget {
  const InsightsList({super.key, required this.insights});

  final List<Insight> insights;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final insight in insights)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(insight.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(insight.text)),
            ],
          ),
        ),
    ],
  );
}
