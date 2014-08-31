import 'package:polymer/polymer.dart';
import 'package:ffapp/player.dart';

@CustomTag('ff-app')
class FfAppElement extends PolymerElement {

  @observable Iterable<Player> players;
  @observable Iterable<Position> positions = Position.values;

  FfAppElement.created() : super.created();
}
