import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/user/user_request_model.dart';
import 'package:damagereports/data/model/response/user_response_model.dart';
import 'package:damagereports/data/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'teknisi_pic_event.dart';
part 'teknisi_pic_state.dart';

class TeknisiPicBloc extends Bloc<TeknisiPicEvent, TeknisiPicState> {
 final UserRepository teknisiPicRepository;

  TeknisiPicBloc({required this.teknisiPicRepository}) : super(TeknisiPicInitial()) {
    on<GetTeknisiPicProfileRequested>(_onTeknisiPicProfileRequested);
    on<UpdateTeknisiPicRequested>(_onTeknisiPicUpdateRequested);
  }

  Future<void> _onTeknisiPicProfileRequested(
    GetTeknisiPicProfileRequested event,
    Emitter<TeknisiPicState> emit,
  ) async {
    emit(TeknisiPicLoading());

    final Either<String, DataUser> result = await teknisiPicRepository.getProfile();

    result.fold(
      (error) => emit(TeknisiPicFailure(error: error)),
      (data) => emit(TeknisiPicLoaded(teknisiPic: data)),
    );
  }

  Future<void> _onTeknisiPicUpdateRequested(
    UpdateTeknisiPicRequested event,
    Emitter<TeknisiPicState> emit,
  ) async {
    emit(TeknisiPicLoading());

    final Either<String, String> result =
        await teknisiPicRepository.updateProfile(event.requestModel);

    result.fold(
      (error) => emit(TeknisiPicFailure(error: error)),
      (message) => emit(TeknisiPicUpdateSuccess(message: message)),
    );
  }
}
