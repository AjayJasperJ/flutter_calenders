import 'package:flutter/material.dart';
import 'package:flutter_calenders/flutter_calenders.dart';

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
const List<String> _weekdayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

class EventCalendarTheme2 extends StatefulWidget {
  final double? width;
  final Color primaryColor;
  final Color? backgroundColor;
  final int? startYear;
  final int? endYear;
  final double? fontsize;
  final bool? showEvent;
  final Color? currentMonthDateColor;
  final Color? pastFutureMonthDateColor;
  final Color? chooserColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final void Function(DateTime date)? onDateTap;
  final bool? isSelectedShow;
  final Color? isSelectedColor;
  final List<Event> coloredEvents;
  final List<Event> events;
  final bool markAllDates;
  final double? legendTextSize;
  final FontWeight? legendTextWeight;
  final double? legendDotSize;
  final TextStyle? legendTextStyle;
  final TextStyle? calendarTextStyle;
  final double? calendarDotSize;

  const EventCalendarTheme2({
    super.key,
    this.width,
    this.fontsize,
    required this.coloredEvents,
    required this.events,
    required this.primaryColor,
    this.backgroundColor,
    this.startYear,
    this.showEvent,
    this.endYear,
    this.currentMonthDateColor,
    this.pastFutureMonthDateColor,
    this.chooserColor,
    this.margin,
    this.padding,
    this.onDateTap,
    this.isSelectedShow,
    this.isSelectedColor,
    this.markAllDates = false,
    this.legendTextSize,
    this.legendTextWeight,
    this.legendDotSize,
    this.legendTextStyle,
    this.calendarTextStyle,
    this.calendarDotSize,
  });

  @override
  State<EventCalendarTheme2> createState() => EventCalendarTheme2State();
}

class EventCalendarTheme2State extends State<EventCalendarTheme2> {
  late final ValueNotifier<DateTime> _focusedDay;
  late final ValueNotifier<int?> _yearChooser;
  late final ValueNotifier<int?> _monthChooser;
  late final ValueNotifier<DateTime?> _selectedDate;
  late Map<String, Event> _eventLookup;
  late Map<String, Event> _coloredEventLookup;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final startYear = widget.startYear ?? now.year;
    final endYear = widget.endYear ?? now.year;
    final initialDay = (now.year < startYear || now.year > endYear)
        ? DateTime(startYear, 1, 1)
        : now;
    _focusedDay = ValueNotifier<DateTime>(initialDay);
    _yearChooser = ValueNotifier<int?>(null);
    _monthChooser = ValueNotifier<int?>(null);
    _selectedDate = ValueNotifier<DateTime?>(null);
    _buildEventLookup();
  }

  @override
  void didUpdateWidget(covariant EventCalendarTheme2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Always rebuild event lookup for hot reload and property changes
    _buildEventLookup();
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _yearChooser.dispose();
    _monthChooser.dispose();
    _selectedDate.dispose();
    super.dispose();
  }

  void _buildEventLookup() {
    _eventLookup = {};
    for (final event in widget.events) {
      for (final date in event.dates) {
        final key = '${date.year}-${date.month}-${date.day}';
        _eventLookup[key] = event;
      }
    }
    _coloredEventLookup = {};
    for (final event in widget.coloredEvents) {
      for (final date in event.dates) {
        final key = '${date.year}-${date.month}-${date.day}';
        _coloredEventLookup[key] = event;
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

  Event? getColoredEvent(DateTime day) {
    return _coloredEventLookup['${day.year}-${day.month}-${day.day}'];
  }

  void _goToPreviousMonth() {
    _focusedDay.value = DateTime(_focusedDay.value.year, _focusedDay.value.month - 1, 1);
  }

  void _goToNextMonth() {
    _focusedDay.value = DateTime(_focusedDay.value.year, _focusedDay.value.month + 1, 1);
  }

  void _showYearChooser() {
    _yearChooser.value = _focusedDay.value.year;
    _monthChooser.value = null;
  }

  void _showMonthChooser() {
    _monthChooser.value = _focusedDay.value.month;
    _yearChooser.value = null;
  }

  void _selectYear(int year) {
    _focusedDay.value = DateTime(year, _focusedDay.value.month, 1);
    _yearChooser.value = null;
  }

  void _selectMonth(int month) {
    _focusedDay.value = DateTime(_focusedDay.value.year, month, 1);
    _monthChooser.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final endYear = widget.endYear ?? DateTime.now().year;
    final years = List.generate(
      endYear - (widget.startYear ?? DateTime.now().year) + 1,
      (i) => (widget.startYear ?? DateTime.now().year) + i,
    );
    final Size dispSize = MediaQuery.of(context).size;
    final Color defaultCurrentMonthColor = widget.currentMonthDateColor ?? Colors.black;
    final Color defaultPastFutureMonthColor = widget.pastFutureMonthDateColor ?? Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.width,
          color: widget.backgroundColor ?? widget.primaryColor.withValues(alpha: .05),
          margin: widget.margin,
          padding: widget.padding ?? EdgeInsets.all(10),
          constraints: BoxConstraints(maxHeight: 500),
          child: ValueListenableBuilder<DateTime>(
            valueListenable: _focusedDay,
            builder: (context, focusedDay, _) {
              final days = _daysInMonth(focusedDay); // cache for performance
              return ValueListenableBuilder<int?>(
                valueListenable: _yearChooser,
                builder: (context, yearChooser, _) {
                  return ValueListenableBuilder<int?>(
                    valueListenable: _monthChooser,
                    builder: (context, monthChooser, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: widget.width != null ? (widget.width! * .02) : 10,
                              horizontal: widget.width != null ? (widget.width! * .02) : 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: _showMonthChooser,
                                      child: CalnderWidgets.calnderText(
                                        _monthNames[focusedDay.month - 1],
                                        textSize: dispSize.height * .018,
                                        textStype: Font.medium,
                                        textColor: widget.chooserColor,
                                      ),
                                    ),
                                    SizedBox(width: dispSize.width * .02),
                                    GestureDetector(
                                      onTap: _showYearChooser,
                                      child: CalnderWidgets.calnderText(
                                        '${focusedDay.year}',
                                        textSize: dispSize.height * .018,
                                        textStype: Font.medium,
                                        textColor: widget.chooserColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: _goToPreviousMonth,
                                      child: Icon(Icons.chevron_left, color: widget.chooserColor),
                                    ),
                                    SizedBox(width: dispSize.width * .04),
                                    GestureDetector(
                                      onTap: _goToNextMonth,
                                      child: Icon(Icons.chevron_right, color: widget.chooserColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (yearChooser != null)
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(((years.length) / 4).ceil(), (rowIndex) {
                                    return Row(
                                      children: List.generate(4, (colIndex) {
                                        int yearIndex = rowIndex * 4 + colIndex;
                                        if (yearIndex >= years.length) {
                                          return Expanded(child: SizedBox());
                                        }
                                        final year = years[yearIndex];
                                        final isSelected = year == focusedDay.year;
                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () => _selectYear(year),
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? widget.primaryColor
                                                    : Colors.transparent,
                                                border: Border.all(color: widget.primaryColor),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              alignment: Alignment.center,
                                              child: CalnderWidgets.calnderText(
                                                '$year',
                                                textColor: isSelected
                                                    ? Colors.white
                                                    : widget.primaryColor,
                                                textStype: isSelected ? Font.bold : Font.regular,
                                                textSize: dispSize.height * .016,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  }),
                                ),
                              ),
                            )
                          else if (monthChooser != null)
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(4, (rowIndex) {
                                    return Row(
                                      children: List.generate(3, (colIndex) {
                                        int monthIndex = rowIndex * 3 + colIndex + 1;
                                        if (monthIndex > 12) return Expanded(child: SizedBox());
                                        final isSelected = monthIndex == focusedDay.month;
                                        final monthName = _monthNames[monthIndex - 1];
                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () => _selectMonth(monthIndex),
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? widget.primaryColor
                                                    : Colors.transparent,
                                                border: Border.all(color: widget.primaryColor),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              alignment: Alignment.center,
                                              child: CalnderWidgets.calnderText(
                                                monthName,
                                                textColor: isSelected
                                                    ? Colors.white
                                                    : widget.primaryColor,
                                                textStype: isSelected ? Font.bold : Font.regular,
                                                textSize: dispSize.height * .016,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  }),
                                ),
                              ),
                            )
                          else ...[
                            SizedBox(height: dispSize.height * .005),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(7, (index) {
                                final formatted = _weekdayNames[index];
                                return Expanded(
                                  child: Center(
                                    child: CalnderWidgets.calnderText(
                                      formatted,
                                      textColor: widget.primaryColor,
                                      textSize: dispSize.height * .015,
                                      textStype: Font.regular,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: dispSize.height * .01),
                            ValueListenableBuilder<DateTime?>(
                              valueListenable: _selectedDate,
                              builder: (context, selectedDate, _) {
                                return Column(
                                  children: List.generate((days.length / 7).ceil(), (rowIndex) {
                                    return Row(
                                      children: List.generate(7, (colIndex) {
                                        int dayIndex = rowIndex * 7 + colIndex;
                                        if (dayIndex >= days.length) {
                                          return Expanded(child: SizedBox());
                                        }
                                        final day = days[dayIndex];
                                        final isCurrentMonth = day.month == focusedDay.month;
                                        // final event = getEvent(day);
                                        final coloredEvent = getColoredEvent(day);
                                        final dotEvent = getEvent(day);
                                        final isWeekend =
                                            day.weekday == DateTime.sunday ||
                                            day.weekday == DateTime.saturday;
                                        final isToday =
                                            day.year == DateTime.now().year &&
                                            day.month == DateTime.now().month &&
                                            day.day == DateTime.now().day;
                                        final isSelected =
                                            widget.isSelectedShow == true &&
                                            selectedDate != null &&
                                            selectedDate.year == day.year &&
                                            selectedDate.month == day.month &&
                                            selectedDate.day == day.day;
                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (widget.onDateTap != null && isCurrentMonth) {
                                                widget.onDateTap!(day);
                                              }
                                              if (widget.isSelectedShow == true && isCurrentMonth) {
                                                _selectedDate.value = day;
                                              }
                                            },
                                            child: Container(
                                              height: dispSize.height * .04,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                right: dispSize.width * .01,
                                                left: dispSize.width * .01,
                                                top: dispSize.height * .005,
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: widget.width != null
                                                        ? widget.width! * .3
                                                        : dispSize.width * .06,
                                                    decoration: isSelected
                                                        ? BoxDecoration(
                                                            color:
                                                                widget.isSelectedColor ??
                                                                Colors.grey,
                                                            borderRadius: BorderRadius.circular(5),
                                                          )
                                                        : isToday
                                                        ? BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius: BorderRadius.circular(5),
                                                          )
                                                        : null,
                                                    child: Center(
                                                      child: CalnderWidgets.calnderText(
                                                        '${day.day}',
                                                        textColor: isSelected || isToday
                                                            ? Colors.white
                                                            : (coloredEvent != null
                                                                  ? coloredEvent.color
                                                                  : (isCurrentMonth
                                                                        ? defaultCurrentMonthColor
                                                                        : defaultPastFutureMonthColor)),
                                                        textSize:
                                                            widget.fontsize ??
                                                            dispSize.height * .014,
                                                        textStype: Font.regular,
                                                        directStyle: widget.calendarTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                  if (dotEvent != null)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 2.0),
                                                      child: Container(
                                                        width:
                                                            widget.calendarDotSize ??
                                                            dispSize.height * .006,
                                                        height:
                                                            widget.calendarDotSize ??
                                                            dispSize.height * .006,
                                                        decoration: BoxDecoration(
                                                          color: dotEvent.color,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    )
                                                  else if (isWeekend)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 2.0),
                                                      child: Container(
                                                        width:
                                                            widget.calendarDotSize ??
                                                            dispSize.height * .006,
                                                        height:
                                                            widget.calendarDotSize ??
                                                            dispSize.height * .006,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.red,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    )
                                                  else if (widget.markAllDates &&
                                                      dotEvent == null &&
                                                      !isWeekend)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 2.0),
                                                      child: Container(
                                                        width:
                                                            widget.calendarDotSize ??
                                                            dispSize.height * .006,
                                                        height:
                                                            widget.calendarDotSize ??
                                                            dispSize.height * .006,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.black,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  }),
                                );
                              },
                            ),
                          ],
                          (widget.showEvent ?? false)
                              ? Padding(
                                  padding: widget.margin ?? EdgeInsets.zero,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: dispSize.height * .04),
                                      Builder(
                                        builder: (context) {
                                          // Combine coloredEvents and events for legend
                                          final List<_LegendItem> legendItems = [
                                            ...widget.coloredEvents.map(
                                              (e) => _LegendItem(
                                                color: e.color,
                                                label: e.eventName,
                                                isDot: false,
                                              ),
                                            ),
                                            ...widget.events.map(
                                              (e) => _LegendItem(
                                                color: e.color,
                                                label: e.eventName,
                                                isDot: true,
                                              ),
                                            ),
                                            _LegendItem(
                                              color: Colors.red,
                                              label: 'Holiday (Sun/Sat)',
                                              isDot: true,
                                            ),
                                            if (widget.markAllDates)
                                              _LegendItem(
                                                color: Colors.black,
                                                label: 'Marked Date',
                                                isDot: true,
                                              ),
                                          ];
                                          return Column(
                                            children: List.generate(
                                              (legendItems.length / 4).ceil(),
                                              (rowIndex) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: dispSize.height * .008,
                                                  ),
                                                  child: Row(
                                                    children: List.generate(4, (colIndex) {
                                                      int legendIndex = rowIndex * 4 + colIndex;
                                                      if (legendIndex >= legendItems.length) {
                                                        return Expanded(child: SizedBox());
                                                      }
                                                      final item = legendItems[legendIndex];
                                                      return Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          children: [
                                                            item.isDot
                                                                ? Container(
                                                                    width:
                                                                        widget.legendDotSize ??
                                                                        dispSize.height * .012,
                                                                    height:
                                                                        widget.legendDotSize ??
                                                                        dispSize.height * .012,
                                                                    alignment: Alignment.center,
                                                                    child: Container(
                                                                      width:
                                                                          (widget.legendDotSize ??
                                                                              dispSize.height *
                                                                                  .012) /
                                                                          2,
                                                                      height:
                                                                          (widget.legendDotSize ??
                                                                              dispSize.height *
                                                                                  .012) /
                                                                          2,
                                                                      decoration: BoxDecoration(
                                                                        color: item.color,
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : CircleAvatar(
                                                                    radius:
                                                                        (widget.legendDotSize ??
                                                                            dispSize.height *
                                                                                .012) /
                                                                        2,
                                                                    backgroundColor: item.color,
                                                                  ),
                                                            SizedBox(width: 6),
                                                            Flexible(
                                                              child: CalnderWidgets.calnderText(
                                                                item.label,
                                                                textSize:
                                                                    widget.legendTextSize ??
                                                                    widget.fontsize ??
                                                                    dispSize.height * .015,
                                                                textStype:
                                                                    widget.legendTextWeight != null
                                                                    ? (widget.legendTextWeight ==
                                                                              FontWeight.bold
                                                                          ? Font.bold
                                                                          : Font.medium)
                                                                    : Font.medium,
                                                                textBehaviour:
                                                                    TextOverflow.ellipsis,
                                                                directStyle: widget.legendTextStyle,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Helper class for legend items
class _LegendItem {
  final Color color;
  final String label;
  final bool isDot; // true for dot, false for colored text
  _LegendItem({required this.color, required this.label, required this.isDot});
}
