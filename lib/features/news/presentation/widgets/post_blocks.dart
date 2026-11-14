import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/post.dart';

/// Renders the server-parsed body blocks (headings, paragraphs, bullet lists).
class PostBlocks extends StatelessWidget {
  const PostBlocks({super.key, required this.blocks});

  final List<PostBlock> blocks;

  static const double _lineHeight = 1.7;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final body = text.bodyLarge?.copyWith(height: _lineHeight);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final block in blocks)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: switch (block) {
              HeadingBlock(:final text) => Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ParagraphBlock(:final text) => Text(text, style: body),
              BulletsBlock(:final items) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final item in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•  ', style: body),
                          Expanded(child: Text(item, style: body)),
                        ],
                      ),
                    ),
                ],
              ),
            },
          ),
      ],
    );
  }
}
