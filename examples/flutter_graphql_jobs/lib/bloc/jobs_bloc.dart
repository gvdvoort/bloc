import 'package:bloc/bloc.dart';
import 'package:flutter_graphql_jobs/api/api.dart';
import 'package:flutter_graphql_jobs/api/job_api_client.dart';
import 'package:meta/meta.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  JobsBloc({@required JobsApiClient jobsApiClient})
      : assert(jobsApiClient != null),
        _jobsApiClient = jobsApiClient,
        super(JobsLoadInProgress()) {
    on<JobsFetchStarted>(_onJobsFetchStarted);
  }

  final JobsApiClient _jobsApiClient;

  void _onJobsFetchStarted(JobsFetchStarted event, Emit<JobsState> emit) async {
    emit(JobsLoadInProgress());
    try {
      final jobs = await _jobsApiClient.getJobs();
      emit(JobsLoadSuccess(jobs));
    } on Exception catch (_) {
      emit(JobsLoadFailure());
    }
  }
}
