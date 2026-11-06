import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udm/constants.dart';
import 'package:udm/screens/extra_game_screen.dart';
import 'package:udm/screens/game_mode_screen.dart';
import 'package:udm/models/word.dart';

void main() {
  test('correct and incorrect feedback use distinct green and red colors', () {
    expect(AppColors.success, const Color(0xFF2E7D32));
    expect(AppColors.error, const Color(0xFFC62828));
  });

  testWidgets('find odd word game shows four choices', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: ExtraGameScreen(mode: ExtraGameMode.findOdd)),
    );

    expect(find.text('Найди лишнее слово'), findsOneWidget);
    expect(find.text('Какое слово из другой темы?'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(GridView),
        matching: find.byType(InkWell),
      ),
      findsNWidgets(4),
    );
  });

  testWidgets('translation game offers three answers', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(
        home: GameModeScreen(gameMode: GameMode.chooseTranslation),
      ),
    );
    await tester.pump();

    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });

  testWidgets('sorting game provides two drop categories', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: ExtraGameScreen(mode: ExtraGameMode.sortWords)),
    );

    expect(find.text('Сортировка'), findsOneWidget);
    expect(find.byType(DragTarget<Word>), findsNWidgets(2));
  });

  testWidgets('selecting a word does not reveal its category', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: ExtraGameScreen(mode: ExtraGameMode.sortWords)),
    );

    await tester.tap(find.byType(Draggable<Word>).first);
    await tester.pump();
    expect(find.textContaining('Выбрано:'), findsOneWidget);

    for (final target in find.byType(DragTarget<Word>).evaluate()) {
      final category = find.descendant(
        of: find.byWidget(target.widget),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration! as BoxDecoration).border != null,
        ),
      );
      final container = tester.widget<Container>(category.first);
      final border = (container.decoration! as BoxDecoration).border! as Border;
      expect(border.top.color, AppColors.cardBorderLight);
    }
  });

  testWidgets('memory game starts with eight hidden cards', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: ExtraGameScreen(mode: ExtraGameMode.memoryPairs)),
    );

    expect(find.text('Найди пару'), findsOneWidget);
    expect(find.text('?'), findsNWidgets(8));
  });
}
