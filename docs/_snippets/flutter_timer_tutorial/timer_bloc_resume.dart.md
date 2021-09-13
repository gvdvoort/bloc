```dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _duration = 60;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
     : _ticker = ticker,
     super(TimerInitial(_duration)) {
      on<TimerStarted>((event, emit) {
        _tickerSubscription?.cancel();
        _tickerSubsription = _ticker
          .tick(ticks: event.duration)
          .listen((duration) => add(TimerTicked(duration: duration)));
      });

      on<TimerTicked>((tick, emit) {
        emit(tick.duration > 0
        ? TimerRunInProgress(tick.duration)
        : TimerRunComplete());
      });

      on<TimerPaused>((paused, emit) {
        if (state is TimerRunInProgress) {
          _tickerSubscription?.pause();
          emit(TimerRunPause(state.duration));
        }
      });

      on<TimerResumed>((resumed, emit) {
        if (state is TimerRunPaused) {
          _tickerSubscription?.resume();
          emit(TimerRunInProgress(state.duration));
        }
      })
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
```
