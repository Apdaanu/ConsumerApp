import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/injection_container.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../domain/entities/order/order.dart';
import '../../../../domain/usecases/chat/send_feedback.dart';
import '../../../widgets/card_shimmer.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/fresh_mitra_with_phone.dart';
import '../../../widgets/regular_text.dart';
import '../../../widgets/text_field_underline.dart';
import '../../../widgets/top_bar.dart';
import '../../bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';

class CustomerSupportHomeScreen extends StatefulWidget {
  const CustomerSupportHomeScreen({Key key}) : super(key: key);

  @override
  _CustomerSupportHomeScreenState createState() =>
      _CustomerSupportHomeScreenState();
}

class _CustomerSupportHomeScreenState extends State<CustomerSupportHomeScreen> {
  MitraBloc _mitraBloc;
  UserDetailsBloc _userDetailsBloc;
  SendFeedback _sendFeedback;
  TextEditingController _controller;
  FocusNode _focusNode;
  String _query;
  bool _posting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _sendFeedback = sl<SendFeedback>();
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
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: CustomTopBar(title: 'Customer Support'),
      body: Stack(
        children: <Widget>[
          Container(
            height: measure.bodyHeight,
            width: measure.width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5 + measure.screenHeight * 0.01),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15 + measure.width * 0.02),
                      child: BlocBuilder(
                        cubit: _mitraBloc,
                        builder: (context, state) {
                          if (state is MitraLoaded) {
                            if (_mitraBloc.selMitra != null) {
                              return FreshMitraWithPhone(
                                message:
                                    'Call your freshMitra for quick support',
                                mitraDetails: MitraDetails(
                                  name: _mitraBloc.selMitra.name,
                                  profilePhoto:
                                      _mitraBloc.selMitra.profilePhoto,
                                  businessName:
                                      _mitraBloc.selMitra.businessName,
                                  noOfCustomers: _mitraBloc.selMitra.customers,
                                  mob: _mitraBloc.selMitra.mob,
                                ),
                              );
                            } else {
                              //TODO
                              return Container();
                            }
                          }
                          return CardShimmer();
                        },
                      )),
                  SizedBox(height: 5 + measure.screenHeight * 0.01),
                  SizedBox(height: 5 + measure.screenHeight * 0.01),
                  CustomerSupportHomeItem(
                    text: 'Issue with Return & Refund',
                    onTap: _setQuery,
                    query: 'refund',
                    selQuery: _query,
                  ),
                  CustomerSupportHomeItem(
                    text: 'Mitra related issue',
                    onTap: _setQuery,
                    query: 'mitra',
                    selQuery: _query,
                  ),
                  CustomerSupportHomeItem(
                    text: 'Issue with an order',
                    onTap: _setQuery,
                    query: 'order',
                    selQuery: _query,
                  ),
                  CustomerSupportHomeItem(
                    text: 'Application crashing',
                    onTap: _setQuery,
                    query: 'app',
                    selQuery: _query,
                  ),
                  CustomerSupportHomeItem(
                    text: 'Any suggestion for freshOk',
                    onTap: _setQuery,
                    query: 'suggestion',
                    selQuery: _query,
                  ),
                  CustomerSupportHomeItem(
                    text: 'Other...',
                    onTap: _setQuery,
                    query: 'other',
                    selQuery: _query,
                  ),
                  Container(
                    child: CustomTextFieldUnderline(
                      controller: _controller,
                      focusNode: _focusNode,
                      hintText: 'type something...',
                      padding: EdgeInsets.symmetric(
                        horizontal: 15 + measure.width * 0.02,
                        vertical: 5 + measure.screenHeight * 0.01,
                      ),
                      maxLines: 8,
                      minLines: 8,
                      fontSize: AppTheme.regularTextSize,
                    ),
                  ),
                  SizedBox(height: 40 + measure.screenHeight * 0.01),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: CustomButton(
              height: 40 + measure.screenHeight * 0.01,
              width: measure.width,
              onTap: () {
                if (!this._posting) _report();
              },
              color: this._posting ? Colors.grey[400] : Colors.white,
              child: Center(
                child: _posting
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      )
                    : RegularText(
                        text: 'Send Feedback',
                        color: AppTheme.primaryColor,
                        fontSize: AppTheme.smallTextSize,
                        fontWeight: FontWeight.w600,
                      ),
              ),
            ),
          )
        ],
      ),
      failure: false,
      failureCode: 0,
    );
  }

  void _setQuery(String query) {
    setState(() {
      _query = query;
    });
  }

  void _report() async {
    if (_query == null) {
      _showAlertDialog(
          context, 'Please select a query type', 'Invalid response');
    } else if (_controller.text == '') {
      _showAlertDialog(
          context, 'Please specify the details', 'Invalid response');
      _focusNode.requestFocus();
    } else {
      setState(() {
        this._posting = true;
      });
      final failureOrSuccess =
          await _sendFeedback(SendFeedbackParams(_query, _controller.text));
      failureOrSuccess.fold(
        (l) {
          this._posting = false;
          _showAlertDialog(context, 'Oops! Something snapped', 'Failed');
        },
        (r) {
          this._posting = false;
          this._controller.text = '';
          this._focusNode.unfocus();
          this._query = '';
          _showAlertDialog(
              context, 'Our team will contact you shortly', 'Thank you');
        },
      );
      setState(() {});
    }
  }

  void _showAlertDialog(BuildContext context, String text, String heading) {
    AlertDialog alert = AlertDialog(
      title: RegularText(
        text: heading,
        color: AppTheme.black2,
        fontSize: AppTheme.headingTextSize,
        fontWeight: FontWeight.w700,
      ),
      content: RegularText(
        text: text,
        color: AppTheme.black5,
        fontSize: AppTheme.regularTextSize,
        overflow: false,
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class CustomerSupportHomeItem extends StatelessWidget {
  final String text;
  final onTap;
  final String query;
  final String selQuery;

  const CustomerSupportHomeItem({
    Key key,
    this.text,
    this.onTap,
    this.query,
    this.selQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);

    bool isSelected = selQuery == query;

    return GestureDetector(
      onTap: () {
        onTap(query);
        // Navigator.pushNamed(context, customerChatRoute);
      },
      child: Container(
        width: measure.width,
        padding: EdgeInsets.symmetric(
          horizontal: 15 + measure.width * 0.02,
          vertical: 5 + measure.screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            border: Border(
              top: BorderSide(
                width: 1,
                color: Colors.grey[300],
              ),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      blurRadius: 1,
                      offset: Offset(0, 0),
                      color: Color(0xaa707070),
                    ),
                  ]
                : []),
        child: RegularText(
          text: text,
          color: isSelected ? Colors.white : AppTheme.black3,
          fontSize: AppTheme.regularTextSize,
        ),
      ),
    );
  }
}
