import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/features/admin_players/domain/entities/admin_player.dart';
import 'package:wheel_mobile/features/admin_settings/data/models/settings_model.dart';
import 'package:wheel_mobile/features/admin_settings/domain/entities/settings.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('RatingConfigValidator (mirrors the server)', () {
    final base = RatingConfigModel(fixtureData('config')).toEntity();

    test('the backend config is valid', () {
      expect(RatingConfigValidator.validate(base), isEmpty);
    });

    test('bands.A must be greater than bands.B', () {
      final c = base.withValue(ConfigSection.bands, 'B', 80);
      expect(RatingConfigValidator.validate(c), {ConfigError.bands});
    });

    test('bounds.min must be below bounds.max', () {
      final c = base.withValue(ConfigSection.bounds, 'min', 99);
      expect(RatingConfigValidator.validate(c), contains(ConfigError.bounds));
    });

    test('brakeBottom must be above bounds.min', () {
      final c = base.withValue(ConfigSection.move, 'brakeBottom', 10);
      expect(RatingConfigValidator.validate(c), {ConfigError.brakeBottom});
    });

    test('brakeTop must be below 100', () {
      final c = base.withValue(ConfigSection.move, 'brakeTop', 100);
      expect(RatingConfigValidator.validate(c), {ConfigError.brakeTop});
    });
  });

  group('PlayerDraftValidator', () {
    test('valid draft', () {
      const d = PlayerDraft(slug: 'sameh_20', name: 'سامح', number: '20');
      expect(PlayerDraftValidator.validate(d), isEmpty);
    });

    test('slug, name and number rules', () {
      const d = PlayerDraft(slug: 'Sameh!', name: ' ', number: '100');
      expect(PlayerDraftValidator.validate(d), {
        'slug': PlayerFieldError.slugInvalid,
        'name': PlayerFieldError.nameRequired,
        'number': PlayerFieldError.numberInvalid,
      });
    });

    test('number is optional', () {
      const d = PlayerDraft(slug: 'x', name: 'x');
      expect(PlayerDraftValidator.validate(d), isEmpty);
    });
  });
}
