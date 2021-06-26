import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:riverpod_machine/riverpod_machine.dart';

part 'riverpod_machine_test.freezed.dart';

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

  group('status', () {
    test('.notStarted is the initial status', () {
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
  });
}

@freezed
class Event1 with _$Event1 {
  const factory Event1.next() = _E1Next;
}

@freezed
class State1 with _$State1 {
  const factory State1.foo() = _S1Foo;
  const factory State1.bar() = _S1Bar;
  const factory State1.baz() = _S1Baz;
}
