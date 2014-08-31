import 'package:polymer/polymer.dart';
import 'package:ffapp/player.dart';
import 'package:ffapp/streams.dart';
import 'dart:html' show window, HttpRequest;
import 'dart:convert' show JSON;
import 'dart:async' show Future;

@CustomTag('ff-app-data')
class FfAppDataElement extends PolymerElement {

  static const String _name = 'ff-players';
  @published List<Player> players;
  var _playersSub;

  FfAppDataElement.created(): super.created();

  @override
  void attached() {
    var jsonFuture = window.localStorage.containsKey(_name) ?
        new Future.value(window.localStorage[_name]) :
        HttpRequest.getString('2014-draft-info.json');
    jsonFuture.then((json) {
      players = toObservable(JSON.decode(json).map((p) =>
          new Player.fromRaw(p)));
    });
  }

  void playersChanged(oldVal, newVal) {
    if (_playersSub) {
      _playersSub.cancel();
    }
    _playersSub = unify(players.map((p) => p.changes)).listen((_) => save());
    save();
  }

  void save() {
    window.localStorage[_name] = JSON.encode(players.map((p) => p.toRaw()).toList());
  }
}
