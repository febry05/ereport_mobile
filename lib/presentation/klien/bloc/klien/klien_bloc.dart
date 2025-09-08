import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/user/user_request_model.dart';
import 'package:damagereports/data/model/response/user_response_model.dart';
import 'package:damagereports/data/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'klien_event.dart';
part 'klien_state.dart';

class KlienBloc extends Bloc<KlienEvent, KlienState> {
 final UserRepository klienRepository;

  KlienBloc({required this.klienRepository}) : super(KlienInitial()) {
    on<GetKlienProfileRequested>(_onKlienProfileRequested);
    on<UpdateKlienRequested>(_onKlienUpdateRequested);
  }

  Future<void> _onKlienProfileRequested(
    GetKlienProfileRequested event,
    Emitter<KlienState> emit,
  ) async {
    emit(KlienLoading());

    final Either<String, DataUser> result = await klienRepository.getProfile();

    result.fold(
      (error) => emit(KlienFailure(error: error)),
      (data) => emit(KlienLoaded(klien: data)),
    );
  }

  Future<void> _onKlienUpdateRequested(
    UpdateKlienRequested event,
    Emitter<KlienState> emit,
  ) async {
    emit(KlienLoading());

    final Either<String, String> result =
        await klienRepository.updateProfile(event.requestModel);

    result.fold(
      (error) => emit(KlienFailure(error: error)),
      (message) => emit(KlienUpdateSuccess(message: message)),
    );
  }
}
