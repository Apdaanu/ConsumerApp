import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/footer_branding_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              height: measure.screenHeight * 0.3,
              width: measure.screenHeight * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: measure.screenHeight * 0.1,
                    width: measure.screenHeight * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: Image.asset('assets/images/icon.png').image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: measure.screenHeight * 0.01),
                  Text(
                    'freshOk',
                    style: AppTheme.style.copyWith(
                      color: AppTheme.primaryColor,
                      fontSize: 18 * measure.fontRatio,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: FooterBrandingWidget(),
          )
        ],
      ),
    );
  }
}
