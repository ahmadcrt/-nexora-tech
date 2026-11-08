import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexora_tech/app.dart';

void main() {
  testWidgets('home page shows the tagline and services', (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: NexoraApp()));
    await tester.pumpAndSettle();

    expect(find.text('Technology That Moves Business Forward.'), findsWidgets);
    expect(find.text('Website Development'), findsWidgets);
    expect(find.text('Digital Solutions'), findsWidgets);
  });
}
