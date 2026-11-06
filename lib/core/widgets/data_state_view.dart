import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/data_cubit.dart';
import '../entities/data_state.dart';
import 'state_views.dart';

/// Renders a [DataCubit] state: spinner, error with retry, or [builder] with
/// pull-to-refresh. A failure while data is shown becomes a SnackBar.
class DataStateView<C extends DataCubit<T>, T> extends StatelessWidget {
  const DataStateView({super.key, required this.builder, this.isEmpty});

  final Widget Function(BuildContext context, T data) builder;
  final bool Function(T data)? isEmpty;

  @override
  Widget build(BuildContext context) => BlocConsumer<C, DataState<T>>(
    listenWhen: (prev, next) =>
        next.failure != null && next.hasData && prev.failure != next.failure,
    listener: (context, state) => showFailureSnack(context, state.failure!),
    builder: (context, state) {
      final cubit = context.read<C>();
      final data = state.data;
      if (data == null) {
        return switch (state.status) {
          DataStatus.failure when state.failure != null => ErrorView(
            failure: state.failure!,
            onRetry: cubit.load,
          ),
          _ => const LoadingView(),
        };
      }
      final content = isEmpty?.call(data) ?? false
          ? LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: const EmptyView(),
                ),
              ),
            )
          : builder(context, data);
      return RefreshIndicator(onRefresh: cubit.refresh, child: content);
    },
  );
}
