import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../constants.dart';
import '../data/vocabulary.dart';
import '../models/word.dart';
import '../providers/auth_provider.dart';
import '../services/sound_service.dart';

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
  bool _answered = false;
  bool? _isCorrect;
  int? _selectedIndex;
  List<String> _scrambledLetters = [];
  String _userAnswer = '';
  bool _tfAnswered = false;
  bool? _tfCorrect;

  @override
  void initState() {
    super.initState();
    _generateQuestions();
    if (widget.gameMode == GameMode.wordScramble) {
      _scrambleCurrentWord();
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
      if (isCorrect) {
        _score++;
        SoundService.playCorrect();
      } else {
        SoundService.playIncorrect();
      }
    });

    _finishQuestion();
  }

  void _checkTrueFalse(bool userSaysTrue) {
    if (_tfAnswered) return;
    final word = _questions[_currentIndex];
    final isActuallyTrue = _getEmojiForWord(word) == _getCurrentEmoji();

    setState(() {
      _tfAnswered = true;
      _tfCorrect = userSaysTrue == isActuallyTrue;
      if (_tfCorrect!) {
        _score++;
        SoundService.playCorrect();
      } else {
        SoundService.playIncorrect();
      }
    });

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
          _tfAnswered = false;
          _tfCorrect = null;
        });
        if (widget.gameMode == GameMode.wordScramble) {
          _scrambleCurrentWord();
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Text(
              _score == _questions.length ? '🏆' : _score >= 7 ? '🎉' : '💪',
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            const Text(
              'Результат',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_score из ${_questions.length}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '+${_score * 10} XP',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.pink,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('К играм'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _answered = false;
                _isCorrect = null;
                _selectedIndex = null;
                _tfAnswered = false;
                _tfCorrect = null;
              });
              _generateQuestions();
              if (widget.gameMode == GameMode.wordScramble) {
                _scrambleCurrentWord();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ещё раз'),
          ),
        ],
      ),
    );
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
      'hello': '🤝', 'goodbye': '👋', 'thank_you': '🙏', 'please': '🤲',
      'how_are_you': '😊', 'good_morning': '🌅', 'good_night': '🌙', 'nice_to_meet': '😃',
      'one': '1️⃣', 'two': '2️⃣', 'three': '3️⃣', 'four': '4️⃣', 'five': '5️⃣',
      'six': '6️⃣', 'seven': '7️⃣', 'eight': '8️⃣', 'nine': '9️⃣', 'ten': '🔟',
      'bear': '🐻', 'wolf': '🐺', 'fox': '🦊', 'hare': '🐇', 'moose': '🦌',
      'squirrel': '🐿️', 'hedgehog': '🦔', 'eagle': '🦅',
      'cow': '🐄', 'horse': '🐴', 'sheep': '🐑', 'pig': '🐖', 'chicken': '🐓',
      'dog': '🐕', 'cat': '🐈', 'goose': '🪿',
      'mother': '👩', 'father': '👨', 'sister': '👧', 'brother': '👦',
      'grandmother': '👵', 'grandfather': '👴', 'son': '🧒', 'daughter': '👧',
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

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.black),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Игра',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
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
                  backgroundColor: Colors.white,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.pink),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_currentIndex + 1} / ${_questions.length}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
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
        const Text(
          'Выберите правильный перевод',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(4, (index) {
          Color bgColor = AppColors.cardDark;
          Color textColor = AppColors.white;

          if (_answered) {
            if (options[index] == word.russian) {
              bgColor = AppColors.success;
              textColor = AppColors.black;
            } else if (_selectedIndex == index && !_isCorrect!) {
              bgColor = AppColors.error;
              textColor = AppColors.black;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: _answered ? null : () => _checkAnswer(index, options),
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: textColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
        const Text(
          'Собери слово',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          word.russian,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        // Answer display
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                  ? AppColors.textSecondary
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
                      color: isUsed ? AppColors.textSecondary : Colors.white,
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
    final emoji = _getCurrentEmoji();
    // Randomly decide if the displayed emoji matches the word
    final random = Random();
    final showCorrectEmoji = random.nextBool();
    final displayedEmoji = showCorrectEmoji ? emoji : _getRandomEmoji(word);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
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
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          word.transcription,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Это слово соответствует картинке?',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textSecondary,
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
                label: const Text('Верно',
                    style: TextStyle(fontSize: 20)),
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
                label: const Text('Не верно',
                    style: TextStyle(fontSize: 20)),
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

