import 'package:DevQuiz/challenge/challenge_controller.dart';
import 'package:DevQuiz/challenge/quiz/quiz_widget.dart';
import 'package:DevQuiz/challenge/widgets/next_button/next_button_widget.dart';
import 'package:DevQuiz/challenge/widgets/question_indicator/question_indicator_widget.dart';
import 'package:DevQuiz/result/result_page.dart';
import 'package:DevQuiz/shared/models/question_model.dart';
import 'package:flutter/material.dart';

class ChallengPage extends StatefulWidget {
  final List<QuestionModel> questions;
  final String title;

  const ChallengPage({
    Key? key,
    required this.questions,
    required this.title,
  }) : super(key: key);

  @override
  _ChallengPage createState() => _ChallengPage();
}

class _ChallengPage extends State<ChallengPage> {
  final controller = ChangeController();
  final pageController = PageController();

  @override
  void initState() {
    pageController.addListener(() {
      controller.currentPage = pageController.page!.toInt() + 1;
    });
    super.initState();
  }

  void nextPage() {
    if (controller.currentPage < widget.questions.length)
      pageController.nextPage(
          duration: Duration(milliseconds: 100), curve: Curves.linear);
  }

  void onSelected(bool value) {
    if (value == true) {
      controller.qtdAcertos++;
    }

    nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(86),
        child: SafeArea(
          top: true,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BackButton(),
            ValueListenableBuilder<int>(
                valueListenable: controller.currentPageNotifier,
                builder: (context, value, _) => QuestionIndicatorWidget(
                      currentPage: value,
                      lenght: widget.questions.length,
                    )),
          ]),
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: widget.questions
            .map((e) => QuizWidget(
                  question: e,
                  onSelected: onSelected,
                ))
            .toList(),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder<int>(
                valueListenable: controller.currentPageNotifier,
                builder: (context, value, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (value != widget.questions.length)
                          Expanded(
                              child: NextButtonWidget.white(
                            label: "Pular",
                            onTap: () {
                              pageController.nextPage(
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.linear);
                            },
                          )),
                        if (value == widget.questions.length)
                          SizedBox(
                            width: 7,
                          ),
                        Expanded(
                            child: NextButtonWidget.green(
                          label: "Confirmar",
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultPage(
                                          title: widget.title,
                                          length: widget.questions.length,
                                          result: controller.qtdAcertos,
                                        )));
                          },
                        ))
                      ],
                    ))),
      ),
    );
  }
}
