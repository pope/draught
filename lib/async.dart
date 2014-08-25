library async;

import 'dart:async';

class StreamOfStreams<T> extends Stream<T> {

  final List<Stream<T>> _source;
  final List<StreamSubscription<T>> _subscriptions = [];
  StreamController<T> _controller;

  StreamOfStreams(List<Stream<T>> source) : _source = source,
                                            super() {
    _controller = new StreamController<T>(
        onListen: _onListen,
        onPause: _onPause,
        onResume: _onResume,
        onCancel: _onCancel);
  }

  @override
  StreamSubscription<T> listen(void onData(T event),
                               { void onError(Error error),
                                 void onDone(),
                                 bool cancelOnError }) {
    return _controller.stream.listen(onData,
                                     onError: onError,
                                     onDone: onDone,
                                     cancelOnError: cancelOnError);
  }

  void _onListen() {
    assert(_subscriptions.isEmpty);
    _subscriptions.addAll(_source.map((e) {
        var sub = e.listen(_controller.add,
                           onError: _controller.addError);
        sub.onDone(() => _onDone(sub));
        return sub;
    }));
  }

  void _onCancel() {
    _subscriptions.forEach((e) => e.cancel());
    // This may be incorrect
    _subscriptions.clear();
  }

  void _onResume() {
    _subscriptions.forEach((e) => e.resume());
  }

  void _onPause() {
    _subscriptions.forEach((e) => e.pause());
  }

  void _onDone(StreamSubscription<T> sub) {
    _subscriptions.remove(sub);
    if (_subscriptions.isEmpty) {
      _controller.close();
    }
  }
}
