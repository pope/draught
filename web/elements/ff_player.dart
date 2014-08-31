import 'package:polymer/polymer.dart';
import 'package:ffapp/player.dart';

@CustomTag('ff-player')
class FfPlayerElement extends PolymerElement {
  @published Player player;

  FfPlayerElement.created() : super.created();

  toFixed(int digits) => (num n) => n.toStringAsFixed(digits);
}
