import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class TakeQuizScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;

  const TakeQuizScreen({super.key, required this.quiz});

  @override
  TakeQuizScreenState createState() => TakeQuizScreenState();
}

class TakeQuizScreenState extends State<TakeQuizScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Map<int, String?> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _getQuestions().length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishQuiz() {
    final questions = _getQuestions();
    int totalScore = 0;
    int totalPossible = 0;
    int correctCount = 0;

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final correctAnswer = question['correctAnswer'] as String?;
      final points = question['points'] as int? ?? 0;
      final selectedAnswer = _selectedAnswers[i];

      totalPossible += points;
      if (selectedAnswer == correctAnswer) {
        totalScore += points;
        correctCount++;
      }
    }

    // Mark quiz as completed with results
    final updatedQuiz = Map<String, dynamic>.from(widget.quiz);
    updatedQuiz['isCompleted'] = true;
    updatedQuiz['answers'] = _selectedAnswers.map((key, value) => MapEntry(key.toString(), value));
    updatedQuiz['score'] = totalScore;
    updatedQuiz['totalPossible'] = totalPossible;
    updatedQuiz['correctCount'] = correctCount;
    updatedQuiz['totalQuestions'] = questions.length;

    // Update in provider
    final user = Provider.of<User>(context, listen: false);
    final index = user.tasks.indexWhere((t) => t['id'] == widget.quiz['id']);
    if (index != -1) {
      user.tasks[index] = updatedQuiz;
      user.notifyListeners();
    }
    Navigator.pop(context);
  }

  List<Map<String, dynamic>> _getQuestions() {
    return (widget.quiz['questions'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    final questions = _getQuestions();
    final title = widget.quiz['title'] as String? ?? 'Quiz';
    final deadline = widget.quiz['deadline'] as String? ?? 'No Deadline';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kerjakan Kuis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade300],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blue.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Deadline: $deadline',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Questions
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final questionText = question['question'] as String? ?? 'Question';
                final options = question['options'] as Map<String, dynamic>? ?? {};
                final selectedAnswer = _selectedAnswers[index];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Soal ${index + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        questionText,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ...['A', 'B', 'C', 'D'].map((option) {
                        final optionText = options[option] as String? ?? '';
                        return RadioListTile<String>(
                          title: Text('$option. $optionText'),
                          value: option,
                          groupValue: selectedAnswer,
                          onChanged: (value) {
                            setState(() {
                              _selectedAnswers[index] = value;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
          // Navigation
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 120),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade900, Colors.blue.shade300],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _previousPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Sebelumnya',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 120),
                  Text(
                    '${_currentPage + 1}/${questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (_currentPage < questions.length - 1)
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 120),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade900, Colors.blue.shade300],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Flexible(
                                child: Text(
                                  'Selanjutnya',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 120),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade800, Colors.blue.shade400],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _finishQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Selesai',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}