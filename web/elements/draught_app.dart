import 'package:draught/player.dart';
import 'package:polymer/polymer.dart';

@CustomTag('draught-app')
class DraughtApp extends PolymerElement {

  @observable Roster roster;
  @observable Iterable<Position> positions = Position.values;
  @observable String errorMessage = '';

  DraughtApp.created() : super.created();

  @override
  void attached() {
    super.attached();
    loadRoster().then((r) => roster = r,
                      onError: (e) => errorMessage = e.toString());
  }
}
