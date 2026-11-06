import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/admin_player.dart';
import '../bloc/player_form_cubit.dart';

class PlayerFormPage extends StatelessWidget {
  const PlayerFormPage({super.key});

  static const double _photoMaxSize = 1024;

  String? _error(BuildContext context, PlayerFormState state, String field) {
    final l10n = context.l10n;
    return switch (state.localErrors[field]) {
      PlayerFieldError.slugInvalid => l10n.invalidSlug,
      PlayerFieldError.nameRequired => l10n.requiredField,
      PlayerFieldError.numberInvalid => l10n.invalidNumber,
      null => state.serverError(field),
    };
  }

  Future<void> _pickPhoto(BuildContext context) async {
    final cubit = context.read<PlayerFormCubit>();
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: _photoMaxSize,
      maxHeight: _photoMaxSize,
    );
    if (file != null) await cubit.uploadPhoto(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<PlayerFormCubit>();
    return BlocConsumer<PlayerFormCubit, PlayerFormState>(
      listenWhen: (p, n) => n.status != p.status || n.failure != p.failure,
      listener: (context, state) {
        if (state.failure != null) showFailureSnack(context, state.failure!);
        if (state.status == PlayerFormStatus.saved) {
          showMessageSnack(context, l10n.saved);
          context.pop();
        }
        if (state.photoUploaded && state.status == PlayerFormStatus.editing) {
          showMessageSnack(context, l10n.photoUploaded);
        }
      },
      builder: (context, state) {
        final d = state.draft;
        final busy = state.status != PlayerFormStatus.editing;
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.isEditing ? l10n.editPlayer : l10n.newPlayer),
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              TextFormField(
                initialValue: d.slug,
                enabled: !cubit.isEditing,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: l10n.slugField,
                  helperText: l10n.slugHint,
                  errorText: _error(context, state, 'slug'),
                ),
                onChanged: (v) => cubit.change(d.copyWith(slug: v)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                initialValue: d.name,
                decoration: InputDecoration(
                  labelText: l10n.nameField,
                  errorText: _error(context, state, 'name'),
                ),
                onChanged: (v) => cubit.change(state.draft.copyWith(name: v)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                initialValue: d.nameEn,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: l10n.nameEnField,
                  errorText: _error(context, state, 'name_en'),
                ),
                onChanged: (v) => cubit.change(state.draft.copyWith(nameEn: v)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                initialValue: d.number,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.numberField,
                  errorText: _error(context, state, 'number'),
                ),
                onChanged: (v) => cubit.change(state.draft.copyWith(number: v)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                initialValue: d.role,
                decoration: InputDecoration(
                  labelText: l10n.roleField,
                  errorText: _error(context, state, 'role'),
                ),
                onChanged: (v) => cubit.change(state.draft.copyWith(role: v)),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.startTier,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              SegmentedButton<Tier>(
                segments: [
                  for (final t in Tier.values)
                    ButtonSegment(value: t, label: Text(t.code)),
                ],
                selected: {d.startTier},
                onSelectionChanged: (s) =>
                    cubit.change(d.copyWith(startTier: s.first)),
              ),
              SwitchListTile(
                title: Text(l10n.isGoalkeeper),
                value: d.isGoalkeeper,
                onChanged: (v) => cubit.change(d.copyWith(isGoalkeeper: v)),
              ),
              SwitchListTile(
                title: Text(l10n.isActive),
                value: d.isActive,
                onChanged: (v) => cubit.change(d.copyWith(isActive: v)),
              ),
              if (cubit.isEditing)
                OutlinedButton.icon(
                  onPressed: busy ? null : () => _pickPhoto(context),
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: Text(l10n.uploadPhoto),
                ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: busy ? null : cubit.save,
                child: busy
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.save),
              ),
            ],
          ),
        );
      },
    );
  }
}
