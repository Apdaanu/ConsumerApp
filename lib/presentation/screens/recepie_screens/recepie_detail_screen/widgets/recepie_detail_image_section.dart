import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/recepie_screens/recepie_detail_screen/recepie_detail_bloc/recepie_detail_bloc.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class RecepieDetailImageSection extends StatefulWidget {
  @override
  _RecepieDetailImageSectionState createState() =>
      _RecepieDetailImageSectionState();
}

class _RecepieDetailImageSectionState extends State<RecepieDetailImageSection> {
  RecepieDetailBloc _recepieDetailBloc;
  PageController _pageController;
  int _img = 0;

  @override
  void initState() {
    super.initState();
    _recepieDetailBloc = context.bloc<RecepieDetailBloc>();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _img = _pageController.page.toInt();
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
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: measure.width * 0.75,
            child: PageView(
              controller: _pageController,
              children: _renderImages(measure),
            ),
          ),
          GestureDetector(
            //TODO add swipe functionality
            onTapDown: (TapDownDetails details) =>
                _onTapDown(context, details, measure),
            child: Container(
              height: measure.width * 0.75,
              width: measure.width,
              color: Color(0x29000000),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white,
                          size: 18 * measure.fontRatio,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.bookmark_border,
                          color: Colors.transparent,
                          size: 18 * measure.fontRatio,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      RegularText(
                        text: _recepieDetailBloc.recepie.title,
                        color: Colors.white,
                        fontSize: AppTheme.headingTextSize,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _renderDots(),
                      ),
                      SizedBox(height: 15),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _renderDots() {
    List<Widget> list = List<Widget>();

    for (int i = 0; i < _recepieDetailBloc.recepie.images.length; ++i) {
      if (_img == i) {
        list.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(radius: 4, backgroundColor: Colors.white),
          ),
        );
      } else {
        list.add(
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.transparent,
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return list;
  }

  List<Widget> _renderImages(Measure measure) {
    List<Widget> list = List<Widget>();
    _recepieDetailBloc.recepie.images.forEach((element) {
      list.add(
        Container(
          height: measure.width * 0.75,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.network(element).image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    });
    return list;
  }

  void _onTapDown(
    BuildContext context,
    TapDownDetails details,
    Measure measure,
  ) {
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    if (localOffset.dx < measure.width * 0.33) {
      _pageController.animateToPage(
        _pageController.page.toInt() - 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }

    if (localOffset.dx > measure.width * 0.66) {
      _pageController.animateToPage(
        _pageController.page.toInt() + 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }
}
