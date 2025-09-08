import 'dart:async';
import 'dart:io';

import 'package:damagereports/data/model/response/kerusakan_response_model.dart';
import 'package:damagereports/data/repository/kerusakan_repository.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/home/teknisi_pic_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/kerusakan/lapor_perbaikan_screen.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class KerusakanDetailScreen extends StatefulWidget {
  final Kerusakan kerusakan;

  const KerusakanDetailScreen({super.key, required this.kerusakan});

  @override
  State<KerusakanDetailScreen> createState() => _KerusakanDetailScreenState();
}

class _KerusakanDetailScreenState extends State<KerusakanDetailScreen> {
  final GlobalKey _cardKey = GlobalKey();
  double _cardHeight = 160;
  Marker? _marker;
  late String currentStatus;
  final KerusakanRepository repository = KerusakanRepository(
    ServiceHttpClient(),
  );

  @override
  void initState() {
    super.initState();
    _marker = Marker(
      point: LatLng(
        widget.kerusakan.latPosisi,
        widget.kerusakan.lngPosisi,
      ),
      width: 40,
      height: 40,
      child: const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
    currentStatus = widget.kerusakan.status;
  }


  void _updateCardHeight() {
    final context = _cardKey.currentContext;
    if (context != null) {
      final newHeight = context.size?.height ?? 160;
      if (newHeight != _cardHeight) {
        setState(() {
          _cardHeight = newHeight;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = widget.kerusakan.latPosisi;
    final lng = widget.kerusakan.lngPosisi;

    return Scaffold(
      backgroundColor: const Color(0xFF7A8FB1),
      appBar: AppBar(
        title: const Text("Detail"),
        backgroundColor: Color(0xFF003D7A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.kerusakan.fotoKerusakan != null &&
                                widget.kerusakan.fotoKerusakan!.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.zero,
                                      child: GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: InteractiveViewer(
                                          child: Image.network(
                                            widget.kerusakan.fotoKerusakan!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.kerusakan.fotoKerusakan ?? "",
                              fit: BoxFit.cover,
                              height: 150,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: Colors.grey,
                                    child: const Icon(Icons.image),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                          Text(
                            "Foto Kerusakan",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            if (widget.kerusakan.fotoPerbaikan != null &&
                                widget.kerusakan.fotoPerbaikan!.isNotEmpty) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Foto perbaikan sudah diunggah. Tidak bisa mengambil ulang foto.',
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                              return;
                            }

                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              builder: (context) => Wrap(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.camera_alt),
                                    title: Text('Camera'),
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(source: ImageSource.camera);

                                      if (!mounted) return;

                                      if (pickedFile != null) {
                                        final file = File(pickedFile.path);
                                        Navigator.pop(context); 
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => LaporPerbaikanScreen(
                                              foto: file,
                                              kerusakanId: widget.kerusakan.idKerusakan,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text('Gallery'),
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                                      if (!mounted) return;

                                      if (pickedFile != null) {
                                        final file = File(pickedFile.path);
                                        Navigator.pop(context); 
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => LaporPerbaikanScreen(
                                              foto: file,
                                              kerusakanId: widget.kerusakan.idKerusakan,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 150,
                              width: 150,
                              color: Colors.grey[200],
                              child:
                                  widget.kerusakan.fotoPerbaikan != null &&
                                          widget
                                              .kerusakan
                                              .fotoPerbaikan!
                                              .isNotEmpty
                                      ? Image.network(
                                        widget.kerusakan.fotoPerbaikan!,
                                        fit: BoxFit.cover,
                                      )
                                      : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 32,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Add Photo",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Foto Perbaikan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.kerusakan.fasilitas} - ${widget.kerusakan.lokasi ?? '-'}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.kerusakan.tanggal ?? "-",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.kerusakan.user ?? '-'} - ${widget.kerusakan.role ?? '-'}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _warnaStatus(
                                  widget.kerusakan.status,
                                ).withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.kerusakan.status,
                                style: TextStyle(
                                  color: _warnaStatus(widget.kerusakan.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            children: [
                              FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(lat, lng),
                                  initialZoom: 16,
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.none, 
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}{r}.png",
                                    userAgentPackageName: 'yusvan.damagereports',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(lat, lng),
                                        width: 40,
                                        height: 40,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      await _bukaGoogleMaps(lat, lng); 
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Deskripsi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.kerusakan.deskripsi,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14, 
                      color: Colors.black87, 
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentStatus.toLowerCase() == 'pending') ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final result = await repository.updateStatus(
                        widget.kerusakan.idKerusakan,
                        "diperbaiki",
                      );
                      result.fold(
                        (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal update status: $error")),
                          );
                        },
                        (success) {
                          setState(() {
                            currentStatus = "diperbaiki";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(success)),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => TeknisiPicScreen()),
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Update Status",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      label: const Text("Batalkan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFD373D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<KerusakanBloc>().add(
                          HapusPesananEvent(widget.kerusakan.idKerusakan),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => TeknisiPicScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}

Color _warnaStatus(String status) {
  switch (status.toLowerCase()) {
    case "pending":
      return Colors.redAccent;
    case "diperbaiki":
      return Colors.blue;
    case "selesai":
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Future<void> _bukaGoogleMaps(double lat, double lng) async {
  final Uri url = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Tidak bisa membuka Google Maps';
  }
}
