import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../bloc/auth_bloc.dart';

class EmailLoginForm extends StatefulWidget {
  const EmailLoginForm({super.key});

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      AuthLoginRequested(email: _email.text, password: _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<AuthBloc>().state;
    final busy = state is AuthSubmitting;
    final failure = state is AuthUnauthenticated ? state.failure : null;
    final fieldErrors = failure is ValidationFailure ? failure : null;
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l10n.requiredField : null;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const Center(child: AppLogo()),
          const SizedBox(height: AppSpacing.xl),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: l10n.email,
              errorText: fieldErrors?.fieldError('email'),
            ),
            validator: required,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _password,
            obscureText: true,
            textDirection: TextDirection.ltr,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: l10n.password,
              errorText: fieldErrors?.fieldError('password'),
            ),
            validator: required,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: busy ? null : _submit,
            child: busy
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.login),
          ),
        ],
      ),
    );
  }
}
