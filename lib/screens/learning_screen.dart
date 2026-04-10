import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../data/vocabulary.dart';
import '../models/word.dart';
import '../providers/auth_provider.dart';
import '../widgets/word_card_widget.dart';
import '../theme.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundColor(context),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'Обучение',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor(context),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: VocabularyData.topics.length,
                itemBuilder: (context, index) {
                  final topic = VocabularyData.topics[index];
                  return _TopicCard(topic: topic);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final Topic topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TopicWordsScreen(topic: topic),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder(context)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(topic.icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    topic.titleUdmurt,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.pink,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${topic.wordIds.length} слов',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.pink, size: 24),
          ],
        ),
      ),
    );
  }
}

class TopicWordsScreen extends StatefulWidget {
  final Topic topic;

  const TopicWordsScreen({super.key, required this.topic});

  @override
  State<TopicWordsScreen> createState() => _TopicWordsScreenState();
}

class _TopicWordsScreenState extends State<TopicWordsScreen> {
  late List<Word> _words;
  int _currentIndex = 0;
  bool _isLearned = false;
  int _sessionLearnedCount = 0;
  Set<String> _learnedWordIds = {};

  @override
  void initState() {
    super.initState();
    _words = VocabularyData.words
        .where((w) => w.topicId == widget.topic.id)
        .toList();
  }

  void _nextWord() {
    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
        _isLearned = _learnedWordIds.contains(_words[_currentIndex].id);
      });
    }
  }

  void _prevWord() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isLearned = _learnedWordIds.contains(_words[_currentIndex].id);
      });
    }
  }

  void _markLearned() {
    if (_isLearned) return;
    
    // Add to learned set
    _learnedWordIds.add(_words[_currentIndex].id);
    
    setState(() {
      _isLearned = true;
      _sessionLearnedCount++;
    });
    
    context.read<AuthProvider>().markWordLearned(widget.topic.id);
    context.read<AuthProvider>().addXP(10);
    
    // Show notification from top with animation
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: -1.0, end: 0.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value * 100),
                child: Opacity(
                  opacity: value < -0.5 ? (value + 1) * 2 : 1.0,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    '+10 XP! Слово изучено!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    
    // Auto-dismiss after 2 seconds with fade out
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.markNeedsBuild();
      Future.delayed(const Duration(milliseconds: 300), () {
        overlayEntry.remove();
      });
    });

    // Check if all words are learned in current session
    if (_sessionLearnedCount >= _words.length) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showCompletionDialog();
        }
      });
    }
  }

  void _showCompletionDialog() {
    final totalWords = _words.length;
    final dialogBg = AppTheme.dialogBackground(context);
    final textColor = AppTheme.gameTextColor(context);
    final textSecondaryColor = AppTheme.gameTextSecondaryColor(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: dialogBg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with celebration - full width pink background
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.pink,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '🎓',
                        style: TextStyle(fontSize: 72),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Поздравляем!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ты изучил все слова по теме',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"${widget.topic.title}"',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Stats section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          '📚',
                          '$totalWords',
                          'Всего слов',
                          textColor,
                          textSecondaryColor,
                        ),
                        _buildStatCard(
                          '✅',
                          '$totalWords',
                          'Изучено',
                          textColor,
                          textSecondaryColor,
                        ),
                        _buildStatCard(
                          '⭐',
                          '+${totalWords * 10}',
                          'XP получено',
                          textColor,
                          textSecondaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: AppColors.success,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Отличная работа! Ты стал ближе к изучению удмуртского языка!',
                              style: TextStyle(
                                fontSize: 14,
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                          'ВЫЙТИ',
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
                          _resetProgress();
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
                          'ПОВТОРИТЬ',
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

  Widget _buildStatCard(
    String emoji,
    String value,
    String label,
    Color textColor,
    Color textSecondaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.pink.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _resetProgress() {
    setState(() {
      _currentIndex = 0;
      _isLearned = false;
      _sessionLearnedCount = 0;
      _learnedWordIds = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = _words[_currentIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.backgroundColor(context),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.textColor(context)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.topic.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor(context),
                            ),
                          ),
                          Text(
                            '${_currentIndex + 1} / ${_words.length}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _words.length,
                  backgroundColor: AppTheme.progressBackground(context),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.pink),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: WordCardWidget(
                    key: ValueKey(currentWord.id),
                    word: currentWord,
                    onLearned: _isLearned ? null : _markLearned,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _currentIndex > 0 ? _prevWord : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Назад'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.cardBackground(context),
                          foregroundColor: AppColors.pink,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: AppColors.pink),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _currentIndex < _words.length - 1
                            ? _nextWord
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Далее'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
}
