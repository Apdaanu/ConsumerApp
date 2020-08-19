import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/domain/entities/categories/category.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';

class CategorySectionType2 extends StatelessWidget {
  final Category category;

  const CategorySectionType2({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15 + measure.screenHeight * 0.01),
        category.title != null
            ? Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: measure.width * 0.02),
                    child: RegularText(
                      text: category.title,
                      color: AppTheme.black2,
                      fontSize: AppTheme.headingTextSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5 + measure.screenHeight * 0.01)
                ],
              )
            : Container(),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                CategorySectionType2Card(),
                CategorySectionType2Card(),
                CategorySectionType2Card(),
                CategorySectionType2Card(),
                CategorySectionType2Card(),
              ],
            ),
          ),
        ),
        SizedBox(height: 15 + measure.screenHeight * 0.01),
      ],
    );
  }
}

class CategorySectionType2Card extends StatelessWidget {
  const CategorySectionType2Card({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(recepieListRoute);
      },
      child: Container(
        width: 120 + measure.width * 0.05,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Stack(
          children: <Widget>[
            Container(
              width: 120 + measure.width * 0.01,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 2.0,
                    color: Color(0x29000000),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              width: 120 + measure.width * 0.01,
              child: Center(
                child: RegularText(
                  text: "Category",
                  color: Colors.white,
                  fontSize: AppTheme.regularTextSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
