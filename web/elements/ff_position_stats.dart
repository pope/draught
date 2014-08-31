import 'package:polymer/polymer.dart';
import 'package:ffapp/player.dart';
import 'dart:collection';

bool _isDrafted(Player p) => p.isDrafted;
bool _isNotDrafted(Player p) => !p.isDrafted;

class TierSummary {
  final int tier;
  final num averagePoints;
  final int remaining;
  final int goneBy;

  TierSummary(this.tier, this.averagePoints, this.remaining, this.goneBy)
      : super();
}

@CustomTag('ff-position-stats')
class FfPositionStats extends PolymerElement {

  @published Roster roster;
  @published Position position;

  @observable List<TierSummary> summary = toObservable([]);
  @observable Player nextPick;

  FfPositionStats.created() : super.created();

  @override
  void attached() {
    super.attached();

    _updateSummary();
    roster.playerChanges.listen((_) => _updateSummary());
  }

  // TODO(pope): This could probably be made more efficient; however it's good
  // enough for now...if you're using Chrome.
  void _updateSummary() {
    nextPick = null;
    summary.clear();

    Map<int,List<Player>> grouped = new SplayTreeMap((a, b) => a - b);
    roster.players.where((p) => p.position == position).forEach((p) {
      grouped.putIfAbsent(p.tier, () => []).add(p);
    });
    summary.addAll(grouped.keys.map((tier) {
      var tieredPlayers = grouped[tier];
      var totalPlayers = tieredPlayers.length;
      var sum = tieredPlayers.fold(0, (sum, p) => sum + p.projectedPoints);
      var avg = sum / totalPlayers;
      var totalDrafted = tieredPlayers.where(_isDrafted).length;
      var remaining = totalPlayers - totalDrafted;
      var goneBy = 0;
      if (remaining > 0) {
        var lastPlayer = tieredPlayers.lastWhere(_isNotDrafted);
        if (nextPick == null) {
          nextPick = tieredPlayers.firstWhere(_isNotDrafted);
        }
        var allUndrafted = roster.players.where(_isNotDrafted).toList();
        goneBy = allUndrafted.indexOf(lastPlayer) + 1;
      }
      return new TierSummary(tier, avg, remaining, goneBy);
    }));
  }

  toFixed(int digits) => (num n) => n.toStringAsFixed(digits);
}
