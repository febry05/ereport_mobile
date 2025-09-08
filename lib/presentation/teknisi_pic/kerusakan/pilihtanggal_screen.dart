import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showCustomCupertinoDatePicker({
  required BuildContext context,
  required DateTime? currentDate,
}) async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day); 
  DateTime minDate = DateTime(2025, 1, 1); 
  DateTime tempDate = currentDate != null && currentDate.isBefore(today)
      ? currentDate
      : today;

  return await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (context) => Container(
      height: 350,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Tanggal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: tempDate,
              minimumDate: minDate,        
              maximumDate: today,          
              onDateTimeChanged: (DateTime newDate) {
                tempDate = newDate;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text('Reset'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text('Pilih'),
                onPressed: () {
                  Navigator.of(context).pop(tempDate);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
