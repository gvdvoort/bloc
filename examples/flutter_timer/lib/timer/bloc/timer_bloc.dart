import 'dart:async';
import 'package:flutter_timer/ticker.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

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
      emit(TimerRunInProgress(event.duration));
      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker
          .tick(ticks: event.duration)
          .listen((duration) => add(TimerTicked(duration: duration)));
    });

    on<TimerPaused>((paused, emit) {
      if (state is TimerRunInProgress) {
        _tickerSubscription?.pause();
        emit(TimerRunPause(state.duration));
      }
    });

    on<TimerTicked>((tick, emit) {
      emit(tick.duration > 0
          ? TimerRunInProgress(tick.duration)
          : TimerRunComplete());
    });

    on<TimerReset>((reset, emit) {
      _tickerSubscription?.cancel();
      emit(TimerInitial(_duration));
    });

    on<TimerResumed>((resumed, emit) {
      if (state is TimerRunPause) {
        _tickerSubscription?.resume();
        emit(TimerRunInProgress(state.duration));
      }
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
