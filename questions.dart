import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class SurveyQuestion {
  final String question;
  final List<String> options;
  final List<String> emojis;
  final String imagePath;

  SurveyQuestion(this.question, this.options, this.emojis, this.imagePath);
}

class SleepSurveyBundle extends StatefulWidget {
  const SleepSurveyBundle({super.key});

  @override
  SleepSurveyBundleState createState() => SleepSurveyBundleState();
}

class SleepSurveyBundleState extends State<SleepSurveyBundle> {
  final PageController _controller = PageController();
  double progress = 0.0; // Current fill percentage: 0.0 to 1.0
  Map<String, String> surveyAnswers = {};

  int currentQuestion = 0;

  final List<SurveyQuestion> questions = [
    SurveyQuestion(
      "On average, how many hours do you sleep each night?",
      ["Less than 5 hours", "5–6 hours", "7–8 hours", "9 or more hours"],
      ["😪", "😟", "😌", "🤔"],
      "assets/img_Q1.png"
    ),
    SurveyQuestion(
      "How many hours do you spend on productive activities (work, studies, etc.) during a typical weekday?",
      ["Less than 2 hours", "2-4 hours", "5-7 hours", "8 or more hours"],
      ["😪", "🙂", "😄", "🤯"],
        "assets/img_Q2.png"
    ),
    SurveyQuestion(
      "How many hours do you have available for free time and leisure activities during a typical weekday?",
      ["Less than 2 hours", "2-4 hours", "more than 5 hours"],
      ["🤏", "🙂", "😎"],
        "assets/img_Q3.png"
    ),
    SurveyQuestion(
      "How often do you feel rested and energized after a night's sleep?",
      ["Rarely or never", "Occasionally", "Most of the time", "Almost always"],
      ["😪", "😔", "😄", "🤩"],
        "assets/img_Q4.png"
    ),
    SurveyQuestion(
      "How well do you manage your time and prioritize tasks?",
      ["Very poorly", "Somewhat poorly", "Fairly well", "Very well"],
      ["😵", "🤔", "🙂", "😎"],
        "assets/img_Q5.png"
    ),
  ];

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/survey_answers.json');
  }

  Future<void> saveAnswer(int index, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('question_$index', answer);
  }

  void nextQuestion(String answer) async {
    await saveAnswer(currentQuestion, answer);
    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // All questions done
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Survey completed!")));
    }
  }

  Widget buildOption(String text, String emoji, int index) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          progress = (currentQuestion + 1) / questions.length;
          surveyAnswers[questions[currentQuestion].question] = text;
        });

        final file = await _localFile;
        await file.writeAsString(jsonEncode(surveyAnswers));

        Future.delayed(const Duration(milliseconds: 500), () {
          if (currentQuestion < questions.length - 1) {
            setState(() {
              currentQuestion++;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Survey completed and saved to JSON!")),
            );
          }
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.orange.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 15)),
            Text(emoji, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFFFBDF5A), // yellow background for entire screen
      body: Column(
        children: [
          // ✅ Top white area with rounded bottom that holds the image (1/6 of screen)
          SizedBox(
            height: MediaQuery.of(context).size.height *2/ 7,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Image.asset(
                  question.imagePath,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ✅ Yellow area with question and options (4/6 of screen)
          SizedBox(
            height: MediaQuery.of(context).size.height *4 / 7,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: List.generate(
                      question.options.length,
                          (i) => buildOption(question.options[i], question.emojis[i], i),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Skip, for later", style: TextStyle(color: Colors.black54)),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Bottom progress section with dark background (1/6 of screen)
          SizedBox(
            height: MediaQuery.of(context).size.height / 7,
            child: Container(
              width: double.infinity,
              color: const Color.fromRGBO(31, 43, 55, 1),
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress bar with arrows on each side
                  Row(
                    children: [
                      // ⬅️ Previous button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: currentQuestion > 0
                            ? () {
                          setState(() {
                            currentQuestion--;
                            progress = (currentQuestion + 1) / questions.length;
                          });
                        }
                            : null,
                      ),

                      // 🔵 Custom animated progress bar
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double barWidth = constraints.maxWidth * progress;

                            return Stack(
                              children: [
                                // Background bar
                                Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),

                                // Foreground animated fill
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  width: barWidth,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),

                                // Percentage text aligned in blue bar
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: barWidth,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${(progress * 100).toInt()}%",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // ➡️ Next button
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        color: Colors.white,
                        onPressed: currentQuestion < questions.length - 1
                            ? () {
                          setState(() {
                            currentQuestion++;
                            progress = (currentQuestion + 1) / questions.length;
                          });
                        }
                            : null,
                      ),
                    ],
                  ),

                  Text(
                    "Question ${currentQuestion + 1} of ${questions.length}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 15)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
