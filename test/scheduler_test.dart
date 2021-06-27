import 'package:riverpod_machine/src/machine.dart';
import 'package:test/test.dart';
import 'package:riverpod_machine/riverpod_machine.dart';

void main() {
  group('scheduler', () {
    test('should process event only once', () {
      int calledCount = 0;
      final scheduler = Scheduler();
      scheduler.initialize();
      scheduler.schedule(() {
        calledCount++;
      });

      expect(calledCount, 1);
    });

    test('should process more than one event', () {
      int calledCount = 0;
      final scheduler = Scheduler();
      scheduler.initialize();
      scheduler.schedule(() {
        calledCount++;
        scheduler.schedule(() {
          calledCount++;
        });
      });

      expect(calledCount, 2);
    });

    test('should process events in the same order they were hit', () {
      List<int> order = [];
      final scheduler = Scheduler();
      scheduler.initialize();
      scheduler.schedule(() {
        order.add(1);
        scheduler.schedule(() {
          order.add(2);
        });
        scheduler.schedule(() {
          order.add(3);
          scheduler.schedule(() {
            order.add(5);
          });
        });
        scheduler.schedule(() {
          order.add(4);
        });
      });

      const expectedOrder = [1, 2, 3, 4, 5];
      expect(order.length, expectedOrder.length);
      for (int i = 0; i < expectedOrder.length; i++) {
        expect(order[i], expectedOrder[i]);
      }
    });

    test('should recover if error is thrown while processing the queue', () {
      int calledCount = 0;
      final scheduler = Scheduler();
      scheduler.initialize();
      expect(
        () => scheduler.schedule(() {
          calledCount++;
          scheduler.schedule(() {
            calledCount++;
            throw Exception();
          });
        }),
        throwsException,
      );
      scheduler.schedule(() {
        calledCount++;
      });

      expect(calledCount, 3);
    });

    test('should stop processing events if error condition is met', () {
      int calledCount = 0;
      final scheduler = Scheduler();
      scheduler.initialize();
      expect(
        () => scheduler.schedule(() {
          calledCount++;
          scheduler.schedule(() {
            calledCount++;
            throw Exception();
          });
          scheduler.schedule(() {
            calledCount++;
          });
        }),
        throwsException,
      );

      expect(calledCount, 2);
    });

    // test('should discard not processed events in the case of error condition',
    //     () {
    //   int calledCount = 0;
    //   final scheduler = Scheduler();
    //   scheduler.initialize();
    //   expect(
    //     () => scheduler.schedule(() {
    //       calledCount++;
    //       scheduler.schedule(() {
    //         calledCount++;
    //         throw Exception();
    //       });
    //       scheduler.schedule(() {
    //         calledCount++;
    //       });
    //     }),
    //     throwsException,
    //   );
    //   scheduler.schedule(() {
    //     calledCount++;
    //   });
    //   expect(calledCount, 3);
    // });
  });
}
