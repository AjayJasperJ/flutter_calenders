import 'package:flutter/material.dart';
import 'package:flutter_calenders/flutter_calenders.dart';

class ScheduleBasedCalender extends StatefulWidget {
  final double? width;
  final double? height;
  final List<Event> events;
  final Color? backgroundColor;
  final Color? monthDateColor;
  final Color? monthTextColor;
  final Color? weekdayColor;
  final Color? weekdayTextColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final void Function(DateTime date)? onDateTap;
  final bool? isSelectedShow;
  final Color? isSelectedColor;
  final Color? isSelectedTextColor;
  final int currentMonth;
  final int currentYear;

  const ScheduleBasedCalender({
    super.key,
    this.width,
    this.height,
    required this.events,
    this.backgroundColor,
    this.monthDateColor,
    this.monthTextColor,
    this.weekdayColor,
    this.weekdayTextColor,
    this.margin,
    this.padding,
    this.onDateTap,
    this.isSelectedShow,
    this.isSelectedColor,
    this.isSelectedTextColor,
    required this.currentMonth,
    required this.currentYear,
  });

  @override
  State<ScheduleBasedCalender> createState() => ScheduleBasedCalenderState();
}

class ScheduleBasedCalenderState extends State<ScheduleBasedCalender> {
  late DateTime _focusedDay;
  late Map<String, Event> _eventLookup;
  late ValueNotifier<DateTime?> _selectedDate;
  final List<String> _weekdayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  @override
  void initState() {
    super.initState();
    int year = widget.currentYear;
    int month = widget.currentMonth;
    if (month < 1) month = 1;
    if (month > 12) month = 12;
    _focusedDay = DateTime(year, month, 1);
    _buildEventLookup();
    _selectedDate = ValueNotifier<DateTime?>(null);
  }

  @override
  void dispose() {
    _selectedDate.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ScheduleBasedCalender oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentYear != widget.currentYear ||
        oldWidget.currentMonth != widget.currentMonth) {
      int year = widget.currentYear;
      int month = widget.currentMonth;
      if (month < 1) month = 1;
      if (month > 12) month = 12;
      _focusedDay = DateTime(year, month, 1);
    }
    if (oldWidget.events != widget.events) {
      _buildEventLookup();
    }
  }

  void _buildEventLookup() {
    _eventLookup = {};
    for (final event in widget.events) {
      for (final date in event.dates) {
        final key = '${date.year}-${date.month}-${date.day}';
        _eventLookup[key] = event;
      }
    }
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysBefore = first.weekday % 7;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    final last = DateTime(month.year, month.month + 1, 0);
    final daysAfter = 6 - (last.weekday % 7);
    final lastToDisplay = last.add(Duration(days: daysAfter));
    return List.generate(
      lastToDisplay.difference(firstToDisplay).inDays + 1,
      (i) => firstToDisplay.add(Duration(days: i)),
    );
  }

  Event? getEvent(DateTime day) {
    return _eventLookup['${day.year}-${day.month}-${day.day}'];
  }

  @override
  Widget build(BuildContext context) {
    final Size dispSize = MediaQuery.of(context).size;
    final double fontSize = widget.height != null ? widget.height! * .04 : dispSize.height * .015;
    final days = _daysInMonth(_focusedDay);
    return Container(
      height: widget.height,
      width: widget.width,
      padding: widget.padding ?? EdgeInsets.all(10),
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(7, (index) {
              final formatted = _weekdayNames[index];
              return Container(
                height: widget.height != null ? widget.height! * .12 : dispSize.height * .05,
                width: widget.width != null ? widget.width! * .12 : dispSize.height * .05,
                margin: EdgeInsets.all(dispSize.height * .002),
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: widget.weekdayColor),
                child: Center(
                  child: CalnderWidgets.calnderText(
                    formatted,
                    textColor: widget.weekdayTextColor,
                    textSize: fontSize,
                    textStype: Font.regular,
                  ),
                ),
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate((days.length / 7).ceil(), (rowIndex) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(7, (colIndex) {
                  int dayIndex = rowIndex * 7 + colIndex;
                  if (dayIndex >= days.length) return SizedBox();
                  final day = days[dayIndex];
                  final isCurrentMonth = day.month == _focusedDay.month;
                  final event = getEvent(day);
                  return ValueListenableBuilder<DateTime?>(
                    valueListenable: _selectedDate,
                    builder: (context, selected, _) {
                      final isSelected =
                          widget.isSelectedShow == true &&
                          selected != null &&
                          selected.year == day.year &&
                          selected.month == day.month &&
                          selected.day == day.day;
                      Color? cellColor;
                      if (!isCurrentMonth) {
                        cellColor = Colors.transparent;
                      } else if (isSelected) {
                        cellColor = widget.isSelectedColor ?? Theme.of(context).primaryColor;
                      } else if (event != null) {
                        cellColor = event.color;
                      } else {
                        cellColor =
                            widget.monthDateColor ??
                            Theme.of(context).primaryColor.withValues(alpha: .1);
                      }
                      Color? textColor;
                      if (!isCurrentMonth) {
                        textColor = Colors.transparent;
                      } else if (isSelected) {
                        textColor = widget.isSelectedTextColor ?? Colors.white;
                      } else if (event != null) {
                        textColor = widget.isSelectedTextColor ?? Colors.white;
                      } else {
                        textColor = widget.monthTextColor ?? Colors.black;
                      }
                      return GestureDetector(
                        onTap: () {
                          if (widget.onDateTap != null && isCurrentMonth) {
                            widget.onDateTap!(day);
                          }
                          if (widget.isSelectedShow == true && isCurrentMonth) {
                            _selectedDate.value = day;
                          }
                        },
                        child: Container(
                          height: widget.height != null
                              ? widget.height! * .12
                              : dispSize.height * .05,
                          width: widget.width != null ? widget.width! * .12 : dispSize.height * .05,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(dispSize.height * .002),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: cellColor),
                          child: CalnderWidgets.calnderText(
                            isCurrentMonth ? '${day.day}' : '',
                            textColor: textColor,
                            textSize: fontSize,
                            textStype: Font.regular,
                          ),
                        ),
                      );
                    },
                  );
                }),
              );
            }),
          ),
        ],
      ),
    );
  }
}
