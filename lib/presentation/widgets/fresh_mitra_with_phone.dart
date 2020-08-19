import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/domain/entities/mitra/mitra.dart';
import 'package:freshOk/domain/entities/order/order.dart';
import 'package:freshOk/presentation/screens/mitra_screens/select_mitra_screen/widgets/select_mitra_card.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';
import 'package:url_launcher/url_launcher.dart';

class FreshMitraWithPhone extends StatelessWidget {
  final String message;
  final MitraDetails mitraDetails;

  const FreshMitraWithPhone({
    Key key,
    this.message,
    this.mitraDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Column(
      children: <Widget>[
        SizedBox(height: 5 + measure.screenHeight * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RegularText(
              text: message ?? "Call your freshMitra for more details",
              color: AppTheme.black7,
              fontSize: AppTheme.smallTextSize,
            ),
            GestureDetector(
              onTap: () {
                launch('tel://${mitraDetails.mob}');
              },
              child: Container(
                padding: EdgeInsets.all(1 + measure.width * 0.01),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Icon(
                  Icons.phone,
                  color: Colors.white,
                  size: 12 * measure.fontRatio,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 5 + measure.screenHeight * 0.01),
        SelectMitraCard(
          mitra: Mitra(
            name: mitraDetails.name,
            businessName: mitraDetails.businessName,
            mob: mitraDetails.mob,
            customers: mitraDetails.noOfCustomers,
            profilePhoto: mitraDetails.profilePhoto,
            mitraId: '',
          ),
          bgColor: AppTheme.primaryColor,
          textColor: Colors.white,
        ),
        SizedBox(height: 5 + measure.screenHeight * 0.01),
      ],
    );
  }
}

//? Do not remove, might come in handy
// class OrderDetailsFreshMitraDetails extends StatelessWidget {
//   const OrderDetailsFreshMitraDetails({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Measure measure = MeasureImpl(context);
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 10 + measure.width * 0.01,
//         vertical: 5 + measure.screenHeight * 0.01,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(4),
//         color: AppTheme.primaryColor,
//       ),
//       child: Row(
//         children: <Widget>[
//           CircleAvatar(
//             backgroundImage: Image.asset("assets/test/profile_photo.png").image,
//           ),
//           SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   RegularText(
//                     text: "Aman Rai",
//                     color: Colors.white,
//                     fontSize: AppTheme.smallTextSize,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   SizedBox(width: 5),
//                   RegularText(
//                     text: "( Business Name )",
//                     color: Colors.white,
//                     fontSize: AppTheme.extraSmallTextSize,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ],
//               ),
//               RegularText(
//                 text: "9560529649",
//                 color: Colors.white,
//                 fontSize: AppTheme.smallTextSize,
//                 fontWeight: FontWeight.w500,
//               ),
//             ],
//           ),
//           Expanded(child: Container()),
//           Column(
//             children: <Widget>[
//               RegularText(
//                 text: "352",
//                 color: Colors.white,
//                 fontSize: AppTheme.extraSmallTextSize,
//                 fontWeight: FontWeight.w500,
//               ),
//               RegularText(
//                 text: "Customers",
//                 color: Colors.white,
//                 fontSize: AppTheme.extraSmallTextSize,
//                 fontWeight: FontWeight.w500,
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
