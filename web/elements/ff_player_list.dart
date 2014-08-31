import 'package:polymer/polymer.dart';
import 'package:ffapp/player.dart';

@CustomTag('ff-player-list')
class FfPlayerListElement extends PolymerElement {

  @published Iterable<Player> players;
  @observable bool filterDrafted = true;
  @observable String searchText = '';

  FfPlayerListElement.created(): super.created();

  search(String text) => (Iterable<Player> players) {
    var lowerText = text.toLowerCase();
    return players.where((p) => p.name.toLowerCase().contains(lowerText));
  };
}
