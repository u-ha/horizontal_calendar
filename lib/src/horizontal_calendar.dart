import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// --- 모양 타입 정의 ---
enum CalendarShapeType { oval, rectangle, heart , bear}

class HorizontalCalendarController {
  void Function()? _scrollToToday;

  void scrollToToday() {
    _scrollToToday?.call();
  }

// 다른 기능도 추후 추가 가능 (예: scrollToDate, selectDate 등)
}

class HorizontalCalendar extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? selectedDate;
  final List<DateTime>? selectedDates;
  final bool multiSelect;
  final Function(DateTime)? onDateSelected;
  final Function(List<DateTime>)? onMultiDateSelected;
  final CalendarShapeType shapeType;
  final Color selectedColor;
  final Color unSelectedColor;
  final Color baseTextColor;
  final Color todayColor;
  final Size shapeSize;
  final HorizontalCalendarController? controller;

  HorizontalCalendar({
    super.key,
    required this.startDate,
    required this.endDate,
    this.selectedDate,
    this.selectedDates,
    this.multiSelect = false,
    this.onDateSelected,
    this.onMultiDateSelected,
    this.selectedColor = Colors.blueAccent, // 기본값
    this.unSelectedColor = const Color(0xFFEEEEEE), // 기본값
    this.baseTextColor = Colors.black, // 기본값
    this.todayColor = Colors.blueAccent,  // 기본값
    this.shapeType = CalendarShapeType.oval,
    this.controller,
    Size? shapeSize ,
  }) :  shapeSize = shapeSize == null ? const Size(80, 80) : clampSize(shapeSize);

  static Size clampSize(Size input) {
    double minSize = 80;
    double maxSize = 150;

    double width = input.width.clamp(minSize, maxSize);
    double height = input.height.clamp(minSize, maxSize);

    return Size(width, height);
  }

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late List<DateTime> _selectedDates;
  final ScrollController _scrollController = ScrollController();
  late final dateList ;

  @override
  void initState() {
    super.initState();
    final days = widget.endDate.difference(widget.startDate).inDays + 1;
    dateList = List.generate(
      days,
          (index) => widget.startDate.add(Duration(days: index)),
    );
    widget.controller?._scrollToToday = _scrollToToday;
    _selectedDates = widget.selectedDates ?? [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    // final context = key.currentContext;
    // if (context != null) {
    //   final box = context.findRenderObject() as RenderBox;
    //   final position = box.localToGlobal(Offset.zero);
    //   final scrollOffset = position.dy + _scrollController.offset;
    //
    //   _scrollController.animateTo(
    //     scrollOffset,
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    // }

    final today = DateTime.now();
    final index = _getDateIndex(today);

    int monthHeaderCount = 0;
    if (index != -1) {
      for (int i = 1; i <= index; i++) {
        final prev = dateList[i - 1];
        final curr = dateList[i];
        if (prev.month != curr.month) {
          monthHeaderCount++;
        }
      }
      print(monthHeaderCount);
      final double monthHeaderWidth = 48.0;  // 월 헤더의 너비 (예시 값)
      final double itemWidth = widget.shapeSize.width;  // 날짜 셀의 너비

      // 오프셋 계산: 날짜 아이템 너비 + 월 헤더 넓이 + 패딩 고려
      final double offset = (index!=0? widget.shapeSize.width/2 : 0) + index * itemWidth + (monthHeaderCount + 1) * monthHeaderWidth ;
      print(index);
      print(itemWidth);
      print(offset);

      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


  int _getDateIndex(DateTime date) {
    final start = DateUtils.dateOnly(widget.startDate);
    final target = DateUtils.dateOnly(date);
    return target.difference(start).inDays;
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (widget.multiSelect) {
        if (_selectedDates.any((d) => _isSameDate(d, date))) {
          _selectedDates.removeWhere((d) => _isSameDate(d, date));
        } else {
          _selectedDates.add(date);
        }
        widget.onMultiDateSelected?.call(_selectedDates);
      } else {
        widget.onDateSelected?.call(date);
      }
    });
  }



  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.shapeSize.height,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          final date = dateList[index];
          final isSelected = widget.multiSelect
              ? _selectedDates.any((d) => _isSameDate(d, date))
              : (widget.selectedDate != null &&
              _isSameDate(widget.selectedDate!, date));
          final isToday = _isSameDate(date, DateTime.now());
          final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
          final isFirstOfMonth = index == 0 || date.month != dateList[index - 1].month;

          return Row(
            children: [
              if (isFirstOfMonth)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    '${date.month}월',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              GestureDetector(
                onTap: () => _onDateTap(date),
                child: Container(
                  width: widget.shapeSize.width,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: _buildShape(
                    isSelected: isSelected,
                    isToday: isToday,
                    isWeekend: isWeekend,
                    date: date,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShape({
    required bool isSelected,
    required bool isToday,
    required bool isWeekend,
    required DateTime date,
  }) {

    final size = widget.shapeSize;
    final bgColor = isSelected ? widget.selectedColor : widget.unSelectedColor;
    final borderColor = isToday ? widget.todayColor : Colors.transparent;

    // 하트인 경우 따로 처리
    if (widget.shapeType == CalendarShapeType.heart) {
      return CustomPaint(
        painter: HeartShapePainter(bgColor,borderColor),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(child: _buildDateText(isSelected, isWeekend, date)),
        ),
      );
    }

    // 곰 모양일 경우
    if (widget.shapeType == CalendarShapeType.bear) {
      return CustomPaint(
        painter: BearShapePainter(bgColor, borderColor),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(child: _buildDateText(isSelected, isWeekend, date)),
        ),
      );
    }

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: _getBorderRadius(widget.shapeType),
        border: Border.all(color: borderColor, width: isToday ? 2 : 0),
      ),
      alignment: Alignment.center,
      child: _buildDateText(isSelected, isWeekend, date),
    );
  }


  Widget _buildDateText(bool isSelected, bool isWeekend, DateTime date) {
    Color dayColor = isSelected ? Colors.white : widget.baseTextColor;
    if (!isSelected) {
      if (date.weekday == DateTime.saturday) {
        dayColor = Colors.blue;
      } else if (date.weekday == DateTime.sunday) {
        dayColor = Colors.red;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(DateFormat.E().format(date), style: TextStyle(color: dayColor, fontSize: 12)),
        const SizedBox(height: 4),
        Text('${date.day}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: dayColor)),
      ],
    );
  }

  BorderRadius _getBorderRadius(CalendarShapeType shape) {
    switch (shape) {
      case CalendarShapeType.rectangle:
        return BorderRadius.circular(10);
      case CalendarShapeType.oval:
        return BorderRadius.circular(80);
      case CalendarShapeType.heart:
        return BorderRadius.zero; // 하트는 직접 그리므로 무시
      case CalendarShapeType.bear:
        return BorderRadius.zero;
    }
  }
}

// --- 하트 모양 그리기 ---
class HeartShapePainter extends CustomPainter {
  final Color color;
  final Color isToday; // 오늘 날짜 여부

  HeartShapePainter(this.color, this.isToday);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final width = size.width;
    final height = size.height;

    final path = Path();
    // path.moveTo(width / 2, height * 0.9);
    // path.cubicTo(-width * 0.2, height * 0.4, width * 0.1, 0, width / 2, height * 0.3);
    // path.cubicTo(width * 0.9, 0, width * 1.2, height * 0.4, width / 2, height * 0.9);

    path.moveTo(width / 2, height * 0.8);

    path.cubicTo(
      -width * 0.1, height * 0.4,  // 왼쪽 곡선 시작
      width * 0.1, -height * 0.05, // 왼쪽 위 꼭지점
      width / 2, height * 0.3,     // 중앙 윗부분
    );

    path.cubicTo(
      width * 0.9, -height * 0.05, // 오른쪽 위 꼭지점
      width * 1.1, height * 0.4,   // 오른쪽 곡선 시작
      width / 2, height * 0.8,     // 아래쪽 하트 밑부분
    );
    // 오늘이면 테두리 먼저 그림

    final borderPaint = Paint()
      ..color = isToday
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(path, borderPaint);


    // 내부 색상 채우기
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BearShapePainter extends CustomPainter {
  final Color color;
  final Color isToday; // 오늘 날짜 여부

  BearShapePainter(this.color, this.isToday);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final width = size.width;
    final height = size.height;

    final baseSize = min(size.width, size.height);

    // 곰 머리
    final headPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(width / 2, height / 2), radius: baseSize / 2.2));

    // 곰 귀 (왼쪽)
    final leftEarPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(width / 4, height / 4), radius: baseSize / 4));

    // 곰 귀 (오른쪽)
    final rightEarPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(3 * width / 4, height / 4), radius: baseSize / 4));


    // --- 테두리 먼저 그리기 (오늘일 경우) ---

    final borderPaint = Paint()
      ..color = isToday
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(headPath, borderPaint);
    canvas.drawPath(leftEarPath, borderPaint);
    canvas.drawPath(rightEarPath, borderPaint);


    // --- 본 색상 채우기 ---
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(headPath, fillPaint);
    canvas.drawPath(leftEarPath, fillPaint);
    canvas.drawPath(rightEarPath, fillPaint);



    // 곰 얼굴 (눈, 코 등) 추가 가능
    // 예시로 간단히 눈 두 개와 코 그리기
    // final eyePaint = Paint()..color = Colors.black.withOpacity(0.3);

    // // 왼쪽 눈 (크기 줄임)
    // canvas.drawCircle(Offset(width / 3, height / 2), width / 15, eyePaint);
    //
    // // 오른쪽 눈 (크기 줄임)
    // canvas.drawCircle(Offset(2 * width / 3, height / 2), width / 15, eyePaint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

