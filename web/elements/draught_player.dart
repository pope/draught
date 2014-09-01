import 'package:polymer/polymer.dart';
import 'package:draught/player.dart';

@CustomTag('draught-player')
class DraughtPlayer extends PolymerElement {
  @published Player player;

  DraughtPlayer.created() : super.created();

  toFixed(int digits) => (num n) => n.toStringAsFixed(digits);
}
