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

// TODO(pope): Don't make this model ALSO the service that loads it.
class Roster extends Observable {

  static const String _name = 'ff-players';

  List<Player> _players;
  Stream<List<ChangeRecord>> _playerChanges;

  @observable Iterable<Player> get players => _players;
  Stream<List<ChangeRecord>> get playerChanges => _playerChanges;

  Future<Roster> load() {
    if (_players != null) {
      return new Future.value(this);
    }
    var jsonFuture = window.localStorage.containsKey(_name) ?
        new Future.value(window.localStorage[_name]) :
        HttpRequest.getString('2014-draft-info.json');
    return jsonFuture.then((json) {
      _players = toObservable(JSON.decode(json).map((p) =>
          new Player.fromRaw(p)));
      _playerChanges = unify(_players.map((p) => p.changes), broadcast: true);
      _playerChanges.listen((_) => save());
      return this;
    });
  }

  void save() {
    window.localStorage[_name] =
        JSON.encode(players.map((p) => p.toRaw()).toList());
  }
}
