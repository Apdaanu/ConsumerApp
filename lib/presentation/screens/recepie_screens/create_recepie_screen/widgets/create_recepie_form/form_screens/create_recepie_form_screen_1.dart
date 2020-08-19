import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/measure.dart';
import '../../../../../../../core/theme/theme.dart';
import '../../../../../../widgets/regular_text.dart';
import '../../../create_recepie_bloc/create_recepie_bloc.dart';
import '../widgets/create_recepie_form_screen_template.dart';
import '../widgets/create_recepie_form_section.dart';

class CreateRecepieFormScreen1 extends StatelessWidget {
  const CreateRecepieFormScreen1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return CreateRecepieFormScreenTemplate(
        child: Column(
      children: <Widget>[
        TitleInput(),
        DescriptionInput(),
        PhotoInput(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) => UploadedImages()),
          ),
        )
      ],
    ));
  }
}

class TitleInput extends StatelessWidget {
  const TitleInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();
    Measure measure = MeasureImpl(context);
    return CreateRecepieFormSection(
      title: "TITLE",
      child: Column(
        children: <Widget>[
          TextField(
            controller: createRecepieBloc.titleController,
            focusNode: createRecepieBloc.titleNode,
            onChanged: (value) {
              createRecepieBloc.add(RefreshEvent());
            },
            // maxLength: 55,
            cursorColor: AppTheme.black3,
            cursorWidth: 2,
            inputFormatters: [
              LengthLimitingTextInputFormatter(55),
            ],
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(
                bottom: 0,
                left: 0,
                right: 0,
              ),
              hintText: "Eg: Cheese Salad",
              hintStyle: TextStyle(
                fontFamily: "Open Sans",
                fontSize: AppTheme.regularTextSize * measure.fontRatio,
                color: AppTheme.black7,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextStyle(
              fontFamily: "Open Sans",
              fontSize: AppTheme.regularTextSize * measure.fontRatio,
              color: AppTheme.black2,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.black7,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          BlocBuilder(
            cubit: createRecepieBloc,
            builder: (context, state) => Container(
              alignment: Alignment.centerRight,
              child: RegularText(
                text: createRecepieBloc.titleController.text.length.toString() +
                    "/55",
                color: AppTheme.black7,
                fontSize: AppTheme.regularTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();
    Measure measure = MeasureImpl(context);
    return CreateRecepieFormSection(
      title: "DESCRIPTION",
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            color: Colors.white,
            child: TextField(
              controller: createRecepieBloc.descController,
              focusNode: createRecepieBloc.descNode,
              maxLength: 150,
              cursorColor: AppTheme.black3,
              cursorWidth: 2,
              maxLines: 8,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: "type here...",
                hintStyle: TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: AppTheme.regularTextSize * measure.fontRatio,
                  color: AppTheme.black5,
                ),
              ),
              style: TextStyle(
                fontFamily: "Open Sans",
                fontSize: AppTheme.regularTextSize * measure.fontRatio,
                color: AppTheme.black2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoInput extends StatelessWidget {
  const PhotoInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return CreateRecepieFormSection(
      title: "ADD A RECEPIE PHOTO",
      req: false,
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 10 + measure.screenHeight * 0.01),
        child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: [8, 4],
          strokeWidth: 1,
          color: AppTheme.primaryColor,
          radius: Radius.circular(4),
          child: Container(
            height: measure.width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.camera_alt,
                  color: AppTheme.primaryColor,
                  size: 48 * measure.fontRatio,
                ),
                Container(
                  width: measure.width * 0.6,
                  child: RegularText(
                    text: "Upload final photo(s) of your dish now",
                    color: AppTheme.primaryColor,
                    fontSize: AppTheme.headingTextSize,
                    fontWeight: FontWeight.w500,
                    overflow: false,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadedImages extends StatelessWidget {
  const UploadedImages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      children: <Widget>[
        Container(
          height: 100 + measure.width * 0.1,
          width: 100 + measure.width * 0.1,
          margin: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: Image.asset(
                "assets/test/recepie.png",
              ).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 100 + measure.width * 0.1,
          width: 100 + measure.width * 0.1,
          margin: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
          decoration: BoxDecoration(
            color: Color(0x35000000),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              color: Colors.grey[50],
              size: 36 * measure.fontRatio,
            ),
          ),
        ),
      ],
    );
  }
}
