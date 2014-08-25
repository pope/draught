import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('my-filtered-list')
class MyFilteredListElement extends PolymerElement {

  ObservableList<Map> _items = toObservable([]);

  MyFilteredListElement.created() : super.created();

  @published List<Map> get items => _items;
  @published void set items(List<Map> value) {
    _items = notifyPropertyChange(
        #items, _items, toObservable(value, deep: true));
  }

  @override void domReady() {
    super.domReady();
    shadowRoot.on['item-change'].listen((Event event) {
      items = new List.from(items);
    });
  }

  hideChecked(items) => items.where((e) => e['checked'] == false);
  hideUnchecked(items) => items.where((e) => e['checked'] == true);
}
