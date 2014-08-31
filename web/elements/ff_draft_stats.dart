import 'package:ffapp/player.dart';
import 'package:ffapp/streams.dart';
import 'package:polymer/polymer.dart';
import 'dart:async' show StreamSubscription;

@CustomTag('ff-draft-stats')

class FfDraftStatsElement extends PolymerElement {

  @published Iterable<Player> players;
  @observable Map<Position, int> totals = toObservable(new Map());
  StreamSubscription _sub;

  @ComputedProperty('totals.values')
  int get total => totals.values.fold(0, (a, b) => a + b);

  FfDraftStatsElement.created() : super.created();

  void playersChanged(oldVal, newVal) {
    if (_sub != null) {
      _sub.cancel();
    }

    // Reset.
    Position.values.forEach((p) => totals[p] = 0);
    // Recalculate.
    players.where((p) => p.isDrafted).forEach((p) => totals[p.position]++);
    // Listen.
    _sub = unify(players.map((p) => p.changes)).listen((cl) => cl.forEach((c) {
      Player p = c.object;
      if (p.isDrafted) {
        totals[p.position]++;
      } else {
        totals[p.position]--;
      }
    }));
  }
}
