import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/main.dart';
import 'package:pulse/features/progress/progress_screen.dart';
import 'package:pulse/features/wellbeing/wellbeing_screen.dart';
import 'package:pulse/features/family/family_circle_screen.dart';
import 'package:pulse/features/home/home_screen.dart';
import 'package:pulse/features/care/care_screen.dart';
import 'package:pulse/features/records/records_screen.dart';

void main() {
  testWidgets('Pulse app launches and renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PulseApp()));
    await tester.pump();
    expect(find.text('PULSE'), findsOneWidget);
    expect(find.text('Continuous care between consultations'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();
  });

  testWidgets('Progress screen renders wellbeing card and trends on mobile viewport without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProgressScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your wellbeing'), findsOneWidget);
    expect(find.text('Mood'), findsOneWidget);
    expect(find.text('Stress'), findsWidgets);
    expect(find.text('Energy'), findsWidgets);
    expect(find.text('Sleep'), findsWidgets);
  });

  testWidgets('Wellbeing screen renders without right overflow on mobile viewport', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: WellbeingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wellbeing'), findsOneWidget);
    expect(find.text('Calm breathing space'), findsOneWidget);
    expect(find.text('Your recent wellbeing'), findsOneWidget);
  });

  testWidgets('Family circle screen renders without overflow on mobile viewport', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: FamilyCircleScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Family Circle'), findsOneWidget);
  });

  testWidgets('Home screen renders wellbeing space card without overflow on mobile viewport', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mental Wellbeing & Reflection'), findsOneWidget);
    expect(find.text('Open Wellbeing Space'), findsOneWidget);
  });

  testWidgets('Care screen renders without overflow on mobile viewport', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CareScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your care continuity'), findsOneWidget);
    expect(find.text('Personal Wellbeing Space'), findsOneWidget);
  });

  testWidgets('Records screen renders without overflow on mobile viewport', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RecordsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('STAGE 05 · SECURE PERSONAL ARCHIVE'), findsOneWidget);
    expect(find.text('Browse by category'), findsOneWidget);
  });
}


