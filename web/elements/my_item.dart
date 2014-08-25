import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('my-item')
class MyItemElement extends PolymerElement {

  ObservableMap _item = toObservable({});

  MyItemElement.created() : super.created();

  @published Map get item => _item;
  @published void set item(Map value) {
    _item = notifyPropertyChange(#item, _item, toObservable(value));
  }

  void handleChange(Event e, var detail, Node target) {
    this.fire('item-change', detail: item);
  }
}
