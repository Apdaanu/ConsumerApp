import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/recepie_screens/create_recepie_screen/create_recepie_bloc/create_recepie_bloc.dart';

import 'form_screens/create_recepie_form_screen_1.dart';
import 'form_screens/create_recepie_form_screen_2.dart';
import 'form_screens/create_recepie_form_screen_3.dart';
import 'form_screens/create_recepie_form_screen_4.dart';

class CreateRecepieForm extends StatelessWidget {
  const CreateRecepieForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();
    return PageView(
      controller: createRecepieBloc.controller,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        CreateRecepieFormScreen1(),
        CreateRecepieFormScreen2(),
        CreateRecepieFormScreen3(),
        CreateRecepieFormScreen4(),
      ],
    );
  }
}
