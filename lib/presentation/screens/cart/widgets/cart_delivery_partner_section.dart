import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../widgets/regular_text.dart';
import '../../mitra_screens/select_mitra_screen/widgets/select_mitra_card.dart';
import 'cart_container.dart';

class CartDeliveryPartnerSection extends StatefulWidget {
  const CartDeliveryPartnerSection({Key key}) : super(key: key);

  @override
  _CartDeliveryPartnerSectionState createState() =>
      _CartDeliveryPartnerSectionState();
}

class _CartDeliveryPartnerSectionState
    extends State<CartDeliveryPartnerSection> {
  MitraBloc _mitraBloc;
  UserDetailsBloc _userDetailsBloc;

  @override
  void initState() {
    super.initState();
    _mitraBloc = context.bloc<MitraBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _mitraBloc.add(
      MitraInitEvent(
        mitraId: _userDetailsBloc.userDetails.mitraId,
        userId: _userDetailsBloc.userDetails.userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, selectMitraRoute);
      },
      child: CartContainer(
        border: Border.all(
          width: 0.1,
          color: Color(0xff707070),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RegularText(
                  text: "Your freshMitra",
                  color: AppTheme.primaryColor,
                  fontSize: AppTheme.extraSmallTextSize,
                  fontWeight: FontWeight.bold,
                ),
                BlocBuilder(
                  cubit: _mitraBloc,
                  builder: (context, state) {
                    if (state is MitraLoaded) {
                      return RegularText(
                        text: state.selMitra != null ? "Change" : "Select",
                        color: AppTheme.primaryColor,
                        fontSize: AppTheme.extraSmallTextSize,
                        fontWeight: FontWeight.bold,
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
            SizedBox(height: 5 + measure.screenHeight * 0.01),
            BlocBuilder(
              cubit: _mitraBloc,
              builder: (context, state) {
                if (state is MitraLoaded) {
                  if (state.selMitra != null) {
                    return SelectMitraCard(
                      bgColor: Colors.white,
                      textColor: AppTheme.black3,
                      mitra: state.selMitra,
                      boxshadow: false,
                      onTap: () {
                        Navigator.pushNamed(context, selectMitraRoute);
                      },
                    );
                  } else {
                    return RegularText(
                      text: 'Please select a freshMitra',
                      color: AppTheme.black7,
                      fontSize: AppTheme.smallTextSize,
                      fontStyle: FontStyle.italic,
                    );
                  }
                }
                return CardShimmer();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class CartDeliveryPartnerCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 15,
//         vertical: 8,
//       ),
//       decoration: BoxDecoration(
//         color: AppTheme.cartSecondary,
//         borderRadius: BorderRadius.circular(2),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             blurRadius: 2,
//             offset: Offset(0, 0),
//             color: Color(0x29000000),
//           ),
//         ],
//       ),
//       child: Row(
//         children: <Widget>[
//           CircleAvatar(
//             backgroundImage: Image.asset("assets/test/profile_photo.png").image,
//             radius: 22,
//           ),
//           SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               RegularText(
//                 text: "Aman Rai",
//                 color: Colors.white,
//                 fontSize: AppTheme.smallTextSize,
//                 fontWeight: FontWeight.bold,
//               ),
//               RegularText(
//                 text: "9560529649",
//                 color: Colors.white,
//                 fontSize: AppTheme.smallTextSize,
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
