import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/email_login_form.dart';
import '../widgets/pin_pad.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  /// Email/password errors render under their fields; everything else
  /// (wrong PIN, throttling, network) goes to a SnackBar.
  static bool _shownInline(Failure failure) =>
      failure is ValidationFailure &&
      (failure.fieldError('email') != null ||
          failure.fieldError('password') != null);

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthAuthenticated():
            context.go(AppRoutes.admin);
          case AuthUnauthenticated(:final failure?) when !_shownInline(failure):
            showFailureSnack(context, failure);
          case AuthUnauthenticated(expired: true):
            showFailureSnack(context, const UnauthorizedFailure());
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.loginTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.tabPin),
              Tab(text: context.l10n.tabEmail),
            ],
          ),
        ),
        body: const TabBarView(children: [_PinTab(), EmailLoginForm()]),
      ),
    ),
  );
}

class _PinTab extends StatelessWidget {
  const _PinTab();

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AuthBloc>().state is AuthSubmitting;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.pinHint,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              context.l10n.pinAdminHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            PinPad(
              enabled: !busy,
              onSubmit: (pin) =>
                  context.read<AuthBloc>().add(AuthPinRequested(pin)),
            ),
            if (busy)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: LoadingView(),
              ),
          ],
        ),
      ),
    );
  }
}
