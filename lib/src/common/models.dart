import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Move represented with Standard Algebraic Notation
typedef SANMove = String;

/// Move represented with UCI notation
typedef UCIMove = String;

/// Represents a lichess rating perf item
enum Perf {
  ultraBullet('UltraBullet', 'Ultra', LichessIcons.ultrabullet),
  bullet('Bullet', 'Bullet', LichessIcons.bullet),
  blitz('Blitz', 'Blitz', LichessIcons.blitz),
  rapid('Rapid', 'Rapid', LichessIcons.rapid),
  classical('Classical', 'Classical', LichessIcons.classical),
  correspondence('Correspondence', 'Corresp.', LichessIcons.correspondence),
  chess960('Chess 960', '960', LichessIcons.die_six),
  antichess('Antichess', 'Antichess', LichessIcons.antichess),
  kingOfTheHill('King Of The Hill', 'KotH', LichessIcons.flag),
  threeCheck('Three-check', '3check', LichessIcons.three_check),
  atomic('Atomic', 'Atomic', LichessIcons.atom),
  horde('Horde', 'Horde', LichessIcons.horde),
  racingKings('Racing Kings', 'Racing', LichessIcons.racing_kings),
  crazyhouse('Crazyhouse', 'Crazy', LichessIcons.h_square),
  puzzle('Puzzle', 'Puzzle', LichessIcons.target),
  storm('Storm', 'Storm', LichessIcons.storm);

  const Perf(this.title, this.shortTitle, this.icon);

  final String title;
  final String shortTitle;
  final IconData icon;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class GameAnyId with _$GameAnyId {
  const GameAnyId._();

  const factory GameAnyId(String value) = _GameAnyId;

  GameId get gameId => GameId(value.substring(0, 8));
  bool get isFullId => value.length == 12;
  GameFullId? get gameFullId => isFullId ? GameFullId(value) : null;

  factory GameAnyId.fromJson(Map<String, dynamic> json) =>
      _$GameAnyIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class GameId with _$GameId {
  const GameId._();

  @Assert('value.length == 8')
  const factory GameId(String value) = _GameId;

  factory GameId.fromJson(Map<String, dynamic> json) => _$GameIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class GameFullId with _$GameFullId {
  const GameFullId._();

  @Assert('value.length == 12')
  const factory GameFullId(String value) = _GameFullId;

  factory GameFullId.fromJson(Map<String, dynamic> json) =>
      _$GameFullIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class GamePlayerId with _$GamePlayerId {
  const GamePlayerId._();

  @Assert('value.length == 4')
  const factory GamePlayerId(String value) = _GamePlayerId;

  factory GamePlayerId.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class PuzzleId with _$PuzzleId {
  const factory PuzzleId(String value) = _PuzzleId;

  factory PuzzleId.fromJson(Map<String, dynamic> json) =>
      _$PuzzleIdFromJson(json);

  @override
  String toString() => value;
}
