import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshOk/presentation/widgets/custom_button.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/measure.dart';
import '../../../core/theme/theme.dart';
import '../../widgets/display_screen.dart';
import '../../widgets/regular_text.dart';
import '../../widgets/top_bar.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool showPopup = false;
  String popupTitle;

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: CustomTopBar(title: 'About Us'),
      body: Stack(
        children: <Widget>[
          Container(
            height: measure.bodyHeight,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              10 + measure.width * 0.02,
              0,
              10 + measure.width * 0.02,
              160,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10 + measure.width * 0.02),
                  Container(
                    width: measure.width * 0.98 - 20,
                    height: (measure.width * 0.98 - 20) * (9 / 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xaa707070),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SvgPicture.asset(
                      freshOkIconSvg,
                      color: Color(0xbb202a2e),
                      height: 120 * measure.fontRatio,
                    ),
                  ),
                  SizedBox(height: 10 + measure.width * 0.02),
                  SizedBox(height: 10 + measure.width * 0.02),
                  RegularText(
                    text:
                        '''freshok business is India's largest Fresh Produce Supply Chain 
Company. We are pioneers in solving one of the toughest supply 
chain problems of the world by leveraging innovative technology.

What to expect from us?

* Wide range of products, including fresh fruits and vegetables
* Enjoy low prices and great offers
* Fast and Secure Checkout
* Assured quality
*On-time, every-time: We take pride in timely delivery
* Last-minute shopping? Sweets from the neighborhood?
* Easy search options

PLACES IN
*Gurgaon''',
                    color: AppTheme.black2,
                    fontSize: AppTheme.regularTextSize,
                    overflow: false,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: <Widget>[
                AboutScreenCard(
                  title: 'Terms & Conditions',
                  onTap: () {
                    setState(() {
                      showPopup = true;
                      popupTitle = 'Terms & Conditions';
                    });
                  },
                ),
                AboutScreenCard(
                  title: 'Privacy Policy',
                  onTap: () {
                    setState(() {
                      showPopup = true;
                      popupTitle = 'Privacy Policy';
                    });
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              width: measure.width,
              height: showPopup ? measure.bodyHeight : 0,
              duration: Duration(milliseconds: 150),
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.98 - 20,
                    height: 50,
                    child: CustomButton(
                      height: null,
                      width: null,
                      onTap: () {
                        setState(() {
                          showPopup = !showPopup;
                        });
                      },
                      color: Colors.grey[300],
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RegularText(
                              text: popupTitle,
                              color: AppTheme.black2,
                              fontSize: AppTheme.smallTextSize,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: AppTheme.black2,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      failure: false,
      failureCode: 0,
    );
  }
}

class AboutScreenCard extends StatelessWidget {
  final String title;
  final onTap;

  const AboutScreenCard({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.98 - 20,
      height: 50,
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10 + MediaQuery.of(context).size.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.1, color: Color(0xff707070)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomButton(
        height: null,
        width: null,
        onTap: onTap,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RegularText(
                text: title,
                color: AppTheme.black3,
                fontSize: AppTheme.smallTextSize,
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.black3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
