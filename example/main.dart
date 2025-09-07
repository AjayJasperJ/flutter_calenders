import 'package:flutter/material.dart';
import 'package:flutter_calenders/flutter_calenders.dart';

void main() => runApp(const MyEngine());

class MyEngine extends StatelessWidget {
  const MyEngine({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyCalenders());
  }
}

class MyCalenders extends StatefulWidget {
  const MyCalenders({super.key});

  @override
  State<MyCalenders> createState() => _MyCalendersState();
}

class _MyCalendersState extends State<MyCalenders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EventBasedCalender(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              events: [
                Event(
                  eventName: 'Sick leave',
                  dates: [DateTime(2025, 8, 21), DateTime(2025, 8, 22)],
                  color: Colors.green,
                ),
                Event(
                  eventName: 'Paid leave',
                  dates: [DateTime(2025, 8, 17), DateTime(2025, 8, 18)],
                  color: Colors.orange,
                ),
              ],
              primaryColor: Colors.blue,
              backgroundColor: Colors.blue.withValues(alpha: .05),
              chooserColor: Colors.black,
              endYear: 2028,
              startYear: 2020,
              currentMonthDateColor: Colors.black,
              pastFutureMonthDateColor: Colors.grey,
              isSelectedColor: Colors.amber,
              isSelectedShow: true,
              showEvent: true,
              onDateTap: (date) {
                print(date);
              },
            ),
            ScheduleBasedCalender(
              events: [
                Event(
                  eventName: 'Sick leave',
                  dates: [DateTime(2025, 8, 21), DateTime(2025, 8, 22)],
                  color: Colors.green,
                ),
                Event(
                  eventName: 'Paid leave',
                  dates: [DateTime(2025, 8, 17), DateTime(2025, 8, 18)],
                  color: Colors.orange,
                ),
              ],
              currentMonth: 8,
              currentYear: 2025,
              backgroundColor: Colors.white.withValues(alpha: .1),
              monthDateColor: Colors.white.withValues(alpha: .1),
              weekdayColor: Colors.white.withValues(alpha: .1),
              monthTextColor: Colors.white,
              weekdayTextColor: Colors.white,
              isSelectedShow: true,
              isSelectedColor: Colors.deepOrange,
              onDateTap: (date) {
                print(date);
              },
            ),
            EventCalendarTheme2(
              markAllDates: true,
              coloredEvents: [
                Event(
                  eventName: 'Absent',
                  dates: [
                    7,
                    14,
                    21,
                    28,
                    20,
                  ].map((e) => DateTime(2025, 9, e)).toList(),
                  color: Colors.red,
                ),
              ],
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              events: [
                Event(
                  eventName: 'Present',
                  dates: [
                    1,
                    2,
                    3,
                    4,
                    5,
                    8,
                    9,
                    10,
                    11,
                    12,
                    15,
                    16,
                    17,
                    18,
                    19,
                    22,
                    23,
                    24,
                  ].map((element) => DateTime(2025, 9, element)).toList(),
                  color: Colors.green,
                ),
              ],
              primaryColor: Colors.blueGrey,
              backgroundColor: Colors.white,
              chooserColor: Colors.black,
              todayColor: Colors.blue.withValues(alpha: .5),
              endYear: 2028,
              startYear: 2020,
              currentMonthDateColor: Colors.black,
              pastFutureMonthDateColor: Colors.grey,
              isSelectedColor: Colors.amber,
              isSelectedShow: true,
              showEvent: true,
              onDateTap: (date) {
                print(date);
              },
            ),
          ],
        ),
      ),
    );
  }
}
