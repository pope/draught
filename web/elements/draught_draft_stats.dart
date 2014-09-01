import 'package:draught/player.dart';
import 'package:polymer/polymer.dart';

@CustomTag('draught-draft-stats')
class DraughtDraftStats extends PolymerElement {

  @published Roster roster;
  @observable Map<Position, int> totals = toObservable(new Map());

  @ComputedProperty('totals.values')
  int get total => totals.values.fold(0, (a, b) => a + b);

  DraughtDraftStats.created() : super.created();

  @override
  void attached() {
    super.attached();

    // Reset.
    Position.values.forEach((p) => totals[p] = 0);
    // Recalculate.
    roster.players
        .where((p) => p.isDrafted)
        .forEach((p) => totals[p.position]++);
    // Listen.
    roster.playerChanges.listen((cl) => cl.forEach((c) {
      Player p = c.object;
      if (p.isDrafted) {
        totals[p.position]++;
      } else {
        totals[p.position]--;
      }
    }));
  }
}
