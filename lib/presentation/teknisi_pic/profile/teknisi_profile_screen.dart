import 'package:damagereports/data/model/response/user_response_model.dart';
import 'package:damagereports/presentation/auth/bloc/login_bloc.dart';
import 'package:damagereports/presentation/auth/login_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/teknisi_pic/teknisi_pic_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/profile/teknisi_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeknisiProfileScreen extends StatefulWidget {
  const TeknisiProfileScreen({super.key});

  @override
  State<TeknisiProfileScreen> createState() => _TeknisiProfileScreenState();
}

class _TeknisiProfileScreenState extends State<TeknisiProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeknisiPicBloc>().add(GetTeknisiPicProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF1F1B2E),
                Color(0xFF2C3E5F), 
                Color(0xFF7A8FB1), 
              ],
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<TeknisiPicBloc, TeknisiPicState>(
              builder: (context, state) {
                if (state is TeknisiPicLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00A8B5),),
                  );
                } else if (state is TeknisiPicFailure) {
                  return Center(child: Text("Gagal memuat data: ${state.error}"));
                } else if (state is TeknisiPicLoaded) {
                  final DataUser teknisi = state.teknisiPic;

                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<LoginBloc>().add(LogoutRequested());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 13, 135, 166),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text('Logout'),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Data Diri",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      dataProfile(Icons.person, "Nama", teknisi.name),
                      dataProfile(Icons.key_outlined, "NIP", teknisi.nip),
                      dataProfile(Icons.email, "Email", teknisi.email),
                      dataProfile(Icons.phone, "Nomor Telepon", teknisi.notlp),
                      dataProfile(Icons.location_on, "Alamat", teknisi.alamat),
                    ],
                  );
                } else {
                  return const Center(child: Text("Belum ada data Teknisi"));
                }
              },
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: FloatingActionButton(
            onPressed: () async {
              final state = context.read<TeknisiPicBloc>().state;
              if (state is TeknisiPicLoaded) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeknisiEditScreen(teknisi: state.teknisiPic),
                  ),
                );
                if (result == true) {
                  context.read<TeknisiPicBloc>().add(GetTeknisiPicProfileRequested());
                }
              }
            },
            backgroundColor: Color(0xFF002C5A),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget dataProfile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF00A8B5),
            blurRadius: 4,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF002C5A)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 13, 135, 166),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
