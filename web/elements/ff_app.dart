import 'package:polymer/polymer.dart';
import 'package:ffapp/player.dart';

@CustomTag('ff-app')
class FfAppElement extends PolymerElement {

  @observable Roster roster;
  @observable Iterable<Position> positions = Position.values;
  @observable String errorMessage = '';

  FfAppElement.created() : super.created();

  @override
  void attached() {
    super.attached();
    loadRoster().then((r) => roster = r,
                      onError: (e) => errorMessage = e.toString());
  }
}
