import 'package:flutter/material.dart';
import 'package:freshOk/domain/entities/categories/category.dart';

import '../../../../../../core/constants/measure.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../widgets/regular_text.dart';
import 'widgets/recepie_category_section_card.dart';

class RecepieCategorySection extends StatelessWidget {
  final Category category;

  const RecepieCategorySection({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15 + measure.screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.only(left: measure.width * 0.02),
            child: RegularText(
              text: category.title,
              color: AppTheme.black3,
              fontSize: AppTheme.headingTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5 + measure.screenHeight * 0.01),
          Container(
            color: Color(0xfff2eded),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15 + measure.screenHeight * 0.01),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _renderRecepies(),
                  ),
                ),
                SizedBox(height: 15 + measure.screenHeight * 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _renderRecepies() {
    List<Widget> list = List<Widget>();

    category.subContents.forEach((element) {
      list.add(RecepieCategorySectionCard(subCategory: element));
    });

    return list;
  }
}
