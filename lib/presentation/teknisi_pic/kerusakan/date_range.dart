import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTimeRange?> showCustomCupertinoDateRangePicker({
  required BuildContext context,
  required DateTimeRange? currentRange,
}) async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime minDate = DateTime(2025, 1, 1);

  DateTime startDate = currentRange?.start ?? today;
  DateTime endDate = currentRange?.end ?? today;

  bool isSelectingStart = true; 

  return await showCupertinoModalPopup<DateTimeRange>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: 400,
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
                    Text(
                      isSelectingStart ? 'Pilih Tanggal Mulai' : 'Pilih Tanggal Akhir',
                      style: const TextStyle(
                        fontSize: 14,
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
                  initialDateTime: isSelectingStart ? startDate : endDate,
                  minimumDate: minDate,
                  maximumDate: today,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      if (isSelectingStart) {
                        startDate = newDate;
                      } else {
                        endDate = newDate;
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Rentang: ${startDate.toString().split(' ')[0]} - ${endDate.toString().split(' ')[0]}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54, decoration: TextDecoration.none,),
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
                      backgroundColor: isSelectingStart ? Colors.blue : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Text(isSelectingStart ? 'Next (Akhir)' : 'Pilih'),
                    onPressed: () {
                      if (isSelectingStart) {
                        setState(() {
                          isSelectingStart = false;
                        });
                      } else {
                        if (endDate.isBefore(startDate)) {
                          final temp = startDate;
                          startDate = endDate;
                          endDate = temp;
                        }
                        Navigator.of(context).pop(DateTimeRange(start: startDate, end: endDate));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
