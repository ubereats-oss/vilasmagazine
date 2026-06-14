import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vilas_magazine/core/constants/app_strings.dart';
import 'package:vilas_magazine/presentation/widgets/app_bar_widget.dart';

void main() {
  testWidgets('renders Vilas Magazine app bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(appBar: VilasAppBar(showSearch: false))),
    );

    expect(find.byType(VilasLogo), findsOneWidget);
    expect(AppStrings.appName, 'Vilas Magazine');
  });
}
