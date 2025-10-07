import 'dart:io';
import 'package:damagereports/presentation/teknisi_pic/kerusakan/kerusakan_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/kerusakan/laporan_kerusakan_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/profile/teknisi_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TeknisiPicScreen extends StatefulWidget {
  const TeknisiPicScreen({super.key});

  @override
  State<TeknisiPicScreen> createState() => _TeknisiPicScreenState();
}

class _TeknisiPicScreenState extends State<TeknisiPicScreen> {
  int pilihIndex = 0;

  void pilihHalaman(int index) async {
    if (index == 1) {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Izin kamera ditolak, tidak bisa mengambil foto')),
          );
          return; 
        }
      }

      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          final file = File(pickedFile.path);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LaporKerusakanScreen(foto: file),
            ),
          );
        } else {
          print('Pengguna batal mengambil foto.');
        }
      } catch (e) {
        print('Terjadi kesalahan saat mengambil foto: $e');
      }
    } else {
      setState(() {
        pilihIndex = index;
      });
    }
  }

  Widget halamanContent() {
    switch (pilihIndex) {
      case 0:
        return KerusakanScreen();
      case 2:
        return TeknisiProfileScreen();
      default:
        return Text('Halaman Kosong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: halamanContent(),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: BottomNavigationBar(
          currentIndex: pilihIndex,
          onTap: pilihHalaman,
          selectedItemColor: Color(0xFF00A8B5),
          unselectedItemColor: Color(0xFF7A8FB1), 
          backgroundColor:  Color(0xFF002C5A),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), 
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () => pilihHalaman(1),
        child: Container(
          padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container (
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
            color: Color(0xFFC1272D),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.camera, size: 35, color: Colors.white),
          )
        ),
      ),
    );
  }
}
