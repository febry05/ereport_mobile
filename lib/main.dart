import 'package:damagereports/data/repository/kerusakan_repository.dart';
import 'package:damagereports/data/repository/login_repository.dart';
import 'package:damagereports/data/repository/user_repository.dart';
import 'package:damagereports/presentation/auth/bloc/login_bloc.dart';
import 'package:damagereports/presentation/auth/login_screen.dart';
import 'package:damagereports/presentation/klien/bloc/klien/klien_bloc.dart';
import 'package:damagereports/presentation/klien/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/teknisi_pic/teknisi_pic_bloc.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              LoginBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) =>
              KlienBloc(klienRepository: UserRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) =>
              KerusakanBloc(kerusakanRepository: KerusakanRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) =>
              TeknisiPicBloc(teknisiPicRepository: UserRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) =>
              KerusakanKlienBloc(kerusakanKlienRepository: KerusakanRepository(ServiceHttpClient())),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
