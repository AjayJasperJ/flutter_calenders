import 'package:flutter_calenders/flutter_calenders.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('BuildCustomCalendar renders without error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventBasedCalender(
            events: [
              Event(
                eventName: 'Test',
                dates: [DateTime(2025, 8, 28)],
                color: Colors.red,
              ),
            ],
            primaryColor: Colors.blue,
          ),
        ),
      ),
    );
    expect(find.byType(EventBasedCalender), findsOneWidget);
    expect(find.text('August'), findsOneWidget);
  });

  testWidgets('BuildCustomCalendar renders without error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScheduleBasedCalender(
            events: [
              Event(
                eventName: 'Test',
                dates: [DateTime(2025, 8, 28)],
                color: Colors.red,
              ),
            ],
            currentMonth: 8,
            currentYear: 2025,
          ),
        ),
      ),
    );
    expect(find.byType(ScheduleBasedCalender), findsOneWidget);
    expect(find.text('31'), findsOneWidget);
  });
}
