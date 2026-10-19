import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udm/screens/extra_game_screen.dart';
import 'package:udm/screens/game_mode_screen.dart';
import 'package:udm/models/word.dart';

void main() {
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

    expect(find.text('Распредели по темам'), findsOneWidget);
    expect(find.byType(DragTarget<Word>), findsNWidgets(2));
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
