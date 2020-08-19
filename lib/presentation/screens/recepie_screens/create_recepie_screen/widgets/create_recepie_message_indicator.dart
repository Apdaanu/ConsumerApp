import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';
import '../create_recepie_bloc/create_recepie_bloc.dart';

const messages = [
  "We're excited to see your recipe! Let's start with the basics...",
  "Something's cooking! Let's add a few more details...",
  "A recipe would be nothing without the ingredients! What goes in your dish?",
  "Sounds delicious! Now, it's time to add the steps...",
];

class CreateRecepieMessageIndicator extends StatelessWidget {
  const CreateRecepieMessageIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();
    Measure measure = MeasureImpl(context);
    return Container(
      width: measure.width,
      padding: EdgeInsets.symmetric(
        horizontal: 5 + measure.width * 0.01,
        vertical: 5 + measure.screenHeight * 0.01,
      ),
      color: Color(0xfffff3a8),
      child: BlocBuilder(
        cubit: createRecepieBloc,
        builder: (context, state) => RegularText(
          text: messages[createRecepieBloc.step],
          color: AppTheme.black3,
          fontSize: AppTheme.regularTextSize,
          overflow: false,
        ),
      ),
    );
  }
}
