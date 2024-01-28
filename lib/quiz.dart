import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class Question {
  final String question;
  final List<Answer> answers;

  Question({required this.question, required this.answers});
}

class Answer {
  final String answer;
  final bool correct;

  Answer({required this.answer, this.correct = false});
}

class Quiz extends StatefulWidget {
  const Quiz({
    super.key,
  });

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late List<Question> _questions;
  Question? _currentQuestion;
  int _score = 0;
  int count = 1;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  final Random _random = Random();
  final Map<Answer, Color> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final jsonStr = await DefaultAssetBundle.of(context)
        .loadString('assets/questions.json');
    final jsonData = json.decode(jsonStr);
    _questions = List<Question>.from(jsonData.map((q) {
      final answers = List<Answer>.from(q['answers'].map((a) {
        return Answer(answer: a['answer'], correct: a['correct']);
      }));
      answers.shuffle();
      return Question(
        question: q['question'],
        answers: answers,
      );
    }));
    _questions.shuffle();
    _getNextQuestion();
  }

  void _getNextQuestion() {
    if (_questions.isEmpty) {
      setState(() {
        _currentQuestion = null;
      });

      return;
    }
    final questionIndex = _random.nextInt(_questions.length);
    _currentQuestion = _questions.removeAt(questionIndex);
    setState(() {});
  }

  void _handleAnswer(Answer answer) {
    final bool isCorrect = answer.correct;
    if (isCorrect) {
      _score += 10;
      _correctAnswers++;
    } else {
      _score -= 5;
      _incorrectAnswers++;

      // Set the color of the correct answer to green
      // for (final a in _currentQuestion!.answers) {
      //   if (a.correct) {
      //     _selectedAnswers[a] = Colors.green;
      //     break;
      //   }
      // }
    }
    setState(() {
      _selectedAnswers[answer] = Colors.grey.shade500;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        count++;
        _selectedAnswers.remove(answer);
      });
      _getNextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Muslim Quiz',
        ),
      ),
      body: _currentQuestion == null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Savollar tugadi!....',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    Text('Hisob: $_score'),
                    const SizedBox(height: 8),
                    Text('To\'g\'ri javoblar: $_correctAnswers'),
                    const SizedBox(height: 8),
                    Text('Noto\'g\'ri javoblar: $_incorrectAnswers'),
                    const SizedBox(height: 8),
                    const Text(
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        'Hozirda ilova ishlab chiqilmoqda ko\'proq ma\'lumot uchun\nTelegramdagi: t.me/Muslim_Duolar kanalimizga obuna bo\'ling'),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentQuestion!.question,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("$count/10"),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: _currentQuestion!.answers
                        .map(
                          (a) => GestureDetector(
                            onTap: () {
                              _handleAnswer(a);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey.shade300,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    color: _selectedAnswers[a],
                                    child: Text(a.answer),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text('Hisob: $_score'),
                        const SizedBox(height: 8),
                        Text('To\'g\'ri javoblar: $_correctAnswers'),
                        const SizedBox(height: 8),
                        Text('Noto\'g\'ri javoblar: $_incorrectAnswers'),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
