import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_machine/src/machine.dart';
import 'package:test/test.dart';

import 'machine_test.mocks.dart';

part 'machine_test.freezed.dart';

@GenerateMocks([EventListener, OnExitCb, OnStateCb])
void main() {
  StateNode<State, Event> node<S extends State>(
      OnEnterState<State, S, Event> cb) {
    return StateNode<State, Event>(
      enter: (state) => cb(state as ActiveState<State, S, Event>),
      isState: (dynamic obj) => obj is S,
      createState: (m, v) => ActiveState<State, S, Event>(
        enterState: v as S,
        machine: m,
      ),
    );
  }

  test('create machine', () {
    final fooNode = node<_Foo>((self) {});
    final barNode = node<_Bar>((self) {});
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
      name: 'FooMachine',
    );

    expect(machine.states.length, 3);
    expect(machine.name, 'FooMachine');
    expect(machine.initialStateValue, const State.foo());
    expect(machine.debugState, isA<MachineStatusIdle<State, Event>>());
    expect(machine.getNode(const State.foo()), fooNode);
    expect(machine.getNode(const State.bar()), barNode);
    expect(machine.getNode(const State.baz()), bazNode);
    expect(machine.activeState, isNull);
  });

  test('create machine auto started', () {
    final fooNode = node<_Foo>((self) {});
    final barNode = node<_Bar>((self) {});
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
      autostart: true,
    );

    expect(
        machine.debugState,
        isA<MachineStatusRunning<State, Event>>()
            .having((s) => s.state, 'state', const State.foo()));
  });

  test('change status', () {
    final fooNode = node<_Foo>((self) {});
    final barNode = node<_Bar>((self) {});
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );

    machine.start();
    expect(
        machine.debugState,
        isA<MachineStatusRunning<State, Event>>()
            .having((s) => s.state, 'state', const State.foo()));

    machine.stop();
    expect(
        machine.debugState,
        isA<MachineStatusStopped<State, Event>>()
            .having((s) => s.lastState, 'lastState', const State.foo()));

    machine.start(stateValue: const State.baz());
    expect(
        machine.debugState,
        isA<MachineStatusRunning<State, Event>>()
            .having((s) => s.state, 'state', const State.baz()));

    machine.stop();
    expect(
        machine.debugState,
        isA<MachineStatusStopped<State, Event>>()
            .having((s) => s.lastState, 'lastState', const State.baz()));
  });

  test('.canSend()', () {
    final fooNode = node<_Foo>((self) {
      self.onEvent<_Next>((event) {});
    });
    final barNode = node<_Bar>((self) {
      self.onEvent<_ToBaz>((event) {});
    });
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );

    expect(machine.canSend(const Event.next()), isFalse);
    machine.start();
    expect(machine.canSend(const Event.next()), isTrue);
    expect(machine.canSend(const Event.toFoo()), isFalse);

    machine.stop();
    expect(machine.canSend(const Event.next()), isFalse);

    machine.start(stateValue: const State.bar());
    expect(machine.canSend(const Event.next()), isFalse);
    expect(machine.canSend(const Event.toBaz()), isTrue);
  });

  test('enter a new state', () {
    final enterFoo = MockOnStateCb<_Foo>();
    final enterBar = MockOnStateCb<_Bar>();

    final fooNode = node<_Foo>(enterFoo);
    final barNode = node<_Bar>(enterBar);
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );
    machine.start();
    machine.transition(const State.bar());
    verifyInOrder([
      enterFoo(argThat(isA<ActiveState<State, _Foo, Event>>().having(
          (s) => s.enterState, 'state when entered', const State.foo()))),
      enterBar(argThat(isA<ActiveState<State, _Bar, Event>>().having(
          (s) => s.enterState, 'state when entered', const State.bar())))
    ]);
  });

  group('.canTransition()', () {
    test('after leaving state', () {
      late ActiveState<State, _Foo, Event> foo;
      final fooNode = node<_Foo>((self) {
        foo = self;
      });
      final barNode = node<_Bar>((self) {});
      final bazNode = node<_Baz>((self) {});
      final machine = Machine<State, Event>(
        initialStateValue: const State.foo(),
        states: [fooNode, barNode, bazNode],
      )..start();

      expect(foo.canTransition(), isTrue);
      machine.transition(const State.bar());
      expect(foo.canTransition(), isFalse);
    });

    test('after machine status became stopped', () {
      late ActiveState<State, _Foo, Event> foo;
      final fooNode = node<_Foo>((self) {
        foo = self;
      });
      final barNode = node<_Bar>((self) {});
      final bazNode = node<_Baz>((self) {});
      Machine<State, Event>(
        initialStateValue: const State.foo(),
        states: [fooNode, barNode, bazNode],
      )
        ..start()
        ..stop();

      expect(foo.canTransition(), isFalse);
    });

    test('after machine has been disposed', () {
      late ActiveState<State, _Foo, Event> foo;
      final fooNode = node<_Foo>((self) {
        foo = self;
      });
      final barNode = node<_Bar>((self) {});
      final bazNode = node<_Baz>((self) {});
      Machine<State, Event>(
        initialStateValue: const State.foo(),
        states: [fooNode, barNode, bazNode],
      )
        ..start()
        ..dispose();

      expect(foo.canTransition(), isFalse);
    });
  });

  group('.onExit()', () {
    test('callback will be executed when leaving state', () {
      final leavingFoo1 = MockOnExitCb();
      final leavingFoo2 = MockOnExitCb();
      final leavingBar1 = MockOnExitCb();
      final fooNode = node<_Foo>((self) {
        self.onExit(leavingFoo1);
        self.onExit(leavingFoo2);
      });
      final barNode = node<_Bar>((self) {
        self.onExit(leavingBar1);
      });
      final bazNode = node<_Baz>((self) {});
      final machine = Machine<State, Event>(
        initialStateValue: const State.foo(),
        states: [fooNode, barNode, bazNode],
      );

      machine
        ..start()
        ..transition(const State.bar())
        ..stop()
        ..start()
        ..dispose();

      verifyInOrder([
        leavingFoo1(),
        leavingFoo2(),
        leavingBar1(),
        leavingFoo1(),
        leavingFoo2(),
      ]);
    });

    test('does not allow to execute helper functions in body', () {
      dynamic transitionErr;
      dynamic onEventErr;
      dynamic onExitErr;
      final fooNode = node<_Foo>((self) {
        self.onExit(() {
          try {
            self.transition(const State.bar());
          } catch (e) {
            transitionErr = e;
          }

          try {
            self.onEvent<_Next>((event) {});
          } catch (e) {
            onEventErr = e;
          }

          try {
            self.onExit(() {});
          } catch (e) {
            onExitErr = e;
          }
        });
      });
      final barNode = node<_Bar>((self) {});
      final bazNode = node<_Baz>((self) {});
      Machine<State, Event>(
        initialStateValue: const State.foo(),
        states: [fooNode, barNode, bazNode],
      )
        ..start()
        ..transition(const State.bar());

      expect(transitionErr, isStateError);
      expect(onEventErr, isStateError);
      expect(onExitErr, isStateError);
    });
  });

  test('transition', () {
    final fooNode = node<_Foo>((self) {});
    final barNode = node<_Bar>((self) {});
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );

    machine.transition(const State.bar());
    expect(
        machine.debugState,
        isA<MachineStatusRunning<State, Event>>()
            .having((s) => s.state, 'state', const State.bar()));

    machine.stop();
    machine.transition(const State.baz());
    expect(
        machine.debugState,
        isA<MachineStatusRunning<State, Event>>()
            .having((s) => s.state, 'state', const State.baz()));
  });

  test('transition on event', () {
    final fooNode = node<_Foo>((self) {
      self.onEvent<_Next>((event) {
        self.transition(const State.bar());
      });
    });
    final barNode = node<_Bar>((self) {});
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );

    machine.start();
    machine.send(const Event.next());
    expect(
        machine.debugState,
        isA<MachineStatusRunning<State, Event>>()
            .having((s) => s.state, 'state', const State.bar()));
  });

  test('transition immediately', () {
    final fooNode = node<_Foo>((self) {
      self.transition(const State.bar());
    });
    final barNode = node<_Bar>((self) {
      self.transition(const State.baz());
    });
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );

    machine.start();
    expect(
        machine.debugState,
        isA<MachineStatusRunning<State, Event>>()
            .having((s) => s.state, 'state', const State.baz()));
  });

  test('transition in async', () async {
    final c = Completer<void>();
    final fooNode = node<_Foo>((self) async {
      Future(() {
        self.transition(const State.bar());
        c.complete();
      });
    });
    final barNode = node<_Bar>((self) {});
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );

    machine.start();
    await c.future;
    expect(
        machine.debugState,
        isA<MachineStatusRunning<State, Event>>()
            .having((s) => s.state, 'state', const State.bar()));
  });

  test(
      'throw error on ActiveState helper functions, after leaving/disposing the state',
      () async {
    dynamic transitionErr;
    dynamic onEventErr;
    dynamic onExitErr;
    final fooNode = node<_Foo>((self) {
      self.transition(const State.bar());
      try {
        self.transition(const State.baz());
      } catch (e) {
        transitionErr = e;
      }

      try {
        self.onEvent<_Next>((event) {});
      } catch (e) {
        onEventErr = e;
      }

      try {
        self.onExit(() {});
      } catch (e) {
        onExitErr = e;
      }
    });
    final barNode = node<_Bar>((self) {});
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );

    machine.start();
    expect(transitionErr, isStateError);
    expect(onEventErr, isStateError);
    expect(onExitErr, isStateError);
  });

  test('register event on active state', () {
    final fooNext = MockEventListener<_Next>();
    final fooToBaz = MockEventListener<_ToBaz>();
    final fooNode = node<_Foo>((self) {
      self.onEvent<_Next>(fooNext);
      self.onEvent<_ToBaz>(fooToBaz);
    });
    final barNode = node<_Bar>((self) {});
    final bazNode = node<_Baz>((self) {});
    final machine = Machine<State, Event>(
      initialStateValue: const State.foo(),
      states: [fooNode, barNode, bazNode],
    );
    machine.start();

    machine.send(const Event.next());
    machine.send(const Event.toBaz());
    machine.send(const Event.next());

    expect(machine.canSend(const Event.next()), isTrue);
    expect(machine.canSend(const Event.toBaz()), isTrue);
    expect(machine.canSend(const Event.toBar()), isFalse);

    machine.transition(const State.bar());

    expect(machine.canSend(const Event.next()), isFalse);
    expect(machine.canSend(const Event.toBaz()), isFalse);
    expect(machine.canSend(const Event.toBar()), isFalse);

    machine.send(const Event.next());
    machine.send(const Event.next());

    verifyInOrder([
      fooNext(argThat(isA<_Next>())),
      fooToBaz(argThat(isA<_ToBaz>())),
      fooNext(argThat(isA<_Next>())),
    ]);
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
