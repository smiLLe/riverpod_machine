part of 'state_machine_provider.dart';

class Scheduler {
  final List<void Function()> _queue = [];
  bool _processingEvent = false;
  bool _initialized = false;

  void dispose() {
    clear();
  }

  void clear() {
    _queue.clear();
  }

  void initialize([void Function()? callback]) {
    _initialized = true;

    if (null != callback) {
      process(callback);
    }

    flushEvents();
  }

  void schedule(void Function() task) {
    if (!_initialized || _processingEvent) {
      _queue.add(task);
      return;
    }

    if (_queue.isNotEmpty) {
      throw Exception(
          'Event queue should be empty when it is not processing events');
    }

    process(task);
    flushEvents();
  }

  void flushEvents() {
    if (_queue.isEmpty) return;
    void Function()? nextCallback = _queue.removeAt(0);
    while (null != nextCallback) {
      process(nextCallback);
      if (_queue.isEmpty) {
        nextCallback = null;
      } else {
        nextCallback = _queue.removeAt(0);
      }
    }
  }

  void process(void Function() callback) {
    _processingEvent = true;
    try {
      callback();
    }
    // catch (e) {
    //   // there is no use to keep the future events
    //   // as the situation is not anymore the same
    //   _queue.clear();
    //   rethrow;
    // }
     finally {
      _processingEvent = false;
    }
  }
}
