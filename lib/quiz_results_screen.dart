import 'package:flutter/material.dart';

class QuizResultsScreen extends StatelessWidget {
  final Map<String, dynamic> quiz;

  const QuizResultsScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final title = quiz['title'] as String? ?? 'Quiz';
    final score = quiz['score'] as int? ?? 0;
    final totalPossible = quiz['totalPossible'] as int? ?? 0;
    final correctCount = quiz['correctCount'] as int? ?? 0;
    final totalQuestions = quiz['totalQuestions'] as int? ?? 0;
    final answers = quiz['answers'] as Map<String, dynamic>? ?? {};
    final questions = (quiz['questions'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blue.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Skor Akhir: $score / $totalPossible',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Benar: $correctCount / $totalQuestions',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Anda telah menyelesaikan kuis ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Review Jawaban',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Questions review
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            final questionText = question['question'] as String? ?? 'Question';
            final options = question['options'] as Map<String, dynamic>? ?? {};
            final correctAnswer = question['correctAnswer'] as String?;
            final selectedAnswer = answers[index.toString()] as String?;
            final isCorrect = selectedAnswer == correctAnswer;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Soal ${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(questionText),
                    const SizedBox(height: 16),
                    ...['A', 'B', 'C', 'D'].map((option) {
                      final optionText = options[option] as String? ?? '';
                      final isSelected = selectedAnswer == option;
                      final isCorrectOption = correctAnswer == option;
                      Color? bgColor;
                      if (isSelected && isCorrectOption) {
                        bgColor = Colors.green.shade100;
                      } else if (isSelected && !isCorrectOption) {
                        bgColor = Colors.red.shade100;
                      } else if (isCorrectOption) {
                        bgColor = Colors.green.shade100;
                      }
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text('$option. $optionText'),
                            if (isSelected) const Text(' (Dipilih)'),
                            if (isCorrectOption && !isSelected) const Text(' (Benar)'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Kembali ke Tugas & Kuis',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}