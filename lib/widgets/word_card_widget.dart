import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/word.dart';
import '../theme.dart';

class WordCardWidget extends StatefulWidget {
  final Word word;
  final VoidCallback? onLearned;

  const WordCardWidget({
    super.key,
    required this.word,
    this.onLearned,
  });

  @override
  State<WordCardWidget> createState() => _WordCardWidgetState();
}

class _WordCardWidgetState extends State<WordCardWidget> {
  bool _isFlipped = false;

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: _isFlipped ? _buildBack() : _buildFront(),
      ),
    );
  }

  Widget _buildFront() {
    final isDark = AppTheme.isDark(context);
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardBgLight;
    final cardBorder = isDark ? AppColors.cardBorder : AppColors.cardBorderLight;
    final iconBg = isDark ? const Color(0xFF2A2A2A) : AppColors.pink.withOpacity(0.1);
    final transcriptionBg = isDark ? const Color(0xFF2A2A2A) : AppColors.pink.withOpacity(0.08);
    final textColor = isDark ? AppColors.white : AppColors.textOnLight;
    final textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(_getEmoji(), style: TextStyle(fontSize: 64)),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            widget.word.udmurt,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: transcriptionBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              widget.word.transcription,
              style: TextStyle(fontSize: 16, color: textSecondary),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Нажмите, чтобы увидеть перевод',
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    final isDark = AppTheme.isDark(context);
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardBgLight;
    final cardBorder = isDark ? AppColors.cardBorder : AppColors.cardBorderLight;
    final iconBg = isDark ? const Color(0xFF2A2A2A) : AppColors.pink.withOpacity(0.1);
    final transcriptionBg = isDark ? const Color(0xFF2A2A2A) : AppColors.pink.withOpacity(0.08);
    final textColor = isDark ? AppColors.white : AppColors.textOnLight;
    final textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final buttonBg = isDark ? AppColors.white : AppColors.pink;
    final buttonText = isDark ? AppColors.black : AppColors.white;
    final learnedBg = isDark ? const Color(0xFF333333) : AppColors.pink.withOpacity(0.3);
    final learnedText = isDark ? AppColors.textSecondary : AppColors.pink;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(_getEmoji(), style: const TextStyle(fontSize: 50)),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            widget.word.russian,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.word.udmurt,
            style: TextStyle(
              fontSize: 20,
              color: textColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: transcriptionBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              widget.word.transcription,
              style: TextStyle(fontSize: 15, color: textSecondary),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: widget.onLearned,
            icon: Icon(
              widget.onLearned != null ? Icons.check_circle : Icons.check_circle_outline,
              color: widget.onLearned != null ? null : learnedText,
            ),
            label: Text(
              widget.onLearned != null ? 'Изучил! +10 XP' : 'Изучено',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.onLearned != null ? buttonBg : learnedBg,
              foregroundColor: widget.onLearned != null ? buttonText : learnedText,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: widget.onLearned != null ? 4 : 0,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Нажмите, чтобы вернуться',
            style: TextStyle(fontSize: 12, color: textSecondary),
          ),
        ],
      ),
    );
  }

  String _getEmoji() {
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
    return m[widget.word.id] ?? '📖';
  }
}
