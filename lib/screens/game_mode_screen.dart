import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../constants.dart';
import '../data/vocabulary.dart';
import '../models/word.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../services/sound_service.dart';
import '../theme.dart';

enum GameMode { chooseTranslation, wordScramble, trueFalse }

class GameModeScreen extends StatefulWidget {
  final GameMode gameMode;

  const GameModeScreen({super.key, required this.gameMode});

  @override
  State<GameModeScreen> createState() => _GameModeScreenState();
}

class _GameModeScreenState extends State<GameModeScreen> {
  List<Word> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  List<QuestionResult> _results = [];
  bool _answered = false;
  bool? _isCorrect;
  int? _selectedIndex;
  String? _selectedOptionText;
  List<String> _scrambledLetters = [];
  String _userAnswer = '';
  bool _tfAnswered = false;
  bool? _tfCorrect;
  bool _tfShowCorrect = true;
  bool? _tfUserAnswer;

  @override
  void initState() {
    super.initState();
    _generateQuestions();
    if (widget.gameMode == GameMode.wordScramble) {
      _scrambleCurrentWord();
    }
    _initTrueFalseQuestion();
  }

  void _initTrueFalseQuestion() {
    if (widget.gameMode == GameMode.trueFalse) {
      setState(() {
        _tfShowCorrect = Random().nextBool();
      });
    }
  }

  void _generateQuestions() {
    final allWords = List<Word>.from(VocabularyData.words);
    allWords.shuffle(Random());
    _questions = allWords.take(10).toList();
  }

  void _scrambleCurrentWord() {
    final word = _questions[_currentIndex].udmurt;
    final letters = word.split('');
    letters.shuffle(Random());
    setState(() {
      _scrambledLetters = letters;
      _userAnswer = '';
    });
  }

  void _checkAnswer(int selectedOption, List<String> options) {
    if (_answered) return;
    final correctAnswer = _questions[_currentIndex].russian;
    final isCorrect = options[selectedOption] == correctAnswer;

    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
      _selectedIndex = selectedOption;
      _selectedOptionText = options[selectedOption];
      if (isCorrect) {
        _score++;
        SoundService.playCorrect();
      } else {
        SoundService.playIncorrect();
      }
    });

    // Record the result
    _results.add(QuestionResult(
      word: _questions[_currentIndex],
      isCorrect: isCorrect,
      selectedOption: options[selectedOption],
      points: isCorrect ? 10 : 0,
    ));

    _finishQuestion();
  }

  void _checkTrueFalse(bool userSaysTrue) {
    if (_tfAnswered) return;
    final isActuallyTrue = _tfShowCorrect;

    setState(() {
      _tfAnswered = true;
      _tfCorrect = userSaysTrue == isActuallyTrue;
      _tfUserAnswer = userSaysTrue;
      if (_tfCorrect!) {
        _score++;
        SoundService.playCorrect();
      } else {
        SoundService.playIncorrect();
      }
    });

    // Record the result
    _results.add(QuestionResult(
      word: _questions[_currentIndex],
      isCorrect: _tfCorrect!,
      userSaysTrue: userSaysTrue,
      points: _tfCorrect! ? 10 : 0,
    ));

    _finishQuestion();
  }

  void _finishQuestion() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _isCorrect = null;
          _selectedIndex = null;
          _selectedOptionText = null;
          _tfAnswered = false;
          _tfCorrect = null;
          _tfUserAnswer = null;
        });
        if (widget.gameMode == GameMode.wordScramble) {
          _scrambleCurrentWord();
        } else if (widget.gameMode == GameMode.trueFalse) {
          _initTrueFalseQuestion();
        }
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    context.read<AuthProvider>().addXP(_score * 10);
    context.read<AuthProvider>().updateGameStats(
          _getGameTypeName(),
          _score,
          _questions.length,
        );

    final incorrectAnswers = _results.where((r) => !r.isCorrect).length;
    final totalPoints = _results.fold<int>(0, (sum, r) => sum + r.points);
    final dialogBg = AppTheme.dialogBackground(context);
    final textColor = AppTheme.gameTextColor(context);
    final textSecondaryColor = AppTheme.gameTextSecondaryColor(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: dialogBg,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _score == _questions.length
                          ? '🏆'
                          : _score >= 7
                              ? '🎉'
                              : '💪',
                      style: const TextStyle(fontSize: 56),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Результат',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          '✅',
                          '$_score',
                          'Правильно',
                        ),
                        _buildStatCard(
                          '❌',
                          '$incorrectAnswers',
                          'Ошибки',
                        ),
                        _buildStatCard(
                          '⭐',
                          '$totalPoints',
                          'Баллы',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Results list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return _buildResultItem(result, index + 1);
                  },
                ),
              ),
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gameCardBackground(context),
                          foregroundColor: textColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppTheme.gameCardBorderColor(context),
                              width: 2,
                            ),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'К ИГРАМ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _restartGame();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.pink,
                        ),
                        child: const Text(
                          'ЕЩЁ РАЗ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(QuestionResult result, int number) {
    final word = result.word;
    final emoji = _getEmojiForWord(word);
    final textColor = AppTheme.gameTextColor(context);
    final textSecondaryColor = AppTheme.gameTextSecondaryColor(context);
    final cardBgColor = AppTheme.gameCardBackground(context);
    final cardBorderColor = AppTheme.gameCardBorderColor(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: result.isCorrect
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: result.isCorrect
              ? AppColors.success.withOpacity(0.3)
              : AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Number and emoji
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: result.isCorrect ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Emoji
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          // Word details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.udmurt,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  word.transcription,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondaryColor,
                  ),
                ),
                Text(
                  word.russian,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondaryColor,
                  ),
                ),
                // Show user's answer if incorrect
                if (!result.isCorrect) ...[
                  const SizedBox(height: 4),
                  Text(
                    _getUserAnswerText(result),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: result.isCorrect
                  ? AppColors.success.withOpacity(0.2)
                  : AppColors.error.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              result.isCorrect ? '+${result.points}' : '0',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: result.isCorrect ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getUserAnswerText(QuestionResult result) {
    switch (widget.gameMode) {
      case GameMode.chooseTranslation:
        return 'Ваш ответ: ${result.selectedOption ?? "—"}';
      case GameMode.wordScramble:
        return 'Ваш ответ: ${result.userAnswer ?? "—"}';
      case GameMode.trueFalse:
        if (result.userSaysTrue == null) return '';
        return 'Ваш ответ: ${result.userSaysTrue! ? "Верно" : "Не верно"}';
    }
  }

  void _restartGame() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _results = [];
      _answered = false;
      _isCorrect = null;
      _selectedIndex = null;
      _selectedOptionText = null;
      _tfAnswered = false;
      _tfCorrect = null;
      _tfUserAnswer = null;
      _tfShowCorrect = true;
    });
    _generateQuestions();
    if (widget.gameMode == GameMode.wordScramble) {
      _scrambleCurrentWord();
    } else if (widget.gameMode == GameMode.trueFalse) {
      _initTrueFalseQuestion();
    }
  }

  String _getGameTypeName() {
    switch (widget.gameMode) {
      case GameMode.chooseTranslation:
        return 'choose_translation';
      case GameMode.wordScramble:
        return 'word_scramble';
      case GameMode.trueFalse:
        return 'true_false';
    }
  }

  String _getEmojiForWord(Word word) {
    const m = {
      // Greetings
      'hello_formal': '🤝', 'hello_informal': '🙋', 'greeting': '👋',
      'goodbye': '👋', 'thank_you': '🙏', 'please': '🤲',
      'how_are_you': '😊', 'good_morning': '🌅', 'good_night': '🌙',
      'nice_to_meet': '😃', 'good_day': '☀️', 'good_evening': '🌆',
      // Numbers
      'one': '1️⃣', 'two': '2️⃣', 'three': '3️⃣', 'four': '4️⃣', 'five': '5️⃣',
      'six': '6️⃣', 'seven': '7️⃣', 'eight': '8️⃣', 'nine': '9️⃣', 'ten': '🔟',
      // Wild animals
      'bear': '🐻', 'wolf': '🐺', 'fox': '🦊', 'hare': '🐇', 'moose': '🦌',
      'squirrel': '🐿️', 'hedgehog': '🦔', 'eagle': '🦅', 'boar': '🐗',
      // Domestic animals
      'cow': '🐄', 'horse': '🐴', 'sheep': '🐑', 'pig': '🐖', 'chicken': '🐓',
      'dog': '🐕', 'cat': '🐈', 'goose': '🪿', 'ram': '🐏', 'bull': '🐂',
      'goat': '🐐',
      // Food
      'bread': '🍞', 'milk': '🥛', 'porridge': '🥣', 'pelmeni': '🥟',
      'soup': '🍲', 'egg': '🥚', 'meat': '🥩', 'butter': '🧈',
      'food': '🍽️', 'pancake': '🥞',
      // Clothes
      'dress_shirt': '👔', 'apron': '🥼', 'scarf': '🧣',
      // Family
      'mother': '👩', 'father': '👨', 'sister': '👧', 'brother': '👦',
      'grandmother': '👵', 'grandfather': '👴', 'son': '🧒', 'daughter': '👧',
      'parents': '👨‍👩', 'uncle': '👨', 'spouse': '💑', 'wife': '👰',
      // Vegetables
      'onion': '🧅', 'cabbage': '🥬', 'beet': '🟣', 'carrot': '🥕',
      'cucumber': '🥒',
      // Colors
      'white': '⚪', 'black': '⚫', 'blue': '🔵', 'yellow': '🟡',
      'green': '🟢', 'pink': '🩷', 'red': '🔴',
      // Berries
      'viburnum': '🔴', 'lingonberry': '🍒', 'strawberry': '🍓',
      'strawberry_garden': '🍓', 'cranberry': '🫐', 'blueberry': '🫐',
      // Phrases
      'angry': '😠', 'happy': '😊', 'scared': '😨', 'love': '❤️',
      'lets_meet': '🤝', 'my_name': '🗣️', 'dont_understand': '❓',
    };
    return m[word.id] ?? '📖';
  }

  String _getCurrentEmoji() {
    return _getEmojiForWord(_questions[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDark = AppTheme.isDark(context);
    final bgColor = AppTheme.gameBackground(context);
    final textColor = AppTheme.gameTextColor(context);
    final textSecondaryColor = AppTheme.gameTextSecondaryColor(context);
    final cardBgColor = AppTheme.gameCardBackground(context);
    final cardBorderColor = AppTheme.gameCardBorderColor(context);
    final progressBgColor = AppTheme.progressBackground(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: bgColor),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Игра',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_score',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _questions.length,
                  backgroundColor: progressBgColor,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.pink),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_currentIndex + 1} / ${_questions.length}',
                style: TextStyle(
                  color: textSecondaryColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              // Game content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildGameContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    switch (widget.gameMode) {
      case GameMode.chooseTranslation:
        return _buildChooseTranslation();
      case GameMode.wordScramble:
        return _buildWordScramble();
      case GameMode.trueFalse:
        return _buildTrueFalse();
    }
  }

  Widget _buildChooseTranslation() {
    final word = _questions[_currentIndex];
    final options = _generateOptions(word);
    final cardBgColor = AppTheme.gameCardBackground(context);
    final textColor = AppTheme.gameTextColor(context);
    final textSecondaryColor = AppTheme.gameTextSecondaryColor(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Удмуртское слово крупно — без картинки
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: AppColors.pink,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink.withOpacity(0.3),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                word.udmurt,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                word.transcription,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Выберите правильный перевод',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(4, (index) {
          Color bgColor = cardBgColor;
          Color textColorButton = textColor;
          Color borderColor = AppTheme.gameCardBorderColor(context);

          if (_answered) {
            if (options[index] == word.russian) {
              bgColor = AppColors.success;
              textColorButton = AppColors.white;
              borderColor = AppColors.success;
            } else if (_selectedIndex == index && !_isCorrect!) {
              bgColor = AppColors.error;
              textColorButton = AppColors.white;
              borderColor = AppColors.error;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: _answered ? null : () => _checkAnswer(index, options),
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: textColorButton,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: borderColor, width: 1),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Text(
                options[index],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        }),
      ],
    );
  }

  List<String> _generateOptions(Word correctWord) {
    final allWords = VocabularyData.words
        .where((w) => w.id != correctWord.id)
        .toList();
    allWords.shuffle(Random());
    final options = [correctWord.russian];
    for (int i = 0; i < 3 && i < allWords.length; i++) {
      options.add(allWords[i].russian);
    }
    options.shuffle(Random());
    return options;
  }

  Widget _buildWordScramble() {
    final word = _questions[_currentIndex];
    final textColor = AppTheme.gameTextColor(context);
    final textSecondaryColor = AppTheme.gameTextSecondaryColor(context);
    final cardBgColor = AppTheme.gameCardBackground(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: AppColors.pink,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _getEmojiForWord(word),
              style: const TextStyle(fontSize: 64),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Собери слово',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          word.russian,
          style: TextStyle(
            fontSize: 18,
            color: textSecondaryColor,
          ),
        ),
        const SizedBox(height: 24),
        // Answer display
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.gameCardBorderColor(context),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Text(
            _userAnswer.isEmpty ? 'Нажимай на буквы' : _userAnswer,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _userAnswer.isEmpty
                  ? textSecondaryColor
                  : AppColors.pink,
              letterSpacing: 4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        // Scrambled letters
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(_scrambledLetters.length, (index) {
            final isUsed = _userAnswer.split('').where(
              (e) => e == _scrambledLetters[index],
            ).length >=
                _scrambledLetters.indexOf(_scrambledLetters[index]) + 1;

            return GestureDetector(
              onTap: () {
                if (_userAnswer.length < _scrambledLetters.length) {
                  setState(() {
                    _userAnswer += _scrambledLetters[index];
                    if (_userAnswer.length == _scrambledLetters.length) {
                      _checkScrambleAnswer();
                    }
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isUsed
                      ? AppColors.pink.withOpacity(0.1)
                      : AppColors.pink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _scrambledLetters[index],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isUsed ? textSecondaryColor : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _userAnswer.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _userAnswer = _userAnswer.substring(
                            0, _userAnswer.length - 1);
                      });
                    },
              icon: const Icon(Icons.backspace),
              label: const Text('Стереть'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _scrambleCurrentWord(),
              icon: const Icon(Icons.shuffle),
              label: const Text('Перемешать'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lime,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _checkScrambleAnswer() {
    final correctWord = _questions[_currentIndex].udmurt;
    final isCorrect = _userAnswer == correctWord;

    if (isCorrect) {
      _score++;
      SoundService.playCorrect();
    } else {
      SoundService.playIncorrect();
    }

    // Record the result
    _results.add(QuestionResult(
      word: _questions[_currentIndex],
      isCorrect: isCorrect,
      userAnswer: _userAnswer,
      points: isCorrect ? 10 : 0,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? '✅ Правильно!' : '❌ Неправильно. Ответ: $correctWord'),
        backgroundColor: isCorrect ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    _finishQuestion();
  }

  Widget _buildTrueFalse() {
    final word = _questions[_currentIndex];
    final emoji = _getEmojiForWord(word);
    final displayedEmoji = _tfShowCorrect ? emoji : _getRandomEmoji(word);
    final textColor = AppTheme.gameTextColor(context);
    final textSecondaryColor = AppTheme.gameTextSecondaryColor(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: AppTheme.gameCardBackground(context),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.gameCardBorderColor(context),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Center(
            child: Text(
              displayedEmoji,
              style: const TextStyle(fontSize: 80),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          word.udmurt,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          word.transcription,
          style: TextStyle(
            fontSize: 16,
            color: textSecondaryColor,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Это слово соответствует картинке?',
          style: TextStyle(
            fontSize: 18,
            color: textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _tfAnswered
                    ? null
                    : () => _checkTrueFalse(true),
                icon: const Icon(Icons.check, size: 32),
                label: const Text(
                    'Верно',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tfAnswered && _tfCorrect == true
                      ? AppColors.success
                      : AppColors.success.withOpacity(0.2),
                  foregroundColor: _tfAnswered && _tfCorrect == true
                      ? Colors.white
                      : AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _tfAnswered
                    ? null
                    : () => _checkTrueFalse(false),
                icon: const Icon(Icons.close, size: 32),
                label: const Text(
                    'Не верно',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tfAnswered && _tfCorrect == false
                      ? AppColors.error
                      : AppColors.error.withOpacity(0.2),
                  foregroundColor: _tfAnswered && _tfCorrect == false
                      ? Colors.white
                      : AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getRandomEmoji(Word excludeWord) {
    final allWords = VocabularyData.words
        .where((w) => w.id != excludeWord.id)
        .toList();
    final random = Random();
    return _getEmojiForWord(allWords[random.nextInt(allWords.length)]);
  }
}

