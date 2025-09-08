import 'package:damagereports/data/model/request/auth/login_request_model.dart';
import 'package:damagereports/presentation/auth/bloc/login_bloc.dart';
import 'package:damagereports/presentation/klien/home/klien_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/home/teknisi_pic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginButtonFunction extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButtonFunction({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is LoginSuccess) {
          final userData = state.responseModel.user;
          final role = userData?.role ?? '-';
          final name = userData?.name ?? '-';
          final userId = userData?.id;
          final akses = userData?.akses ?? <String>[];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', name);
          await prefs.setString('role', role);
          await prefs.setStringList('akses', akses);

          if (userId != null) {
            await prefs.setInt('userId', userId);
          }

          if (!context.mounted) return;

          if (role == 'Teknisi' || role == 'Pic') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => TeknisiPicScreen()),
              (route) => false,
            );
          } else if (role == 'Klien') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => KlienScreen()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Akun tidak dikenali')),
            );
          }
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is LoginLoading
                ? null
                : () {
                    if (formKey.currentState!.validate()) {
                      final request = LoginRequestModel(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      context.read<LoginBloc>().add(
                            LoginRequested(requestModel: request),
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF003D7A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              state is LoginLoading ? 'Memuat...' : 'Masuk',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
