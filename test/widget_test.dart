import 'package:flutter_test/flutter_test.dart';
import 'package:space_eduos/app.dart';

void main() {
  testWidgets('Cek tampilan awal', (WidgetTester tester) async {
    // Memanggil TahfidzCoreApp, bukan MyApp
    await tester.pumpWidget(const TahfidzCoreApp());
  });
}