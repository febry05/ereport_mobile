import 'package:flutter/material.dart';

class HeaderLanding extends StatelessWidget {
  const HeaderLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      height: 130,
      decoration: const BoxDecoration(
      color: Color(0xFF003D7A), 
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/aps.png', height: 60),
              const SizedBox(width: 15),
              Text(
                'Laporan Kerusakan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white, 
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}