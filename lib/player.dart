library player;

import 'dart:async';
import 'dart:convert';
import 'dart:html' show window, HttpRequest;
import 'package:ffapp/streams.dart';
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

class Roster {

  final Iterable<Player> players;
  final Stream<List<ChangeRecord>> playerChanges;

  Roster(this.players, this.playerChanges) : super();
}

const String _name = 'ff-players';
Roster _roster = null;

Future<Roster> loadRoster() {
  if (_roster != null) {
    return new Future.value(_roster);
  }
  var jsonFuture = window.localStorage.containsKey(_name) ?
      new Future.value(window.localStorage[_name]) :
      HttpRequest.getString('2014-draft-info.json');
  return jsonFuture.then((json) {
    List<Player> players = toObservable(JSON.decode(json).map((p) =>
        new Player.fromRaw(p)));
    Stream<List<ChangeRecord>> playerChanges =
        unify(players.map((p) => p.changes), broadcast: true);
    _roster = new Roster(players, playerChanges);
    playerChanges.listen((_) => _save());
    return _roster;
  });
}

void _save() {
  window.localStorage[_name] =
      JSON.encode(_roster.players.map((p) => p.toRaw()).toList());
}
