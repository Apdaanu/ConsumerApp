import 'package:flutter/material.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/categories/category.dart';
import 'package:freshOk/domain/entities/categories/sub_category.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';

const String UI_TYPE_1 = "1";
const String UI_TYPE_2 = "2";

class CategorySection extends StatelessWidget {
  final Category category;
  final String whichPage;
  const CategorySection({
    Key key,
    @required this.category,
    @required this.whichPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      width: measure.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15 + measure.screenHeight * 0.01),
          category.title != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: measure.width * 0.02),
                      child: RegularText(
                        text: category.title,
                        color: AppTheme.black3,
                        fontSize: AppTheme.regularTextSize,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _renderCategories(),
              ),
            ),
          ),
          SizedBox(height: 15 + measure.screenHeight * 0.01),
        ],
      ),
    );
  }

  List<Widget> _renderCategories() {
    List<Widget> list = List<Widget>();
    category.subContents.forEach((element) {
      if (category.uiType == UI_TYPE_1)
        list.add(
          CategorySectionType1Card(
            subCategory: element,
            categoryType: category.type,
            sectionId: category.id,
            whichPage: whichPage,
          ),
        );
      else if (category.uiType == UI_TYPE_2)
        list.add(
          CategorySectionType2Card(
            subCategory: element,
            categoryType: category.type,
            sectionId: category.id,
            whichPage: whichPage,
          ),
        );
    });
    return list;
  }
}

class CategorySectionType1Card extends StatelessWidget {
  final SubCategory subCategory;
  final String categoryType;
  final String sectionId;
  final String whichPage;

  const CategorySectionType1Card({
    Key key,
    @required this.subCategory,
    @required this.categoryType,
    @required this.sectionId,
    @required this.whichPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        if (whichPage == 'home') {
          Util.subCategoryNavigationHandler(
            categoryId: subCategory.value,
            idType: categoryType,
            sectionId: sectionId,
            type: subCategory.type,
            title: subCategory.text,
          );
        } else {
          Util.subCategoryNavigationHandler(
            categoryId: subCategory.value,
            idType: 'recipeCategory',
            sectionId: sectionId,
            type: 'id',
            title: subCategory.text,
            recepieType: categoryType,
            whichPage: 'recepie',
          );
        }
      },
      child: Container(
        width: 80 + measure.width * 0.05,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              width: 80 + measure.width * 0.01,
              height: 80 + measure.width * 0.01,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network(subCategory.image).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: measure.screenHeight * 0.005),
            subCategory.text != null
                ? RegularText(
                    text: subCategory.text,
                    color: AppTheme.black5,
                    fontSize: AppTheme.regularTextSize,
                    overflow: false,
                    textAlign: TextAlign.center,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class CategorySectionType2Card extends StatelessWidget {
  final SubCategory subCategory;
  final String categoryType;
  final String sectionId;
  final String whichPage;

  const CategorySectionType2Card({
    Key key,
    @required this.subCategory,
    @required this.categoryType,
    @required this.sectionId,
    @required this.whichPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        if (whichPage == 'home') {
          Util.subCategoryNavigationHandler(
            categoryId: subCategory.value,
            idType: categoryType,
            sectionId: sectionId,
            type: subCategory.type,
            title: subCategory.text,
          );
        } else {
          Util.subCategoryNavigationHandler(
            categoryId: subCategory.value,
            idType: 'recipeCategory',
            sectionId: sectionId,
            type: 'id',
            title: subCategory.text,
            recepieType: categoryType,
            whichPage: 'recepie',
          );
        }
      },
      child: Container(
        width: 90 + measure.width * 0.05,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Stack(
          children: <Widget>[
            Container(
              width: 90 + measure.width * 0.01,
              height: 90 + measure.width * 0.01,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network(subCategory.image).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //*Removed because of UI Requirement
            // Positioned(
            //   bottom: 5,
            //   width: 120 + measure.width * 0.01,
            //   child: Center(
            //     child: RegularText(
            //       text: subCategory.text ?? "",
            //       color: Colors.white,
            //       fontSize: AppTheme.regularTextSize,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
