import 'package:equatable/equatable.dart';

/// Server-generated Arabic insight line (`{ icon, text }`).
final class Insight extends Equatable {
  const Insight({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  List<Object?> get props => [icon, text];
}
