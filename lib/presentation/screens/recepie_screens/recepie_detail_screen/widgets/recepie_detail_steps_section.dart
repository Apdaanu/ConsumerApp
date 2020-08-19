import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../recepie_detail_bloc/recepie_detail_bloc.dart';
import '../../../../widgets/regular_text.dart';

class RecepieDetailStepsSection extends StatefulWidget {
  const RecepieDetailStepsSection({Key key}) : super(key: key);

  @override
  _RecepieDetailStepsSectionState createState() =>
      _RecepieDetailStepsSectionState();
}

class _RecepieDetailStepsSectionState extends State<RecepieDetailStepsSection> {
  RecepieDetailBloc _recepieDetailBloc;
  PageController _pageController;
  int step = 0;

  @override
  void initState() {
    super.initState();
    _recepieDetailBloc = context.bloc<RecepieDetailBloc>();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        step = _pageController.page.toInt();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      child: Column(
        children: <Widget>[
          RecepieDetailStepsSectionStepCounter(
            step: step,
            totalSteps: _recepieDetailBloc.recepie.steps.length,
            handler: _handleStepBtns,
          ),
          SizedBox(
            height: measure.bodyHeight - 1.5 * measure.topBarHeight,
            child: PageView(
              controller: _pageController,
              children: _renderSteps(_recepieDetailBloc.recepie.steps),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStepBtns(int val) {
    _pageController.animateToPage(
      val,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> _renderSteps(List steps) {
    List<Widget> list = List<Widget>();

    for (int i = 0; i < steps.length; ++i) {
      list.add(
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RecepieDetailStepsSectionImage(
                image: _recepieDetailBloc.recepie.steps[i].image,
              ),
              RecepieDetailStepsSectionStep(
                step: _recepieDetailBloc.recepie.steps[i].step,
                count: step,
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }
}

class RecepieDetailStepsSectionStepCounter extends StatelessWidget {
  final int step;
  final int totalSteps;
  final handler;
  const RecepieDetailStepsSectionStepCounter({
    Key key,
    this.step,
    this.totalSteps,
    this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      height: measure.topBarHeight,
      padding: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
      color: Color(0xfffff8cf),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          step == 0
              ? IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.transparent,
                  ),
                  onPressed: () {},
                )
              : IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    handler(step - 1);
                  },
                ),
          RegularText(
            text: "STEP ${step + 1}/$totalSteps",
            color: AppTheme.black3,
            fontSize: AppTheme.headingTextSize,
            fontWeight: FontWeight.bold,
          ),
          step == totalSteps - 1
              ? IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.transparent,
                  ),
                  onPressed: () {},
                )
              : IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    handler(step + 1);
                  },
                ),
        ],
      ),
    );
  }
}

class RecepieDetailStepsSectionImage extends StatelessWidget {
  final String image;
  const RecepieDetailStepsSectionImage({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      child: Image.network(
        image,
        width: measure.width,
        height: measure.width * (9 / 16),
        fit: BoxFit.cover,
      ),
    );
  }
}

class RecepieDetailStepsSectionStep extends StatelessWidget {
  final String step;
  final int count;
  const RecepieDetailStepsSectionStep({
    Key key,
    this.step,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 + measure.width * 0.02,
        vertical: 10 + measure.screenHeight * 0.01,
      ),
      child: Stack(
        children: <Widget>[
          //*Removed as it was bad UI choice
          // Positioned(
          //   child: Text(
          //     (count + 1).toString(),
          //     style: AppTheme.style.copyWith(
          //       color: Color(0x90fff3a8),
          //       fontSize: 220,
          //       height: 1,
          //       fontWeight: FontWeight.w900,
          //     ),
          //   ),
          // ),
          RegularText(
            text: step,
            color: AppTheme.black2,
            fontSize: AppTheme.headingTextSize,
            overflow: false,
          ),
        ],
      ),
    );
  }
}
