import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:riverpod_machine/riverpod_machine.dart';

import 'riverpod_machine_test.mocks.dart';

part 'riverpod_machine_test.freezed.dart';

@GenerateMocks([EventListener, OnExitCb])
void main() {
  test('create machine provider', () {
    final container = ProviderContainer();
    expect(
        () => container.read(
            StateMachineProvider<State1, Event1>((ref) => const State1.foo())),
        isNot(throwsException));
  });

  test('read machine', () {
    final container = ProviderContainer();

    expect(
        () => container.read(
            StateMachineProvider<State1, Event1>((ref) => const State1.foo())
                .machine),
        isNot(throwsException));

    final machine = container.read(
        StateMachineProvider<State1, Event1>((ref) => const State1.foo())
            .machine);

    expect(machine, isA<StateMachine<State1, Event1>>());
  });

  test('dispose machine', () {
    final container = ProviderContainer();

    expect(
        () => container
            .read(StateMachineProvider<State1, Event1>(
                (ref) => const State1.foo()).machine)
            .dispose(),
        isNot(throwsException));
  });

  group('.onExit()', () {
    test('callbacks executed when leaving state', () {
      final container = ProviderContainer();
      final onExitCbA = MockOnExitCb();
      final onExitCbB = MockOnExitCb();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          cfg.onExit(onExitCbA);
          cfg.onExit(onExitCbB);
          cfg.onEvent<_E1Next>((event) {
            cfg.transition(const State1.bar());
          });
        });
        ref.onState<_S1Bar>((cfg) {});
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine)
        ..start()
        ..send(const Event1.next());

      verify(onExitCbA()).called(1);
      verify(onExitCbB()).called(1);
    });

    test('will immediately execute when added, after state has been left',
        () async {
      final container = ProviderContainer();
      final onExitCb = MockOnExitCb();
      final c = Completer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          Future(() {
            cfg.onExit(onExitCb);
            c.complete();
          });
          cfg.onEvent<_E1Next>((event) {
            cfg.transition(const State1.bar());
          });
        });
        ref.onState<_S1Bar>((cfg) {});
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine)
        ..start()
        ..send(const Event1.next());

      await c.future;

      verify(onExitCb()).called(1);
    });
  });

  group('assert on start/stop', () {
    late ProviderContainer container;
    late StateMachineProvider<State1, Event1> provider;
    setUp(() {
      container = ProviderContainer();
      provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {});
        ref.onState<_S1Bar>((cfg) {});
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });
    });
    test('cannot start machine when it is already running', () {
      container.read(provider.machine).start();

      expect(() => container.read(provider.machine).start(),
          throwsA(isA<AssertionError>()));
    });

    test('cannot stop machine when it is not started', () {
      expect(() => container.read(provider.machine).stop(),
          throwsA(isA<AssertionError>()));
    });

    test('cannot stop machine when it is stopped', () {
      expect(() => container.read(provider.machine).stop(),
          throwsA(isA<AssertionError>()));
    });
  });

  group('status', () {
    test('is in .notStarted by default', () {
      final container = ProviderContainer();
      expect(
          container.read(StateMachineProvider<State1, Event1>(
              (ref) => const State1.foo())),
          StateMachineStatus<State1, Event1>.notStarted());
    });

    test('will become .running when machine started', () {
      final container = ProviderContainer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine).start();

      expect(
          container.read(provider),
          StateMachineStatus<State1, Event1>.running(
              state: const State1.foo()));
    });

    test('can become .stopped', () {
      final container = ProviderContainer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine)
        ..start()
        ..stop();

      expect(
          container.read(provider),
          StateMachineStatus<State1, Event1>.stopped(
              lastState: const State1.foo()));
    });
  });

  group('transition', () {
    test('synchronously/immediately from one state to another', () {
      final container = ProviderContainer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          cfg.transition(const State1.bar());
        });
        ref.onState<_S1Bar>((cfg) {
          cfg.transition(const State1.baz());
        });
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine).start();

      expect(
          container.read(provider),
          StateMachineStatus<State1, Event1>.running(
              state: const State1.baz()));
    });

    test('async from one state to another', () async {
      final container = ProviderContainer();
      final completer = Completer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          Future(() {
            completer.complete();
            cfg.transition(const State1.bar());
          });
        });
        ref.onState<_S1Bar>((cfg) {});
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine).start();

      await completer.future;
      expect(
          container.read(provider),
          StateMachineStatus<State1, Event1>.running(
              state: const State1.bar()));
    });

    test('is no longer possible if state has been left before', () async {
      final container = ProviderContainer();
      final completer = Completer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          cfg.transition(const State1.bar());
          Future(() {
            try {
              cfg.transition(const State1.baz());
            } catch (e) {
              completer.completeError(e);
            }
          });
        });
        ref.onState<_S1Bar>((cfg) {});
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine).start();

      expectLater(completer.future, throwsA(isA<AssertionError>()));

      try {
        await completer.future;
      } catch (_) {}
      expect(
          container.read(provider),
          StateMachineStatus<State1, Event1>.running(
              state: const State1.bar()));
    });

    test('can be checked', () async {
      final container = ProviderContainer();
      final completer = Completer();
      bool? canTransition1;
      bool? canTransition2;
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          canTransition1 = cfg.canTransition(const State1.bar());
          cfg.transition(const State1.bar());
          Future(() {
            canTransition2 = cfg.canTransition(const State1.bar());
            completer.complete();
          });
        });
        ref.onState<_S1Bar>((cfg) {});
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine).start();

      await completer.future;

      expect(canTransition1, isTrue);
      expect(canTransition2, isFalse);
    });
  });

  group('event', () {
    test('can be checked if possible to be .send()', () {
      final container = ProviderContainer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          cfg.onEvent<_E1Next>((event) {});
        });
        ref.onState<_S1Bar>((cfg) {});
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      expect(container.read(provider.machine).canSend(const Event1.next()),
          isFalse);

      container.read(provider.machine).start();
      expect(container.read(provider.machine).canSend(const Event1.next()),
          isTrue);
      expect(container.read(provider.machine).canSend(const Event1.toBar()),
          isFalse);

      container.read(provider.machine).stop();
      expect(container.read(provider.machine).canSend(const Event1.next()),
          isFalse);
    });

    test('cannot be .send() to machine while it is not started', () {
      final container = ProviderContainer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          cfg.transition(const State1.bar());
        });
        ref.onState<_S1Bar>((cfg) {
          cfg.transition(const State1.baz());
        });
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      expect(() => container.read(provider.machine).send(const Event1.next()),
          throwsA(isA<AssertionError>()));
    });

    test('cannot be .send() to machine while it is stopped', () {
      final container = ProviderContainer();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          cfg.transition(const State1.bar());
        });
        ref.onState<_S1Bar>((cfg) {
          cfg.transition(const State1.baz());
        });
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine)
        ..start()
        ..stop();

      expect(() => container.read(provider.machine).send(const Event1.next()),
          throwsA(isA<AssertionError>()));
    });

    test('can be listened for, in specific state while machine is running', () {
      final container = ProviderContainer();
      final listenerNext = MockEventListener<_E1Next>();
      final listenerToBar = MockEventListener<_E1ToBar>();
      final provider = StateMachineProvider<State1, Event1>((ref) {
        ref.onState<_S1Foo>((cfg) {
          cfg.onEvent<_E1Next>(listenerNext);
          cfg.onEvent<_E1ToBar>(listenerToBar);
          cfg.onEvent<_E1ToBaz>((_) => cfg.transition(const State1.baz()));
        });
        ref.onState<_S1Bar>((cfg) {});
        ref.onState<_S1Baz>((cfg) {});
        return const State1.foo();
      });

      container.read(provider.machine)
        ..start()
        ..send(const Event1.next())
        ..send(const Event1.toBar());

      verify(listenerNext(const Event1.next())).called(1);
      verify(listenerToBar(const Event1.toBar())).called(1);

      verifyNoMoreInteractions(listenerNext);
      verifyNoMoreInteractions(listenerToBar);

      container.read(provider.machine)
        ..send(const Event1.toBaz())
        ..send(const Event1.next())
        ..send(const Event1.toBar());
    });
  });
}

class EventListener<Event> extends Mock {
  void call(Event1 event);
}

class OnExitCb extends Mock {
  void call();
}

@freezed
class Event1 with _$Event1 {
  const factory Event1.next() = _E1Next;
  const factory Event1.toBar() = _E1ToBar;
  const factory Event1.toBaz() = _E1ToBaz;
  const factory Event1.toFoo() = _E1ToFoo;
}

@freezed
class State1 with _$State1 {
  const factory State1.foo() = _S1Foo;
  const factory State1.bar() = _S1Bar;
  const factory State1.baz() = _S1Baz;
}
