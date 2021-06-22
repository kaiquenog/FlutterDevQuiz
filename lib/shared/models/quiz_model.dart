import 'dart:convert';

import 'package:DevQuiz/shared/models/question_model.dart';

enum Level { facil, medio, dificil, perito }

extension LevelSrtringExt on String {
  Level get parse => {
        "facil": Level.facil,
        "medio": Level.medio,
        "dificil": Level.dificil,
        "perito": Level.perito,
      }[this]!;
}

extension LevelExt on Level {
  String? get parse {
    switch (this) {
      case Level.facil:
        return 'facil';
      case Level.medio:
        return 'medio';
      case Level.dificil:
        return 'dificil';
      case Level.perito:
        return 'perito';
      default:
        return null;
    }
  }
}

class QuizModel {
  final String title;
  final List<QuestionModel> question;
  final int questionAnsewred;
  final String imagem;
  final Level level;

  QuizModel({
    required this.title,
    required this.question,
    this.questionAnsewred = 0,
    required this.imagem,
    required this.level,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'question': question.map((x) => x.toMap()).toList(),
      'questionAnsewred': questionAnsewred,
      'imagem': imagem,
      'level': level.parse,
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      title: map['title'],
      question: List<QuestionModel>.from(
          map['question']?.map((x) => QuestionModel.fromMap(x))),
      questionAnsewred: map['questionAnsewred'] ?? 0,
      imagem: map['imagem'],
      level: map['level'].toString().parse,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizModel.fromJson(String source) =>
      QuizModel.fromMap(json.decode(source));
}
