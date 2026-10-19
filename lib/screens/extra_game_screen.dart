import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../data/vocabulary.dart';
import '../models/word.dart';
import '../providers/auth_provider.dart';
import '../services/sound_service.dart';
import '../theme.dart';

enum ExtraGameMode { findOdd, sortWords, memoryPairs }

class ExtraGameScreen extends StatefulWidget {
  final ExtraGameMode mode;

  const ExtraGameScreen({super.key, required this.mode});

  @override
  State<ExtraGameScreen> createState() => _ExtraGameScreenState();
}

class _ExtraGameScreenState extends State<ExtraGameScreen> {
  static const _roundCount = 8;
  static const _pairCount = 4;

  final _random = Random();
  List<Word> _words = [];
  List<Word> _oddWords = [];
  List<_MemoryCard> _memoryCards = [];
  Topic? _firstTopic;
  Topic? _secondTopic;
  int _oddIndex = 0;
  int _round = 0;
  int _score = 0;
  int? _oddAnswer;
  Word? _selectedWord;
  final Set<String> _sortedWordIds = {};
  final Set<int> _openCards = {};
  final Set<int> _matchedCards = {};
  bool _checkingPair = false;
  bool _finished = false;

  String get _title => switch (widget.mode) {
    ExtraGameMode.findOdd => 'Найди лишнее слово',
    ExtraGameMode.sortWords => 'Распредели по темам',
    ExtraGameMode.memoryPairs => 'Найди пару',
  };

  @override
  void initState() {
    super.initState();
    switch (widget.mode) {
      case ExtraGameMode.findOdd:
        _prepareOddQuestion();
        break;
      case ExtraGameMode.sortWords:
        _prepareSortingRound();
        break;
      case ExtraGameMode.memoryPairs:
        _prepareMemoryCards();
        break;
    }
  }

  List<Topic> _topicsWithEnoughWords() {
    return VocabularyData.topics
        .where((topic) => topic.wordIds.length >= 4)
        .toList();
  }

  List<Word> _wordsIn(Topic topic) {
    return VocabularyData.words
        .where((word) => word.topicId == topic.id)
        .toList();
  }

  List<Topic> _chooseTwoTopics() {
    final topics = _topicsWithEnoughWords()..shuffle(_random);
    return topics.take(2).toList();
  }

  void _prepareOddQuestion() {
    final topics = _chooseTwoTopics();
    final commonWords = _wordsIn(topics[0])..shuffle(_random);
    final oddWords = _wordsIn(topics[1])..shuffle(_random);
    _oddWords = [...commonWords.take(3), oddWords.first]..shuffle(_random);
    _oddIndex = _oddWords.indexWhere((word) => word.topicId == topics[1].id);
    _oddAnswer = null;
  }

  void _answerOddWord(int index) {
    if (_oddAnswer != null) return;
    final isCorrect = index == _oddIndex;
    setState(() {
      _oddAnswer = index;
      if (isCorrect) _score++;
    });
    if (isCorrect) {
      SoundService.playCorrect();
    } else {
      SoundService.playIncorrect();
    }
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      if (_round + 1 == _roundCount) {
        _finishGame();
        return;
      }
      setState(() {
        _round++;
        _prepareOddQuestion();
      });
    });
  }

  void _prepareSortingRound() {
    final topics = _chooseTwoTopics();
    _firstTopic = topics[0];
    _secondTopic = topics[1];
    final firstWords = _wordsIn(_firstTopic!)..shuffle(_random);
    final secondWords = _wordsIn(_secondTopic!)..shuffle(_random);
    _words = [...firstWords.take(4), ...secondWords.take(4)]..shuffle(_random);
    _sortedWordIds.clear();
    _selectedWord = null;
  }

  void _sortWord(Word word, Topic topic) {
    if (_sortedWordIds.contains(word.id)) return;
    final isCorrect = word.topicId == topic.id;
    setState(() {
      _sortedWordIds.add(word.id);
      _selectedWord = null;
      if (isCorrect) _score++;
    });
    if (isCorrect) {
      SoundService.playCorrect();
    } else {
      SoundService.playIncorrect();
    }
    if (_sortedWordIds.length == _words.length) {
      Future.delayed(const Duration(milliseconds: 500), _finishGame);
    }
  }

  void _prepareMemoryCards() {
    final words = List<Word>.from(VocabularyData.words)..shuffle(_random);
    _memoryCards = [
      for (final word in words.take(_pairCount)) ...[
        _MemoryCard(pairId: word.id, label: word.udmurt),
        _MemoryCard(pairId: word.id, label: word.russian),
      ],
    ]..shuffle(_random);
    _openCards.clear();
    _matchedCards.clear();
    _checkingPair = false;
  }

  void _openMemoryCard(int index) {
    if (_checkingPair ||
        _matchedCards.contains(index) ||
        _openCards.contains(index)) {
      return;
    }
    setState(() => _openCards.add(index));
    if (_openCards.length != 2) return;

    final opened = _openCards.toList();
    final isMatch =
        _memoryCards[opened[0]].pairId == _memoryCards[opened[1]].pairId;
    if (isMatch) {
      setState(() {
        _matchedCards.addAll(opened);
        _openCards.clear();
        _score++;
      });
      SoundService.playCorrect();
      if (_matchedCards.length == _memoryCards.length) {
        Future.delayed(const Duration(milliseconds: 500), _finishGame);
      }
      return;
    }

    _checkingPair = true;
    SoundService.playIncorrect();
    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _openCards.clear();
        _checkingPair = false;
      });
    });
  }

  Future<void> _finishGame() async {
    if (_finished || !mounted) return;
    _finished = true;
    final total = widget.mode == ExtraGameMode.memoryPairs
        ? _pairCount
        : widget.mode == ExtraGameMode.findOdd
        ? _roundCount
        : _words.length;
    final gameType = switch (widget.mode) {
      ExtraGameMode.findOdd => 'find_odd_word',
      ExtraGameMode.sortWords => 'sort_words',
      ExtraGameMode.memoryPairs => 'memory_pairs',
    };
    final auth = context.read<AuthProvider>();
    await auth.addXP(_score * 10);
    await auth.updateGameStats(gameType, _score, total);
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          _score == total ? Icons.emoji_events_rounded : Icons.stars_rounded,
          color: AppColors.accent,
          size: 44,
        ),
        title: const Text('Игра завершена'),
        content: Text('Правильных ответов: $_score из $total'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Готово'),
          ),
        ],
      ),
    );
  }

  double get _progress {
    return switch (widget.mode) {
      ExtraGameMode.findOdd =>
        (_round + (_oddAnswer == null ? 0 : 1)) / _roundCount,
      ExtraGameMode.sortWords => _sortedWordIds.length / _words.length,
      ExtraGameMode.memoryPairs => _matchedCards.length / _memoryCards.length,
    };
  }

  String get _progressLabel => switch (widget.mode) {
    ExtraGameMode.findOdd => '${_round + 1} / $_roundCount',
    ExtraGameMode.sortWords =>
      '${_sortedWordIds.length} / ${_words.length} слов',
    ExtraGameMode.memoryPairs =>
      '${_matchedCards.length ~/ 2} / $_pairCount пар',
  };

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.textColor(context);
    final secondaryColor = AppTheme.textSecondary(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        leading: IconButton(
          tooltip: 'Назад',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '$_score',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: _progress,
                minHeight: 5,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: AppTheme.progressBackground(context),
                color: AppColors.primary,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _progressLabel,
                  style: TextStyle(color: secondaryColor, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: switch (widget.mode) {
                  ExtraGameMode.findOdd => _buildFindOdd(
                    textColor,
                    secondaryColor,
                  ),
                  ExtraGameMode.sortWords => _buildSorting(
                    textColor,
                    secondaryColor,
                  ),
                  ExtraGameMode.memoryPairs => _buildMemory(
                    textColor,
                    secondaryColor,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFindOdd(Color textColor, Color secondaryColor) {
    return Column(
      children: [
        Text(
          'Какое слово из другой темы?',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        Expanded(
          child: GridView.builder(
            itemCount: _oddWords.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final word = _oddWords[index];
              final isRevealed = _oddAnswer != null;
              final translationSize = isRevealed ? 16.0 : 0.0;
              final isOddCard = _oddIndex == index;
              final isChosen = _oddAnswer == index;
              final color = isOddCard && isChosen || isOddCard && isRevealed
                  ? AppColors.success
                  : !isOddCard && isChosen
                  ? AppColors.error
                  : AppTheme.cardBorder(context);
              return InkWell(
                onTap: () => _answerOddWord(index),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground(context),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: color, width: 1.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        word.udmurt,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        word.russian,
                        style: TextStyle(color: secondaryColor, fontSize: translationSize),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSorting(Color textColor, Color secondaryColor) {
    return Column(
      children: [
        Text(
          _selectedWord == null
              ? 'Перетащи слово в подходящую группу'
              : 'Выбрано: ${_selectedWord!.udmurt}',
          style: TextStyle(
            color: _selectedWord == null ? secondaryColor : textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 3,
          child: GridView.builder(
            itemCount: _words.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.1,
            ),
            itemBuilder: (context, index) {
              final word = _words[index];
              if (_sortedWordIds.contains(word.id)) {
                return const SizedBox.shrink();
              }
              return Draggable<Word>(
                data: word,
                feedback: Material(
                  color: Colors.transparent,
                  child: _sortWordCard(word, textColor, width: 150),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.25,
                  child: _sortWordCard(word, textColor),
                ),
                child: InkWell(
                  onTap: () => setState(
                    () => _selectedWord = _selectedWord?.id == word.id
                        ? null
                        : word,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: _sortWordCard(
                    word,
                    textColor,
                    selected: _selectedWord?.id == word.id,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: _buildSortTarget(
                  _firstTopic!,
                  textColor,
                  secondaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSortTarget(
                  _secondTopic!,
                  textColor,
                  secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sortWordCard(
    Word word,
    Color textColor, {
    double? width,
    bool selected = false,
  }) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? AppTheme.iconBackground(context)
            : AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.primary : AppTheme.cardBorder(context),
        ),
      ),
      child: Text(
        word.udmurt,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSortTarget(Topic topic, Color textColor, Color secondaryColor) {
    final count = _sortedWordIds
        .where(
          (id) =>
              _words.any((word) => word.id == id && word.topicId == topic.id),
        )
        .length;
    return DragTarget<Word>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) => _sortWord(details.data, topic),
      builder: (context, candidates, rejected) {
        final highlighted =
            candidates.isNotEmpty ||
            (_selectedWord != null && _selectedWord!.topicId == topic.id);
        return InkWell(
          onTap: _selectedWord == null
              ? null
              : () => _sortWord(_selectedWord!, topic),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: highlighted
                  ? AppTheme.iconBackground(context)
                  : AppTheme.cardBackground(context),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: highlighted
                    ? AppColors.primary
                    : AppTheme.cardBorder(context),
                width: highlighted ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(topic.icon, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 6),
                Text(
                  topic.title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$count из 4',
                  style: TextStyle(color: secondaryColor, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMemory(Color textColor, Color secondaryColor) {
    return GridView.builder(
      itemCount: _memoryCards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final card = _memoryCards[index];
        final isOpen =
            _openCards.contains(index) || _matchedCards.contains(index);
        final isMatched = _matchedCards.contains(index);
        return InkWell(
          onTap: () => _openMemoryCard(index),
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isMatched
                  ? AppColors.success.withValues(alpha: 0.14)
                  : isOpen
                  ? AppTheme.iconBackground(context)
                  : AppTheme.cardBackground(context),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isMatched
                    ? AppColors.success
                    : isOpen
                    ? AppColors.primary
                    : AppTheme.cardBorder(context),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                isOpen ? card.label : '?',
                style: TextStyle(
                  color: isMatched ? AppColors.success : textColor,
                  fontSize: isOpen ? 17 : 32,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MemoryCard {
  final String pairId;
  final String label;

  const _MemoryCard({required this.pairId, required this.label});
}
