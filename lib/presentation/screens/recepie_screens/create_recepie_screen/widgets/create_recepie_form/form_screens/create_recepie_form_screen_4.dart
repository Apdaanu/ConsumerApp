import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:freshOk/presentation/screens/recepie_screens/create_recepie_screen/widgets/create_recepie_form/widgets/create_recepie_form_section.dart';
import 'package:freshOk/presentation/widgets/text_field_underline.dart';
import 'dart:math' as math;

import '../../../../../../../core/constants/measure.dart';
import '../../../../../../../core/theme/theme.dart';
import '../../../../../../widgets/custom_button.dart';
import '../../../../../../widgets/regular_text.dart';
import '../widgets/create_recepie_form_screen_template.dart';

class CreateRecepieFormScreen4 extends StatelessWidget {
  const CreateRecepieFormScreen4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return CreateRecepieFormScreenTemplate(
      child: CreateRecepieFormSection(
        title: "STEPS",
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Column(
              children: List.generate(
                5,
                (index) => AddSetps(
                  index: index + 1,
                ),
              ),
            ),
            CustomButton(
              height: 35 + measure.screenHeight * 0.01,
              width: measure.width * 0.8,
              color: AppTheme.primaryColor,
              onTap: () {},
              child: Center(
                child: RegularText(
                  text: "Add ingredient",
                  color: Colors.white,
                  fontSize: AppTheme.smallTextSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddSetps extends StatelessWidget {
  final int index;

  const AddSetps({
    Key key,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.symmetric(vertical: 10 + measure.screenHeight * 0.01),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 10 + measure.screenHeight * 0.01),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(width: 15),
                DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: [4, 2],
                  strokeWidth: 1,
                  color: AppTheme.primaryColor,
                  radius: Radius.circular(2),
                  child: Padding(
                    padding: EdgeInsets.all(31),
                    child: Icon(
                      Icons.camera_alt,
                      color: AppTheme.primaryColor,
                      size: 36 * measure.fontRatio,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Container(
                    // width: measure.width*0.05,
                    color: AppTheme.greyF5,
                    child: Column(
                      children: <Widget>[
                        CustomTextFieldUnderline(
                          hintText: "type here ...",
                          maxLines: 5,
                          underlineHeight: 4,
                          padding: EdgeInsets.all(10),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: -math.pi / 2,
                  child: Icon(
                    Icons.drag_handle,
                    color: Colors.grey,
                    size: 22 * measure.fontRatio,
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.primaryColor,
            ),
            child: Center(
              child: RegularText(
                text: index.toString(),
                color: Colors.white,
                fontSize: AppTheme.smallTextSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
