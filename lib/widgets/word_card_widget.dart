import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/word.dart';

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(_getEmoji(), style: const TextStyle(fontSize: 64)),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            widget.word.udmurt,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              widget.word.transcription,
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Нажмите, чтобы увидеть перевод',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(_getEmoji(), style: const TextStyle(fontSize: 50)),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            widget.word.russian,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.word.udmurt,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              widget.word.transcription,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: widget.onLearned,
            icon: Icon(widget.onLearned != null ? Icons.check_circle : Icons.check),
            label: Text(widget.onLearned != null ? 'Изучил! +10 XP' : '✓ Изучено'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.onLearned != null ? AppColors.white : const Color(0xFF333333),
              foregroundColor: widget.onLearned != null ? AppColors.black : AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Нажмите, чтобы вернуться',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _getEmoji() {
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
    return m[widget.word.id] ?? '📖';
  }
}
