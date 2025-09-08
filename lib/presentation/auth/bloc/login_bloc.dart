import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/auth/login_request_model.dart';
import 'package:damagereports/data/model/response/auth_response_model.dart';
import 'package:damagereports/data/repository/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<AmbilNamaPenggunaRequested>(_onAmbilNamaPengguna);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await authRepository.login(event.requestModel);

    result.fold(
      (l) => emit(LoginFailure(error: l)),
      (r) => emit(LoginSuccess(responseModel: r)),
    );
  }

  Future<void> _onAmbilNamaPengguna(
    AmbilNamaPenggunaRequested event,
    Emitter<LoginState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final nama = prefs.getString('name') ?? '';
    emit(NamaUserBerhasilDiambil(nama: nama));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    emit(LogoutSuccess());
  }
} 

