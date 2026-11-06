import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../domain/entities/match.dart';
import '../bloc/match_detail_cubit.dart';
import '../widgets/match_detail_view.dart';

class MatchDetailPage extends StatelessWidget {
  const MatchDetailPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.matchDetail)),
    body: DataStateView<MatchDetailCubit, MatchDetail>(
      builder: (context, detail) => MatchDetailView(detail: detail),
    ),
  );
}
