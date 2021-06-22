import 'package:DevQuiz/challenge/challenge_page.dart';
import 'package:DevQuiz/challenge/quiz/quiz_widget.dart';
import 'package:DevQuiz/core/app_colors.dart';
import 'package:DevQuiz/home/home_controller.dart';
import 'package:DevQuiz/home/widgets/appbar/app_bar_widgets.dart';
import 'package:DevQuiz/home/widgets/elevel_button/level_button_widget.dart';
import 'package:DevQuiz/home/widgets/home_state.dart';
import 'package:DevQuiz/home/widgets/quiz_card/quiz_card_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final controller = HomeController();

  @override
  void initState() {
    super.initState();
    controller.getUser();
    controller.getQuizzes();

    controller.stateNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.state == HomeState.sucess) {
      return Scaffold(
        appBar: AppBarWidget(
          user: controller.user!,
        ),
        body: Column(children: [
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LevelButtonWiddget(label: "Fácil"),
              LevelButtonWiddget(label: "Médio"),
              LevelButtonWiddget(label: "Difícil"),
              LevelButtonWiddget(label: "Perito"),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Expanded(
              child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: controller.quizzes!
                .map((e) => QuizCartWidget(
                      title: e.title,
                      percent: e.questionAnsewred / e.question.length,
                      completed: "${e.questionAnsewred}/${e.question.length}",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChallengPage(
                                      questions: e.question,
                                      title: e.title,
                                    )));
                      },
                    ))
                .toList(),
          ))
        ]),
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
          ),
        ),
      );
    }
  }
}
