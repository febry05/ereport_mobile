import 'dart:io';
import 'package:damagereports/data/model/request/kerusakan/kerusakan_request_model.dart';
import 'package:damagereports/presentation/klien/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/klien/home/klien_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class LaporKerusakanScreen extends StatefulWidget {
  final File foto;

  const LaporKerusakanScreen({super.key, required this.foto});

  @override
  State<LaporKerusakanScreen> createState() => _LaporKerusakanScreenState();
}

class _LaporKerusakanScreenState extends State<LaporKerusakanScreen> {
  final _formKey = GlobalKey<FormState>();
  final fasilitasController = TextEditingController();
  final deskripsiController = TextEditingController();

  double? latKerusakan;
  double? lngKerusakan;
  int? userId;
  int? selectedLokasiId;

  bool isSubmitting = false; 

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _loadUserIdDanLoadLokasi();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Izin lokasi ditolak. Tidak bisa mengambil posisi.")),
      );
    }
  }

  Future<void> _loadUserIdDanLoadLokasi() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');
    if (storedUserId != null) {
      setState(() => userId = storedUserId);
      context
          .read<KerusakanKlienBloc>()
          .add(LoadLokasiByUserId(userId: storedUserId));
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void _submit() async {
    if (isSubmitting) return; 
    setState(() => isSubmitting = true);

    final position = await _getCurrentLocation();

    if (!mounted) return;

    if (position != null) {
      latKerusakan = position.latitude;
      lngKerusakan = position.longitude;
    }

    if (_formKey.currentState!.validate() &&
        latKerusakan != null &&
        lngKerusakan != null &&
        userId != null &&
        selectedLokasiId != null) {
      final requestModel = KerusakanRequestModel(
        userId: userId,
        lokasiId: selectedLokasiId!,
        fasilitas: fasilitasController.text,
        tanggal: DateTime.now().toIso8601String().split('T').first,
        latPosisi: latKerusakan!,
        lngPosisi: lngKerusakan!,
        deskripsi: deskripsiController.text,
        fotoKerusakan: widget.foto.path,
        status: 'pending',
      );

      context
          .read<KerusakanKlienBloc>()
          .add(KerusakanCreateRequested(requestModel: requestModel));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data terlebih dahulu")),
      );
      setState(() => isSubmitting = false); 
    }
  }

  @override
  void dispose() {
    fasilitasController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lapor Kerusakan"),
        backgroundColor: const Color(0xFF003D7A),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      widget.foto,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Lokasi", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  BlocBuilder<KerusakanKlienBloc, KerusakanState>(
                    builder: (context, state) {
                      if (state is KerusakanLoading) {
                        return const Center(
                          child:
                              CircularProgressIndicator(color: Color(0xFF00A8B5)),
                        );
                      } else if (state is LokasiLoadedState) {
                        final lokasiList = state.lokasiList;
                        return DropdownButtonFormField<int>(
                          value: selectedLokasiId,
                          decoration: InputDecoration(
                            hintText: "Pilih Lokasi",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  const BorderSide(color: Color(0xFF003D7A), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  const BorderSide(color: Color(0xFF003D7A), width: 5),
                            ),
                          ),
                          items: lokasiList.isNotEmpty
                              ? lokasiList
                                  .map(
                                    (lokasi) => DropdownMenuItem<int>(
                                      value: lokasi.idLokasi,
                                      child: Text(lokasi.namaLokasi),
                                    ),
                                  )
                                  .toList()
                              : const [
                                  DropdownMenuItem<int>(
                                    value: null,
                                    child: Text("Tidak ada lokasi"),
                                  )
                                ],
                          onChanged: (value) {
                            setState(() {
                              selectedLokasiId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Lokasi wajib dipilih' : null,
                        );
                      } else if (state is KerusakanFailure) {
                        return Text("Gagal load lokasi: ${state.error}");
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Fasilitas", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: fasilitasController,
                    decoration: InputDecoration(
                      hintText: "Fasilitas",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide:
                            const BorderSide(color: Color(0xFF003D7A), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide:
                            const BorderSide(color: Color(0xFF003D7A), width: 5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fasilitas wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Deskripsi", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: deskripsiController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Deskripsi Kerusakan",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Color(0xFF003D7A), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Color(0xFF003D7A), width: 5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocListener<KerusakanKlienBloc, KerusakanState>(
                    listener: (context, state) {
                      if (state is KerusakanOperationSuccess) {
                        setState(() => isSubmitting = false); 
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KlienScreen(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Laporan berhasil dikirim')),
                        );
                      } else if (state is KerusakanFailure) {
                        setState(() => isSubmitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    },
                    child: BlocBuilder<KerusakanKlienBloc, KerusakanState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: (state is KerusakanLoading || isSubmitting)
                              ? null
                              : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003D7A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: (state is KerusakanLoading || isSubmitting)
                              ? const CircularProgressIndicator(color: Color(0xFF00A8B5))
                              : const Text(
                                  "Kirim Laporan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
