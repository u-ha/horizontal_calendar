import 'package:flutter/material.dart';
import 'package:horizontal_calendar_view/horizontal_calendar_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime selectedDate = DateTime.now();
  final calendarController = HorizontalCalendarController();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizontal Calendar Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Horizontal Calendar'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            HorizontalCalendar(
              startDate: DateTime.now().subtract(Duration(days: 10)),
              endDate: DateTime.now().add(Duration(days: 10)),
              controller: calendarController,
              multiSelect: false,
              selectedDates: [DateTime.now()],
              // todayColor: Colors.green,
              selectedColor:Colors.brown,
              selectedDate: selectedDate,
              onMultiDateSelected: (dates) {
                print("Selected: $dates");
              },
              onDateSelected: (date){
                setState(() {
                  selectedDate = date;
                });
                print("Selected: $date");
              },
              unSelectedColor: Colors.brown.shade200,
              // baseTextColor: Colors.lightGreen,
              shapeType: CalendarShapeType.bear, // heart / oval / rectangle / bear
              shapeSize: Size(100, 100),
            ),
            const SizedBox(height: 24),
            Text(
              'Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => calendarController.scrollToToday(),
              child: Text("오늘로 이동"),
            ),
          ],
        ),
      ),
    );
  }
}
