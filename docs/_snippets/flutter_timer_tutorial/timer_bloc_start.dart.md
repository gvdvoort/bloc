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
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
```
