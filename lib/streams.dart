library streams;

import 'dart:async';

Stream unify(Iterable<Stream> sources, {broadcast: false}) {
  List<StreamSubscription> subscriptions;
  StreamController controller;

  void onDone(StreamSubscription sub) {
    subscriptions.remove(sub);
    if (subscriptions.isEmpty) {
      controller.close();
    }
  }

  void onListen() {
    subscriptions = sources.map((s) {
        var sub = s.listen(controller.add,
                           onError: controller.addError);
        sub.onDone(() => onDone(sub));
        return sub;
    }).toList();
  }

  void onCancel() {
    subscriptions.forEach((s) => s.cancel());
    // This may be incorrect.
    subscriptions.clear();
  }

  void onResume() => subscriptions.forEach((s) => s.resume());
  void onPause() => subscriptions.forEach((s) => s.pause());

  if (broadcast) {
    controller = new StreamController.broadcast(
        onListen: onListen,
        onCancel: onCancel);
  } else {
    controller = new StreamController(
        onListen: onListen,
        onPause: onPause,
        onResume: onResume,
        onCancel: onCancel);
  }

  return controller.stream;
}

Stream<Iterable> rateLimit(Stream source, Duration dur) {
  Timer t;
  StreamController<Iterable> controller;
  StreamSubscription sub;
  var queue = [];
  var isDone = false;

  void cancelTimer() {
    if (t == null) {
      return;
    }
    t.cancel();
    t = null;
  }

  void tick() {
    if (queue.isEmpty) {
      t = null;
      if (isDone) {
        controller.close();
      }
      return;
    }
    controller.add(queue);
    queue = [];
    if (isDone) {
      controller.close();
      return;
    }
    t = new Timer(dur, tick);
  }

  void onSubAdd(item) {
    if (t != null) {
      queue.add(item);
      return;
    }
    assert(queue.isEmpty);
    controller.add([item]);
    t = new Timer(dur, tick);
  }

  void onSubDone() {
    isDone = true;
    if (t != null && !queue.isEmpty) {
      // Let the timer take care of this.
      return;
    }
    cancelTimer();
    assert(queue.isEmpty);
    controller.close();
  }

  void onListen() {
    sub = source.listen(onSubAdd,
                        onError: controller.addError,
                        onDone: onSubDone);
  }

  void onPause() {
    sub.pause();
    cancelTimer();
  }

  void onResume() {
    sub.resume();
    tick();
  }

  void onCancel() {
    sub.cancel();
    cancelTimer();  // Leave whatever remains on the queue until resume.
  }

  controller = new StreamController<Iterable>(
      onListen: onListen,
      onPause: onPause,
      onResume: onResume,
      onCancel: onCancel);

  return controller.stream;
}
