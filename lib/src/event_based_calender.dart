import 'package:flutter/material.dart';
import 'event.dart';
import 'calender_widgets.dart';

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
const List<String> _weekdayNames = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

class EventBasedCalender extends StatefulWidget {
  final double? width;
  final List<Event> events;
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

  const EventBasedCalender({
    super.key,
    this.width,
    this.fontsize,
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
  });

  @override
  State<EventBasedCalender> createState() => EventBasedCalenderState();
}

class EventBasedCalenderState extends State<EventBasedCalender> {
  late final ValueNotifier<DateTime> _focusedDay;
  late final ValueNotifier<int?> _yearChooser;
  late final ValueNotifier<int?> _monthChooser;
  late final ValueNotifier<DateTime?> _selectedDate;
  late Map<String, Event> _eventLookup;

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
  void didUpdateWidget(covariant EventBasedCalender oldWidget) {
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

  void _goToPreviousMonth() {
    _focusedDay.value = DateTime(
      _focusedDay.value.year,
      _focusedDay.value.month - 1,
      1,
    );
  }

  void _goToNextMonth() {
    _focusedDay.value = DateTime(
      _focusedDay.value.year,
      _focusedDay.value.month + 1,
      1,
    );
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
    final Color defaultCurrentMonthColor =
        widget.currentMonthDateColor ?? Colors.black;
    final Color defaultPastFutureMonthColor =
        widget.pastFutureMonthDateColor ?? Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.width ?? double.infinity,
          color:
              widget.backgroundColor ??
              widget.primaryColor.withValues(alpha: 0.05),
          margin: widget.margin,
          padding: widget.padding ?? EdgeInsets.all(10),
          constraints: BoxConstraints(maxHeight: 350),
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
                              vertical: widget.width != null
                                  ? (widget.width! * .02)
                                  : 10,
                              horizontal: widget.width != null
                                  ? (widget.width! * .02)
                                  : 10,
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
                                      child: Icon(
                                        Icons.chevron_left,
                                        color: widget.chooserColor,
                                      ),
                                    ),
                                    SizedBox(width: dispSize.width * .04),
                                    GestureDetector(
                                      onTap: _goToNextMonth,
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: widget.chooserColor,
                                      ),
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
                                  children: List.generate(
                                    ((years.length) / 4).ceil(),
                                    (rowIndex) {
                                      return Row(
                                        children: List.generate(4, (colIndex) {
                                          int yearIndex =
                                              rowIndex * 4 + colIndex;
                                          if (yearIndex >= years.length) {
                                            return Expanded(child: SizedBox());
                                          }
                                          final year = years[yearIndex];
                                          final isSelected =
                                              year == focusedDay.year;
                                          return Expanded(
                                            child: GestureDetector(
                                              onTap: () => _selectYear(year),
                                              child: Container(
                                                margin: EdgeInsets.all(8),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? widget.primaryColor
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                    color: widget.primaryColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                alignment: Alignment.center,
                                                child:
                                                    CalnderWidgets.calnderText(
                                                      '$year',
                                                      textColor: isSelected
                                                          ? Colors.white
                                                          : widget.primaryColor,
                                                      textStype: isSelected
                                                          ? Font.bold
                                                          : Font.regular,
                                                      textSize:
                                                          dispSize.height *
                                                          .016,
                                                    ),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                  ),
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
                                        int monthIndex =
                                            rowIndex * 3 + colIndex + 1;
                                        if (monthIndex > 12)
                                          return Expanded(child: SizedBox());
                                        final isSelected =
                                            monthIndex == focusedDay.month;
                                        final monthName =
                                            _monthNames[monthIndex - 1];
                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () =>
                                                _selectMonth(monthIndex),
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? widget.primaryColor
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: widget.primaryColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              alignment: Alignment.center,
                                              child: CalnderWidgets.calnderText(
                                                monthName,
                                                textColor: isSelected
                                                    ? Colors.white
                                                    : widget.primaryColor,
                                                textStype: isSelected
                                                    ? Font.bold
                                                    : Font.regular,
                                                textSize:
                                                    dispSize.height * .016,
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
                                  children: List.generate((days.length / 7).ceil(), (
                                    rowIndex,
                                  ) {
                                    return Row(
                                      children: List.generate(7, (colIndex) {
                                        int dayIndex = rowIndex * 7 + colIndex;
                                        if (dayIndex >= days.length) {
                                          return Expanded(child: SizedBox());
                                        }
                                        final day = days[dayIndex];
                                        final isCurrentMonth =
                                            day.month == focusedDay.month;
                                        final event = getEvent(day);
                                        final prevEvent = colIndex > 0
                                            ? getEvent(days[dayIndex - 1])
                                            : null;
                                        final nextEvent =
                                            colIndex < 6 &&
                                                dayIndex + 1 < days.length
                                            ? getEvent(days[dayIndex + 1])
                                            : null;
                                        bool isStreakLeft =
                                            event != null &&
                                            prevEvent != null &&
                                            prevEvent.eventName ==
                                                event.eventName;
                                        bool isStreakRight =
                                            event != null &&
                                            nextEvent != null &&
                                            nextEvent.eventName ==
                                                event.eventName;
                                        BorderRadius borderRadius;
                                        EdgeInsets paddings = EdgeInsets.zero;
                                        if (isStreakLeft && isStreakRight) {
                                          borderRadius = BorderRadius.zero;
                                        } else if (isStreakLeft) {
                                          borderRadius = BorderRadius.only(
                                            topRight: Radius.circular(999),
                                            bottomRight: Radius.circular(999),
                                          );
                                          paddings = EdgeInsets.only(
                                            right: dispSize.width * .01,
                                            top: dispSize.height * .005,
                                            bottom: dispSize.height * .005,
                                          );
                                        } else if (isStreakRight) {
                                          borderRadius = BorderRadius.only(
                                            topLeft: Radius.circular(999),
                                            bottomLeft: Radius.circular(999),
                                          );
                                          paddings = EdgeInsets.only(
                                            left: dispSize.width * .01,
                                            top: dispSize.height * .005,
                                            bottom: dispSize.height * .005,
                                          );
                                        } else {
                                          borderRadius = BorderRadius.circular(
                                            999,
                                          );
                                          paddings = EdgeInsets.symmetric(
                                            horizontal: dispSize.width * .01,
                                            vertical: dispSize.height * .005,
                                          );
                                        }
                                        final isSelected =
                                            widget.isSelectedShow == true &&
                                            selectedDate != null &&
                                            selectedDate.year == day.year &&
                                            selectedDate.month == day.month &&
                                            selectedDate.day == day.day;
                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (widget.onDateTap != null &&
                                                  isCurrentMonth) {
                                                widget.onDateTap!(day);
                                              }
                                              if (widget.isSelectedShow ==
                                                      true &&
                                                  isCurrentMonth) {
                                                _selectedDate.value = day;
                                              }
                                            },
                                            child: Container(
                                              height: dispSize.height * .03,
                                              alignment: Alignment.center,
                                              margin: paddings,
                                              decoration: isSelected
                                                  ? BoxDecoration(
                                                      color:
                                                          widget
                                                              .isSelectedColor ??
                                                          Colors.grey,
                                                      borderRadius:
                                                          borderRadius,
                                                    )
                                                  : event != null
                                                  ? BoxDecoration(
                                                      color: event.color,
                                                      borderRadius:
                                                          borderRadius,
                                                    )
                                                  : null,
                                              child: Center(
                                                child: CalnderWidgets.calnderText(
                                                  '${day.day}',
                                                  textColor:
                                                      (isSelected ||
                                                          event != null)
                                                      ? Colors.white
                                                      : (isCurrentMonth
                                                            ? defaultCurrentMonthColor
                                                            : defaultPastFutureMonthColor),
                                                  textSize:
                                                      widget.fontsize ??
                                                      dispSize.height * .014,
                                                  textStype: Font.regular,
                                                ),
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
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        widget.showEvent ?? false
            ? Padding(
                padding: widget.margin ?? EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: dispSize.height * .01),
                    Column(
                      children: List.generate(
                        (widget.events.length / 2).ceil(),
                        (rowIndex) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: dispSize.height * .008,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(2, (colIndex) {
                                int eventIndex = rowIndex * 2 + colIndex;
                                if (eventIndex >= widget.events.length) {
                                  return Expanded(child: SizedBox());
                                }
                                final event = widget.events[eventIndex];
                                return Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 7,
                                        backgroundColor: event.color,
                                      ),
                                      SizedBox(width: 6),
                                      Flexible(
                                        child: CalnderWidgets.calnderText(
                                          event.eventName,
                                          textSize:
                                              widget.fontsize ??
                                              dispSize.height * .015,
                                          textStype: Font.medium,
                                          textBehaviour: TextOverflow.ellipsis,
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
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
