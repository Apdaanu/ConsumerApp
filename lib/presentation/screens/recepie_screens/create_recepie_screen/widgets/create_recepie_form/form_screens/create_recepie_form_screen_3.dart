import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/recepie_screens/create_recepie_screen/create_recepie_bloc/create_recepie_bloc.dart';
import 'package:freshOk/presentation/widgets/text_field_underline.dart';
import 'dart:math' as math;

import '../../../../../../../core/constants/measure.dart';
import '../../../../../../../core/theme/theme.dart';
import '../../../../../../widgets/custom_button.dart';
import '../../../../../../widgets/regular_text.dart';
import '../widgets/create_recepie_form_screen_template.dart';
import '../widgets/create_recepie_form_section.dart';

class CreateRecepieFormScreen3 extends StatelessWidget {
  const CreateRecepieFormScreen3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();
    Measure measure = MeasureImpl(context);
    return CreateRecepieFormScreenTemplate(
        child: Column(
      children: <Widget>[
        AddIngredients(),
        CustomButton(
          height: 35 + measure.screenHeight * 0.01,
          width: measure.width * 0.8,
          color: AppTheme.primaryColor,
          //? try adding a temp editing ing to bloc
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
    ));
  }
}

class AddIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();
    return CreateRecepieFormSection(
      title: "ADD INGREDIENTS",
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: BlocBuilder(
            cubit: createRecepieBloc,
            builder: (context, state) => Column(
              children: _renderIngridients(createRecepieBloc.ingridients),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderIngridients(List ing) {
    List<Widget> list = List<Widget>();

    for (int i = 0; i < ing.length; ++i) {
      list.add(AddIngredientsItem(
        index: i,
      ));
    }

    list.add(AddIngredientsItem());

    return list;
  }
}

class AddIngredientsItem extends StatefulWidget {
  final int index;
  final ing;

  AddIngredientsItem({
    Key key,
    this.index,
    this.ing,
  }) : super(key: key);

  @override
  _AddIngredientsItemState createState() => _AddIngredientsItemState();
}

class _AddIngredientsItemState extends State<AddIngredientsItem> {
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  CreateRecepieBloc _createRecepieBloc;
  String type = 'name';
  String value;

  @override
  void initState() {
    super.initState();
    _createRecepieBloc = context.bloc<CreateRecepieBloc>();
    nameController.addListener(() {
      _createRecepieBloc.add(
        CreateRecepieEditIngridient(
          index: widget.index,
          quantity: qtyController.text,
          type: type,
          value: type == 'name' ? nameController.text : value,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.symmetric(vertical: 5 + measure.screenHeight * 0.01),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 5 + measure.screenHeight * 0.01,
            ),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(width: 5 + measure.width * 0.01),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppTheme.greyF5,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: [4, 2],
                    strokeWidth: 1,
                    color: AppTheme.primaryColor,
                    radius: Radius.circular(2),
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppTheme.primaryColor,
                        size: 16 * measure.fontRatio,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                CreateRecepieInputWithUnderline(
                  width: measure.width * 0.3,
                  hintText: "Item Name",
                  controller: nameController,
                ),
                Expanded(child: Container()),
                CreateRecepieInputWithUnderline(
                  width: measure.width * 0.2,
                  hintText: "Quantity",
                  controller: qtyController,
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
        widget.index != null
            ? Positioned(
                top: 2,
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
                      text: widget.index.toString(),
                      color: Colors.white,
                      fontSize: AppTheme.extraSmallTextSize,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class CreateRecepieInputWithUnderline extends StatelessWidget {
  final double width;
  final String hintText;
  final TextEditingController controller;

  const CreateRecepieInputWithUnderline({
    Key key,
    @required this.width,
    @required this.hintText,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      width: width,
      color: AppTheme.greyF5,
      child: Column(
        children: <Widget>[
          CustomTextFieldUnderline(
            hintText: hintText,
            controller: controller,
            underlineHeight: 4,
            center: true,
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
        ],
      ),
    );
  }
}
