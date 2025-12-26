import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class CreateKuisScreen extends StatefulWidget {
  CreateKuisScreen({super.key});

  @override
  CreateKuisScreenState createState() => CreateKuisScreenState();
}

class CreateKuisScreenState extends State<CreateKuisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDeadline;
  final List<Question> _questions = [Question()];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _addQuestion() {
    setState(() {
      _questions.add(Question());
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length > 1) {
      setState(() {
        _questions[index].dispose();
        _questions.removeAt(index);
      });
    }
  }

  bool get _canSave => _titleController.text.isNotEmpty && _selectedDeadline != null && _questions.every((q) => q.isValid());

  void _saveKuis() {
    if (_formKey.currentState?.validate() ?? false) {
      final quiz = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': 'Quiz',
        'title': _titleController.text,
        'description': _descriptionController.text,
        'deadline': '${_selectedDeadline!.year}-${_selectedDeadline!.month.toString().padLeft(2, '0')}-${_selectedDeadline!.day.toString().padLeft(2, '0')} ${_selectedDeadline!.hour.toString().padLeft(2, '0')}:${_selectedDeadline!.minute.toString().padLeft(2, '0')}',
        'questions': _questions.map((q) => q.toMap()).toList(),
        'isCompleted': false,
      };
      Provider.of<User>(context, listen: false).addTask(quiz);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Kuis'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // General Info
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Kuis',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul kuis wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Kuis (Opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectDeadline,
                child: Text(
                  _selectedDeadline == null
                      ? 'Pilih Deadline'
                      : 'Deadline: ${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year} ${_selectedDeadline!.hour}:${_selectedDeadline!.minute.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Soal Kuis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Questions
              ..._questions.asMap().entries.map((entry) {
                int index = entry.key;
                Question q = entry.value;
                return QuestionWidget(
                  question: q,
                  questionNumber: index + 1,
                  onRemove: _questions.length > 1 ? () => _removeQuestion(index) : null,
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Soal'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _canSave ? _saveKuis : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('SIMPAN', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionAController = TextEditingController();
  final TextEditingController optionBController = TextEditingController();
  final TextEditingController optionCController = TextEditingController();
  final TextEditingController optionDController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  String? correctAnswer;

  void dispose() {
    questionController.dispose();
    optionAController.dispose();
    optionBController.dispose();
    optionCController.dispose();
    optionDController.dispose();
    pointsController.dispose();
  }

  bool isValid() {
    return questionController.text.isNotEmpty &&
           optionAController.text.isNotEmpty &&
           optionBController.text.isNotEmpty &&
           optionCController.text.isNotEmpty &&
           optionDController.text.isNotEmpty &&
           correctAnswer != null &&
           pointsController.text.isNotEmpty &&
           int.tryParse(pointsController.text) != null;
  }

  Map<String, dynamic> toMap() {
    return {
      'question': questionController.text,
      'options': {
        'A': optionAController.text,
        'B': optionBController.text,
        'C': optionCController.text,
        'D': optionDController.text,
      },
      'correctAnswer': correctAnswer,
      'points': int.parse(pointsController.text),
    };
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final VoidCallback? onRemove;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    this.onRemove,
  });

  @override
  QuestionWidgetState createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Soal ${widget.questionNumber}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (widget.onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.question.questionController,
              decoration: const InputDecoration(
                labelText: 'Pertanyaan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pertanyaan wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Opsi Jawaban:'),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.question.optionAController,
              decoration: const InputDecoration(
                labelText: 'Opsi A',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Opsi A wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.question.optionBController,
              decoration: const InputDecoration(
                labelText: 'Opsi B',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Opsi B wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.question.optionCController,
              decoration: const InputDecoration(
                labelText: 'Opsi C',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Opsi C wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.question.optionDController,
              decoration: const InputDecoration(
                labelText: 'Opsi D',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Opsi D wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Kunci Jawaban:'),
            DropdownButtonFormField<String>(
              initialValue: widget.question.correctAnswer,
              items: ['A', 'B', 'C', 'D'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  widget.question.correctAnswer = newValue;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Kunci jawaban wajib dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.question.pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Poin Soal',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Poin soal wajib diisi';
                }
                if (int.tryParse(value) == null) {
                  return 'Poin harus berupa angka';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}