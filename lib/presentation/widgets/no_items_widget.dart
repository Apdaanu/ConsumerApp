import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class NoItemsWidget extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final String buttonText;
  final Color btnColor;
  final btnFxn;
  final String altBtnText;
  final altBtnFxn;

  const NoItemsWidget({
    Key key,
    @required this.title,
    @required this.image,
    @required this.description,
    @required this.buttonText,
    @required this.btnFxn,
    @required this.btnColor,
    this.altBtnText,
    this.altBtnFxn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      height: measure.screenHeight,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: measure.screenHeight * 0.4,
            child: ClipPath(
              clipper: BezierClipper(),
              child: Container(
                color: Color(0xfff6f5f3),
                height: measure.screenHeight * 0.4,
              ),
            ),
          ),
          Positioned(
            top: measure.screenHeight * 0.4 * 0.75 - 180 + measure.width * 0.2,
            child: Container(
              height: 180 + measure.width * 0.2,
              width: 180 + measure.width * 0.2,
              child: Center(
                child: Image.asset(image),
              ),
            ),
          ),
          Positioned(
            top: measure.screenHeight * 0.4 * 0.75 + 100,
            child: Container(
              width: measure.width,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15 + measure.screenHeight * 0.02),
                  RegularText(
                    text: title,
                    color: AppTheme.black5,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: measure.width * 0.6,
                    child: RegularText(
                      text: description,
                      color: AppTheme.black7,
                      fontSize: AppTheme.smallTextSize,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      overflow: false,
                    ),
                  ),
                  SizedBox(height: 10),
                  OutlineButton(
                    onPressed: () {
                      btnFxn();
                    },
                    borderSide: BorderSide(width: 2, color: btnColor),
                    highlightedBorderColor: btnColor,
                    splashColor: btnColor.withAlpha(0x10),
                    child: RegularText(
                      text: buttonText,
                      color: btnColor,
                      fontSize: AppTheme.regularTextSize,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  altBtnText != null
                      ? FlatButton(
                          onPressed: () {
                            altBtnFxn();
                          },
                          child: RegularText(
                            text: altBtnText ?? '',
                            color: AppTheme.black7,
                            fontSize: AppTheme.smallTextSize,
                          ),
                        )
                      : Container(),
                  SizedBox(height: 5 + measure.screenHeight * 0.01),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height * 0.75); //vertical line
    path.quadraticBezierTo(size.width / 2, size.height, size.width,
        size.height * 0.75); //quadratic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
