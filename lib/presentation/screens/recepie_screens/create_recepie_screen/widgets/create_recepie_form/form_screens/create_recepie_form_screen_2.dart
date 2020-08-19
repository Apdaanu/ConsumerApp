import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/domain/entities/categories/type_category.dart';

import '../../../../../../../core/constants/measure.dart';
import '../../../../../../../core/theme/theme.dart';
import '../../../../../../widgets/regular_text.dart';
import '../../../create_recepie_bloc/create_recepie_bloc.dart';
import '../widgets/create_recepie_form_screen_template.dart';
import '../widgets/create_recepie_form_section.dart';

class CreateRecepieFormScreen2 extends StatelessWidget {
  const CreateRecepieFormScreen2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateRecepieFormScreenTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DishTypeInput(),
          CuisineTypeInput(),
          VideoLinkInput(),
        ],
      ),
    );
  }
}

class VideoLinkInput extends StatelessWidget {
  const VideoLinkInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();
    Measure measure = MeasureImpl(context);
    return CreateRecepieFormSection(
      title: "Recepie Video Link",
      req: false,
      child: Column(
        children: <Widget>[
          TextField(
            controller: createRecepieBloc.ytLinkController,
            cursorColor: AppTheme.black3,
            cursorWidth: 2,
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(
                bottom: 0,
                left: 0,
                right: 0,
              ),
              hintText: "Link to youtube video",
              hintStyle: TextStyle(
                fontFamily: "Open Sans",
                fontSize: AppTheme.regularTextSize * measure.fontRatio,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextStyle(
              fontFamily: "Open Sans",
              fontSize: AppTheme.regularTextSize * measure.fontRatio,
              color: AppTheme.black3,
              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}

class DishTypeInput extends StatefulWidget {
  @override
  _DishTypeInputState createState() => _DishTypeInputState();
}

class _DishTypeInputState extends State<DishTypeInput> {
  CreateRecepieBloc _createRecepieBloc;

  @override
  void initState() {
    super.initState();
    _createRecepieBloc = context.bloc<CreateRecepieBloc>();
    _createRecepieBloc.add(CreateRecepieGetDishes());
  }

  @override
  Widget build(BuildContext context) {
    return CreateRecepieFormSection(
      title: "DISH TYPE",
      req: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlocBuilder(
            cubit: _createRecepieBloc,
            builder: (context, state) {
              if (state is CreateRecepieLoaded) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _renderDishes(_createRecepieBloc.dishTypes),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _renderDishes(List dishes) {
    List<Widget> list = List<Widget>();

    if (dishes != null) {
      dishes.forEach((element) {
        list.add(DisplayCats(typeCategory: element, type: 0));
      });
    }

    return list;
  }
}

class CuisineTypeInput extends StatefulWidget {
  @override
  _CuisineTypeInputState createState() => _CuisineTypeInputState();
}

class _CuisineTypeInputState extends State<CuisineTypeInput> {
  CreateRecepieBloc _createRecepieBloc;

  @override
  void initState() {
    super.initState();
    _createRecepieBloc = context.bloc<CreateRecepieBloc>();
    _createRecepieBloc.add(CreateRecepieGetCuisines());
  }

  @override
  Widget build(BuildContext context) {
    return CreateRecepieFormSection(
      title: "CUISINE",
      req: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlocBuilder(
            cubit: _createRecepieBloc,
            builder: (context, state) {
              if (state is CreateRecepieLoaded) {
                return Row(
                  children: _renderCuisines(_createRecepieBloc.cuisines),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _renderCuisines(List cuisines) {
    List<Widget> list = List<Widget>();
    if (cuisines != null) {
      cuisines.forEach((element) {
        list.add(DisplayCats(typeCategory: element, type: 1));
      });
    }

    return list;
  }
}

class DisplayCats extends StatelessWidget {
  final TypeCategory typeCategory;
  final int type;

  const DisplayCats({
    Key key,
    this.typeCategory,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();

    bool isSelected() {
      if (type == 0) {
        return createRecepieBloc.selDishes.indexOf(typeCategory.id) == -1
            ? false
            : true;
      } else {
        return createRecepieBloc.selCuisines.indexOf(typeCategory.id) == -1
            ? false
            : true;
      }
    }

    final Color textColor = isSelected() ? Colors.white : AppTheme.primaryColor;
    final Color bgColor =
        isSelected() ? AppTheme.primaryColor : Colors.transparent;
    final List<BoxShadow> boxShadow = isSelected()
        ? <BoxShadow>[
            BoxShadow(
              blurRadius: 3,
              offset: Offset(0, 2),
              color: Color(0x29000000),
            ),
          ]
        : [];

    return GestureDetector(
      onTap: () {
        if (type == 0) {
          createRecepieBloc.add(CreateRecepieSelDish(typeCategory.id));
        } else {
          createRecepieBloc.add(CreateRecepieSelCuisines(typeCategory.id));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1.5,
            color: AppTheme.primaryColor,
          ),
        ),
        child: RegularText(
          text: typeCategory.name,
          color: textColor,
          fontSize: AppTheme.regularTextSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
