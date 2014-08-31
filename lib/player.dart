library player;

import 'package:polymer/polymer.dart';

class Position {
  static const RB = const Position._('RB');
  static const WR = const Position._('WR');
  static const QB = const Position._('QB');
  static const TE = const Position._('TE');
  static const K = const Position._('K');

  static get values => const [RB, WR, QB, TE, K];

  static Position valueFrom(String value) {
    return values.firstWhere((e) => e.value == value);
  }

  final String value;
  const Position._(this.value);
}

class Player extends Observable {
  final String name;
  final int tier;
  final num projectedPoints;
  final Position position;
  final int rank;
  @observable bool isDrafted;

  Player(this.name, this.position, this.rank, this.tier, this.projectedPoints, this.isDrafted);

  Player.fromRaw(Map value):
      name = value['Player Name'],
      position = Position.valueFrom(value['Position']),
      rank = value['Rank'],
      tier = value['Tier'],
      projectedPoints = value['Avg 2014 Projected Points'],
      isDrafted = value['Drafted'] || false;

  Map toRaw() {
    return {
      'Player Name': name,
      'Position': position.value,
      'Rank': rank,
      'Tier': tier,
      'Avg 2014 Projected Points': projectedPoints,
      'Drafted': isDrafted
    };
  }
}
