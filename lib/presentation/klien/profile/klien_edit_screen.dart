import 'package:damagereports/data/model/request/user/user_request_model.dart';
import 'package:damagereports/data/model/response/user_response_model.dart';
import 'package:damagereports/presentation/klien/bloc/klien/klien_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KlienEditScreen extends StatefulWidget {
  final DataUser klien;

  const KlienEditScreen({super.key, required this.klien});

  @override
  State<KlienEditScreen> createState() => _KlienEditScreenState();
}

class _KlienEditScreenState extends State<KlienEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController namaController;
  late final TextEditingController nipController;
  late final TextEditingController notlpController;
  late final TextEditingController alamatController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.klien.name);
    nipController = TextEditingController(text: widget.klien.nip);
    notlpController = TextEditingController(text: widget.klien.notlp);
    alamatController = TextEditingController(text: widget.klien.alamat);
  }

  @override
  void dispose() {
    namaController.dispose();
    nipController.dispose();
    notlpController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Color.fromARGB(255, 13, 135, 166),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F1B2E),
              Color(0xFF2C3E5F), 
              Color(0xFF7A8FB1), 
            ],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<KlienBloc, KlienState>(
            listener: (context, state) {
              if (state is KlienUpdateSuccess) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                Navigator.pop(context, true);
              } else if (state is KlienFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Text("Nama", style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: namaController,
                        decoration: InputDecoration(
                          hintText: "Nama klien",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Color.fromARGB(255, 13, 135, 166), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text("NIP", style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nipController,
                        decoration: InputDecoration(
                          hintText: "NIP",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Color.fromARGB(255, 13, 135, 166), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIP wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text("Nomor Telepon", style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: notlpController,
                        decoration: InputDecoration(
                          hintText: "No. Telepon",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Color.fromARGB(255, 13, 135, 166), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor Telepon wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text("Alamat", style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: alamatController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Alamat",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color:Color(0xFF002C5A), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: state is KlienLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final requestModel = UserRequestModel(
                                    nama: namaController.text,
                                    nip: nipController.text,
                                    notlp: notlpController.text,
                                    alamat: alamatController.text,
                                  );
                                  context.read<KlienBloc>().add(
                                        UpdateKlienRequested(
                                            requestModel: requestModel),
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 13, 135, 166),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: state is KlienLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Simpan",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
