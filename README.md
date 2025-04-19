# 📅 Horizontal Calendar View

A beautiful, horizontally scrollable calendar widget for Flutter.  
Perfect for scheduling apps, booking views, or modern UI designs.
Supports fun shape styles like oval, rectangle, heart, and even bear 🐻!

<img src="/Users/youha/project/horizontal_calendar_view/assets/brown_bear_shape.gif" width="300">

---

## ✨ Features

- Horizontal scrollable calendar
- Customizable day shapes (oval, rectangle, heart, bear)
- Single and multi-date selection
- Scroll to today
- Fully customizable UI

---

## 🚀 Getting Started

Add dependency in your `pubspec.yaml`:

```yaml
dependencies:
  horizontal_calendar: ^0.0.1
```
then run:   

```bash
flutter pub get
```

---

## 💻 Usage

for example : bear shape
```dart
import 'package:horizontal_calendar/horizontal_calendar.dart';

final calendarController = HorizontalCalendarController();

HorizontalCalendar(
  startDate: DateTime.now().subtract(Duration(days: 10)),
  endDate: DateTime.now().add(Duration(days: 10)),
  controller: calendarController,
  onDateSelected: (selectedDates) {
    print(selectedDates);
  },
  selectedColor:Colors.brown,
  shapeType: ShapeType.bear,
  selectedColor: Colors.blue,
  todayColor: Colors.red,
  unSelectedColor: Colors.brown.shade200,
  shapeType: CalendarShapeType.bear, 
  shapeSize: Size(100, 100),
);

ElevatedButton(
  onPressed: () => calendarController.scrollToToday(),
  child: Text("Scroll to Today"),
)
```

---

## 🧩 Shape Types
```dart
enum CalendarShapeType {
    oval,
    rectangle,
    heart,
    bear,
}
```
You can customize your date cell with different shape styles using the CalendarShapeType property.

---

## 📂 Example
Check the example directory for a complete usage demo.

---

## 📜 License
This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙌 Author
Created by uha

Feel free to contribute, open issues or submit PRs!

