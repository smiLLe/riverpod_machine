import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_machine/src/state_machine_provider/base.dart';
import 'package:riverpod_machine/src/state_machine_provider.dart';
import 'package:test/test.dart';

import 'machine_test.mocks.dart';

part 'machine_test.freezed.dart';

@GenerateMocks([EventListener, OnExitCb, OnStateCb])
void main() {
  group('a', () {
    test('element', () {
      final container = ProviderContainer();
      final machine = StateMachineProvider<State, Event>((ref) {
        ref.onState<_Foo>((self) {});
        ref.onState<_Bar>((self) {});
        ref.onState<_Baz>((self) {});
        return const State.foo();
      });
      final element = container.readProviderElement(machine);
      expect(element, isA<MachineProviderElement<State, Event>>());

      final e = element as MachineProviderElement<State, Event>;
      expect(e.activeState, isA<ActiveState<State, _Foo, Event>>());
      expect(e.states.length, 3);
      expect(e.states[0], isA<StateNode<State, _Foo, Event>>());
      expect(e.states[1], isA<StateNode<State, _Bar, Event>>());
      expect(e.states[2], isA<StateNode<State, _Baz, Event>>());

      e.reset();
      expect(e.activeState, isNull);
      expect(e.states.length, 0);
    });

    group('StateMachine', () {
      test('.send() changes state', () {
        final container = ProviderContainer();
        final machine = StateMachineProvider<State, Event>((ref) {
          ref.onState<_Foo>((self) {
            self.onEvent<_Next>((event) {
              self.transition(const State.bar());
            });
          });
          ref.onState<_Bar>((self) {});
          ref.onState<_Baz>((self) {});
          return const State.foo();
        });
        container.read(machine).send(const Event.next());
        expect(container.read(machine).state.value, const State.bar());

        final element = container.readProviderElement(machine)
            as MachineProviderElement<State, Event>;
        expect(element.send, container.read(machine).send);
      });

      test('.send will execute event callback', () {
        final ev1 = MockEventListener<_Next>();
        final ev2 = MockEventListener<_ToBaz>();
        final container = ProviderContainer();
        final machine = StateMachineProvider<State, Event>((ref) {
          ref.onState<_Foo>((self) {
            self.onEvent<_Next>(ev1);
            self.onEvent<_ToBaz>(ev2);
            self.onEvent<_ToBar>((_) {
              self.transition(const State.bar());
            });
          });
          ref.onState<_Bar>((self) {});
          ref.onState<_Baz>((self) {});
          return const State.foo();
        });

        container.read(machine).send(const Event.next());
        verify(ev1(argThat(isA<_Next>()))).called(1);
        verifyZeroInteractions(ev2);

        container.read(machine).send(const Event.toBaz());
        verify(ev2(argThat(isA<_ToBaz>()))).called(1);

        container.read(machine).send(const Event.toBar());

        container.read(machine).send(const Event.next());
        container.read(machine).send(const Event.toBaz());
        verifyNoMoreInteractions(ev1);
        verifyNoMoreInteractions(ev2);
      });
    });

    group('transition', () {
      test('immediately', () {
        final container = ProviderContainer();
        final machine = StateMachineProvider<State, Event>((ref) {
          ref.onState<_Foo>((self) {
            self.transition(const State.bar());
          });
          ref.onState<_Bar>((self) {
            self.transition(const State.baz());
          });
          ref.onState<_Baz>((self) {});
          return const State.foo();
        });
        final element = container.readProviderElement(machine)
            as MachineProviderElement<State, Event>;
        expect(element.state.state.value, const State.baz());
        expect(element.activeState, isA<ActiveState<State, _Baz, Event>>());
      });

      test('changes .activeState', () {
        final container = ProviderContainer();
        final machine = StateMachineProvider<State, Event>((ref) {
          ref.onState<_Foo>((self) {});
          ref.onState<_Bar>((self) {});
          ref.onState<_Baz>((self) {});
          return const State.foo();
        });
        final element = container.readProviderElement(machine)
            as MachineProviderElement<State, Event>;
        element..transition(const State.bar())..transition(const State.baz());
        expect(element.state.state.value, const State.baz());
        expect(element.activeState, isA<ActiveState<State, _Baz, Event>>());
      });

      test('will call onState', () {
        final fooCb = MockOnStateCb<_Foo>();
        final barCb = MockOnStateCb<_Bar>();
        final bazCb = MockOnStateCb<_Baz>();
        final container = ProviderContainer();
        final machine = StateMachineProvider<State, Event>((ref) {
          ref.onState<_Foo>(fooCb);
          ref.onState<_Bar>(barCb);
          ref.onState<_Baz>(bazCb);
          return const State.foo();
        });

        final element = container.readProviderElement(machine)
            as MachineProviderElement<State, Event>;

        element
          ..transition(const State.bar())
          ..transition(const State.baz())
          ..transition(const State.foo());

        verifyInOrder([
          fooCb(argThat(isA<ActiveState<State, _Foo, Event>>())),
          barCb(argThat(isA<ActiveState<State, _Bar, Event>>())),
          bazCb(argThat(isA<ActiveState<State, _Baz, Event>>())),
          fooCb(argThat(isA<ActiveState<State, _Foo, Event>>())),
        ]);
      });

      test('will execute onExit', () {
        final onExit1 = MockOnExitCb();
        final onExit2 = MockOnExitCb();
        final onExit11 = MockOnExitCb();
        final onExit22 = MockOnExitCb();
        final container = ProviderContainer();
        final machine = StateMachineProvider<State, Event>((ref) {
          ref.onState<_Foo>((self) {
            self.onExit(onExit1);
            self.onExit(onExit2);
          });
          ref.onState<_Bar>((self) {
            self.onExit(onExit11);
            self.onExit(onExit22);
            self.transition(const State.baz());
          });
          ref.onState<_Baz>((self) {
            self.transition(const State.foo());
          });
          return const State.foo();
        });

        final element = container.readProviderElement(machine)
            as MachineProviderElement<State, Event>;

        element.transition(const State.bar());

        verifyInOrder([
          onExit1(),
          onExit2(),
          onExit11(),
          onExit22(),
        ]);
      });
    });

    test('active state became inactive', () {
      final container = ProviderContainer();
      final machine = StateMachineProvider<State, Event>((ref) {
        ref.onState<_Foo>((self) {});
        ref.onState<_Bar>((self) {});
        ref.onState<_Baz>((self) {});
        return const State.foo();
      });
      final element = container.readProviderElement(machine)
          as MachineProviderElement<State, Event>;
      final fooActive = element.activeState!;
      element.transition(const State.bar());
      expect(() => fooActive.transition(const State.bar()),
          throwsA(isA<AssertionError>()));
      expect(() => fooActive.onExit(() {}), throwsA(isA<AssertionError>()));
      expect(
          () => fooActive.onEvent((event) {}), throwsA(isA<AssertionError>()));
      expect(fooActive.canTransition(), isFalse);
    });

    test('a', () {
      final container = ProviderContainer();
      final machine = StateMachineProvider<State, Event>((ref) {
        ref.onState<_Foo>((self) {});
        return const State.foo();
      });
      expect(container.read(machine).state.value, const State.foo());
    });
  });
}

@freezed
class State with _$State {
  const factory State.foo() = _Foo;
  const factory State.bar() = _Bar;
  const factory State.baz() = _Baz;
}

@freezed
class Event with _$Event {
  const factory Event.next() = _Next;
  const factory Event.toFoo() = _ToFoo;
  const factory Event.toBar() = _ToBar;
  const factory Event.toBaz() = _ToBaz;
}

class EventListener<Event> extends Mock {
  void call(Event event);
}

class OnExitCb extends Mock {
  void call();
}

class OnStateCb<S extends State> extends Mock {
  void call(ActiveState<State, S, Event> self);
}
