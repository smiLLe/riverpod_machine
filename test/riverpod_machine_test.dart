import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:riverpod_machine/riverpod_machine.dart';

part 'riverpod_machine_test.freezed.dart';

void main() {
  test('a', () {
    final container = ProviderContainer();
    final m1 = StateMachineProvider<State1, Event1>((ref) {
      ref.onState<_S1Foo>((cfg) {
        cfg.onEvent<_E1Next>((event) => cfg.transition(const State1.bar()));
      });
      ref.onState<_S1Bar>((cfg) {});
      return const State1.foo();
    });

    expect(container.read(m1), StateMachineStatus<State1, Event1>.notStarted());

    container.read(m1.machine).start();
    expect(container.read(m1),
        StateMachineStatus<State1, Event1>.running(state: const State1.foo()));

    container.read(m1.machine).send(const Event1.next());
    expect(container.read(m1),
        StateMachineStatus<State1, Event1>.running(state: const State1.bar()));

    container.read(m1.machine).stop();
    expect(
        container.read(m1),
        StateMachineStatus<State1, Event1>.stopped(
            lastState: const State1.bar()));

    container.read(m1.machine).start();
    expect(container.read(m1),
        StateMachineStatus<State1, Event1>.running(state: const State1.foo()));
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
