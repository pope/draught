import 'package:draught/player.dart';
import 'package:polymer/polymer.dart';

@CustomTag('draught-player-list')
class DraughtPlayerList extends PolymerElement {

  @published Roster roster;
  @observable bool filterDrafted = true;
  @observable String searchText = '';

  DraughtPlayerList.created() : super.created();

  search(String text) => (Iterable<Player> players) {
    var lowerText = text.toLowerCase();
    return players.where((p) => p.name.toLowerCase().contains(lowerText));
  };
}
