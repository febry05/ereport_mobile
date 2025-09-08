import 'dart:io';
import 'package:damagereports/presentation/teknisi_pic/home/teknisi_pic_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/kerusakan/pilihtanggal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:intl/intl.dart';

class LaporPerbaikanScreen extends StatefulWidget {
  final File foto;
  final int kerusakanId;

  const LaporPerbaikanScreen({super.key, required this.foto, required this.kerusakanId});

  @override
  State<LaporPerbaikanScreen> createState() => _LaporPerbaikanScreenState();
}

class _LaporPerbaikanScreenState extends State<LaporPerbaikanScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  final deskripsiPerbaikanController = TextEditingController();
  bool _hasPopped = false;

  Future<void> _pickDate() async {
    final DateTime? picked = await showCustomCupertinoDatePicker(
      context: context,
      currentDate: selectedDate,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.foto.path.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto perbaikan wajib dipilih!")),
        );
        return;
      }
      final tanggalPerbaikan = selectedDate.toIso8601String().split('T').first;
      context.read<KerusakanBloc>().add(
        PerbaikanCreateRequested(
          kerusakanId: widget.kerusakanId,
          deskripsiPerbaikan: deskripsiPerbaikanController.text,
          tanggalPerbaikan: tanggalPerbaikan,
          fotoPerbaikanPath: widget.foto.path,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7A8FB1),
      appBar: AppBar(
        title: const Text("Lapor Perbaikan"),
        backgroundColor: Color(0xFF002C5A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<KerusakanBloc, KerusakanState>(
        listener: (context, state) {
          if (state is KerusakanOperationSuccess && !_hasPopped) {
            _hasPopped = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
             Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => TeknisiPicScreen()),
            );
          } else if (state is KerusakanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Gagal: ${state.error}")),
            );
          }
        },
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
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Tanggal Perbaikan",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xFF002C5A),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('d MMMM y').format(selectedDate), 
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                 const SizedBox(height: 10),
                const Text("Deskripsi Perbaikan", style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: deskripsiPerbaikanController,
                    decoration: InputDecoration(
                      hintText: "Deskripsi Perbaikan",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                            color: Color(0xFF002C5A), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                            color: Color(0xFF002C5A), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fasilitas wajib diisi';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 30),
                BlocBuilder<KerusakanBloc, KerusakanState>(
                  builder: (context, state) {
                    if (state is KerusakanLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFF002C5A)),
                      );
                    }
                    return SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF002C5A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15,),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          "Kirim",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
