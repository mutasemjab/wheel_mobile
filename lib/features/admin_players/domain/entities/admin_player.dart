import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';

/// Raw admin player record (`GET /admin/players`).
final class AdminPlayer extends Equatable {
  const AdminPlayer({
    required this.slug,
    required this.name,
    this.nameEn,
    this.number,
    this.role,
    this.isGoalkeeper = false,
    this.photoUrl,
    this.startTier = Tier.c,
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String slug;
  final String name;
  final String? nameEn;
  final int? number;
  final String? role;
  final bool isGoalkeeper;
  final String? photoUrl;
  final Tier startTier;
  final int sortOrder;
  final bool isActive;

  PlayerDraft toDraft() => PlayerDraft(
    slug: slug,
    name: name,
    nameEn: nameEn ?? '',
    number: number?.toString() ?? '',
    role: role ?? '',
    isGoalkeeper: isGoalkeeper,
    startTier: startTier,
    isActive: isActive,
  );

  @override
  List<Object?> get props => [
    slug,
    name,
    nameEn,
    number,
    role,
    isGoalkeeper,
    photoUrl,
    startTier,
    sortOrder,
    isActive,
  ];
}

/// Form values for create / edit.
final class PlayerDraft extends Equatable {
  const PlayerDraft({
    this.slug = '',
    this.name = '',
    this.nameEn = '',
    this.number = '',
    this.role = '',
    this.isGoalkeeper = false,
    this.startTier = Tier.c,
    this.isActive = true,
  });

  final String slug;
  final String name;
  final String nameEn;
  final String number;
  final String role;
  final bool isGoalkeeper;
  final Tier startTier;
  final bool isActive;

  PlayerDraft copyWith({
    String? slug,
    String? name,
    String? nameEn,
    String? number,
    String? role,
    bool? isGoalkeeper,
    Tier? startTier,
    bool? isActive,
  }) => PlayerDraft(
    slug: slug ?? this.slug,
    name: name ?? this.name,
    nameEn: nameEn ?? this.nameEn,
    number: number ?? this.number,
    role: role ?? this.role,
    isGoalkeeper: isGoalkeeper ?? this.isGoalkeeper,
    startTier: startTier ?? this.startTier,
    isActive: isActive ?? this.isActive,
  );

  @override
  List<Object?> get props => [
    slug,
    name,
    nameEn,
    number,
    role,
    isGoalkeeper,
    startTier,
    isActive,
  ];
}

enum PlayerFieldError { slugInvalid, nameRequired, numberInvalid }

/// Client-side checks mirroring the server rules.
abstract final class PlayerDraftValidator {
  static final RegExp slugPattern = RegExp(r'^[a-z0-9_-]{1,40}$');
  static const int minNumber = 1;
  static const int maxNumber = 99;

  static Map<String, PlayerFieldError> validate(PlayerDraft d) {
    final number = d.number.trim();
    final parsed = int.tryParse(number);
    return {
      if (!slugPattern.hasMatch(d.slug.trim()))
        'slug': PlayerFieldError.slugInvalid,
      if (d.name.trim().isEmpty) 'name': PlayerFieldError.nameRequired,
      if (number.isNotEmpty &&
          (parsed == null || parsed < minNumber || parsed > maxNumber))
        'number': PlayerFieldError.numberInvalid,
    };
  }
}
