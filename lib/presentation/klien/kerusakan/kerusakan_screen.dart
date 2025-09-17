import 'package:damagereports/data/model/response/kerusakan_response_model.dart';
import 'package:damagereports/presentation/klien/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/home/header_landing.dart';
import 'package:damagereports/presentation/teknisi_pic/kerusakan/date_range.dart';
import 'package:damagereports/presentation/klien/kerusakan/detail_kerusakan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KerusakanScreen extends StatefulWidget {
  const KerusakanScreen({super.key});

  @override
  State<KerusakanScreen> createState() => _KerusakanScreenState();
}

class _KerusakanScreenState extends State<KerusakanScreen> with RouteAware {
  String selectedStatus = 'Pending';
  DateTimeRange? selectedDateRange;
  final dateFormat = DateFormat('dd-MM-yyyy');

  int currentPage = 1;
  int itemsPerPage = 5;

  String formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) return '-';
    try {
      final dt = DateTime.parse(tanggal);
      return dateFormat.format(dt); 
    } catch (e) {
      return tanggal;
    }
  }

  final List<String> statusOptions = ['Semua', 'Pending', 'Diperbaiki', 'Selesai'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<KerusakanKlienBloc>().add(
      KerusakanRequested(
        status: selectedStatus.toLowerCase() == 'semua'
            ? null
            : selectedStatus.toLowerCase(),
      ),
    );
  }

  void _pickDateRange() async {
    final range = await showCustomCupertinoDateRangePicker(
      context: context,
      currentRange: selectedDateRange,
    );

    setState(() {
      selectedDateRange = range; 
    });

    context.read<KerusakanKlienBloc>().add(KerusakanRequested(
      status: selectedStatus.toLowerCase() == 'semua' ? null : selectedStatus.toLowerCase(),
      startDate: range?.start,
      endDate: range?.end,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7A8FB1),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderLanding(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // --- Status Filter ---
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Color(0xFF003D7A), width: 1),
                            ),
                            child: Row(
                              children: statusOptions.asMap().entries.map((entry) {
                                final index = entry.key;
                                final status = entry.value;
                                final isSelected = selectedStatus == status;
                                return Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => selectedStatus = status);
                                      context.read<KerusakanKlienBloc>().add(
                                        KerusakanRequested(
                                          status: status.toLowerCase() == 'semua' ? null : status.toLowerCase(),
                                          startDate: selectedDateRange?.start,
                                          endDate: selectedDateRange?.end,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ?  Color(0xFF003D7A) : Colors.transparent,
                                        borderRadius: BorderRadius.only(
                                          topLeft: index == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          bottomLeft: index == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          topRight: index == statusOptions.length - 1
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          bottomRight: index == statusOptions.length - 1
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<KerusakanKlienBloc, KerusakanState>(
                        builder: (context, state) {
                          if (state is KerusakanLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: Color(0xFF00A8B5)),
                            );
                          } else if (state is KerusakanFailure) {
                            return Center(child: Text('Gagal memuat data: ${state.error}'));
                          } else if (state is KerusakanLoaded) {
                            final kerusakanList = state.listKerusakan;

                            List<Kerusakan> filteredList = kerusakanList;
                            if (selectedDateRange == null) {
                              final now = DateTime.now();
                              final weekAgo = now.subtract(const Duration(days: 7));

                              filteredList = kerusakanList.where((k) {
                                if (k.tanggal == null || k.tanggal!.isEmpty) return false;
                                try {
                                  final tgl = DateTime.parse(k.tanggal!);
                                  return tgl.isAfter(weekAgo) || tgl.isAtSameMomentAs(weekAgo);
                                } catch (e) {
                                  return false;
                                }
                              }).toList();
                            }

                            final totalPages = (filteredList.length / itemsPerPage).ceil().clamp(1, double.infinity).toInt();
                            currentPage = currentPage.clamp(1, totalPages);

                            final startIndex = ((currentPage - 1) * itemsPerPage).clamp(0, filteredList.length);
                            final endIndex = (startIndex + itemsPerPage).clamp(0, filteredList.length);
                            final pagedList = filteredList.sublist(startIndex, endIndex);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Jumlah: ${filteredList.length}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: _pickDateRange,
                                      child: Container(
                                        width: 180,
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF003D7A),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFF003D7A)),
                                        ),
                                        child: Text(
                                          selectedDateRange != null
                                              ? "${dateFormat.format(selectedDateRange!.start)} s/d ${dateFormat.format(selectedDateRange!.end)}"
                                              : "Pilih Tanggal",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: filteredList.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Tidak ada kerusakan dalam seminggu',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : ListView.separated(
                                          itemCount: pagedList.length,
                                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                                          itemBuilder: (context, index) {
                                            final kerusakan = pagedList[index];
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => KerusakanDetailScreen(
                                                      kerusakan: kerusakan,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Positioned(
                                                    bottom: 1, 
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(255, 13, 135, 166),
                                                        borderRadius: BorderRadius.circular(14),
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment.bottomCenter,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(bottom: 4),
                                                          child: Row(
                                                            children: [
                                                              const SizedBox(width: 16),
                                                              Text(
                                                                kerusakan.status,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: kerusakan.status.toLowerCase() == 'pending'
                                                                      ? const Color.fromARGB(255, 247, 165, 165)
                                                                      : kerusakan.status.toLowerCase() == 'diperbaiki'
                                                                          ? const Color.fromARGB(255, 123, 209, 249)
                                                                          : const Color.fromARGB(255, 114, 245, 118),
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              const Icon(
                                                                Icons.arrow_forward,
                                                                size: 24,
                                                                color: Colors.white,
                                                              ),
                                                              const SizedBox(width: 16),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(bottom: 30),
                                                    padding: const EdgeInsets.all(3),
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(14),
                                                        topRight: Radius.circular(14),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(width: 12),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 7),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  kerusakan.fasilitas,
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 2),
                                                                Text(
                                                                  kerusakan.lokasi ?? '-',
                                                                  style: const TextStyle(fontSize: 12),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              const SizedBox(height: 20),
                                                              Text(
                                                                formatTanggal(kerusakan.tanggal),
                                                                style: const TextStyle(fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                ),
                                const SizedBox(height: 10),
                                if (totalPages > 1)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: currentPage > 1
                                            ? () => setState(() => currentPage--)
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white, 
                                          foregroundColor: const Color(0xFF003D7A), 
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: const Text("Prev"),
                                      ),
                                      const SizedBox(width: 70),
                                      Text("$currentPage / $totalPages",
                                          style: const TextStyle(color: Colors.white)),
                                      const SizedBox(width: 70),
                                      ElevatedButton(
                                        onPressed: currentPage < totalPages
                                            ? () => setState(() => currentPage++)
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white, 
                                          foregroundColor: const Color(0xFF003D7A), 
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: const Text("Next"),
                                      )
                                    ],
                                  ),
                                const SizedBox(height: 30),
                              ],
                            );
                          }
                          return const Center(
                            child: Text(
                              "Halaman Kerusakan",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
