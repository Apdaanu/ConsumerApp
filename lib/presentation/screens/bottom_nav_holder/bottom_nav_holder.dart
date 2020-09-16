import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/pop_lock_bloc/pop_lock_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/recepie_home_bloc/recepie_home_bloc.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/measure.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../injection_container.dart';
import '../../widgets/regular_text.dart';
import '../cart/cart_screen.dart';
import '../home_screen/home_screen.dart';
import '../order_screens/my_orders/my_order_screen.dart';
import '../recepie_screens/recepie_home_screen/recepie_home_screen.dart';
import 'blocs/bottom_nav/bottom_nav_bloc.dart';
import 'blocs/cart_bloc/cart_bloc.dart';
import 'blocs/edit_address_bloc/edit_address_bloc.dart';
import 'blocs/home_section/home_section_bloc.dart';
import 'blocs/mitra_bloc/mitra_bloc.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'blocs/pop_address_bloc/pop_address_bloc.dart';
import 'blocs/suggested_products_bloc/suggested_products_bloc.dart';
import 'blocs/user_details_bloc/user_details_bloc.dart';
import 'widgets/drawer/drawer_contents.dart';
import 'widgets/edit_address_widget/edit_address_widget.dart';

class BottomNavHolder extends StatefulWidget {
  final int page;
  BottomNavHolder({Key key, this.page = 0}) : super(key: key);

  @override
  _BottomNavHolderState createState() => _BottomNavHolderState();
}

class _BottomNavHolderState extends State<BottomNavHolder> {
  PageController _pageController;
  PopAddressBloc _popAddressBloc;
  UserDetailsBloc _userDetailsBloc;
  HomeSectionBloc _homeSectionBloc;
  RecepieHomeBloc _recepieHomeBloc;
  OrderBloc _orderBloc;
  BottomNavBloc _bottomNavBloc;
  SuggestedProductsBloc _suggestedProductsBloc;
  CartBloc _cartBloc;
  EditAddressBloc _editAddressBloc;
  PopLockBloc _popLockBloc;
  MitraBloc _mitraBloc;

  @override
  void initState() {
    _pageController = PageController();
    _popAddressBloc = sl<PopAddressBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _cartBloc = context.bloc<CartBloc>();
    _homeSectionBloc = sl<HomeSectionBloc>();
    _recepieHomeBloc = sl<RecepieHomeBloc>();
    _orderBloc = sl<OrderBloc>();
    _bottomNavBloc = context.bloc<BottomNavBloc>();
    _suggestedProductsBloc = sl<SuggestedProductsBloc>();
    _editAddressBloc = sl<EditAddressBloc>();
    _popLockBloc = context.bloc<PopLockBloc>();
    _mitraBloc = context.bloc();

    _userDetailsBloc.add(InitUserDetailsEvent(
      (userId) {
        _homeSectionBloc.add(HomeSectionInitEvent());
        _mitraBloc.add(MitraInitEvent(mitraId: _userDetailsBloc.userDetails.mitraId, userId: userId));
        _suggestedProductsBloc.add(SuggestedProductsInitEvent(userId));
        _recepieHomeBloc.add(RecepieHomeInit(userId));
        _editAddressBloc.add(EditAddressInitEvent(_userDetailsBloc.userDetails));
      },
    ));
    _cartBloc.add(CartInitEvent());
    _bottomNavBloc.add(widget.page);
    super.initState();
  }

  @override
  void dispose() {
    _popAddressBloc.close();
    _userDetailsBloc.close();
    _cartBloc.close();
    _homeSectionBloc.close();
    _recepieHomeBloc.close();
    _orderBloc.close();
    _bottomNavBloc.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          drawer: Drawer(
            child: DrawerContents(),
          ),
          body: WillPopScope(
            onWillPop: () {
              FocusScope.of(context).unfocus();
              if (_popLockBloc.lock) {
                _popLockBloc.add(PopLockRelease());
                return Future.value(false);
              }
              if (_popAddressBloc.show) {
                _popAddressBloc.add(PopAddressEvent.hide);
                return Future.value(false);
              }
              if (_bottomNavBloc.pageController.page != 0) {
                _bottomNavBloc.add(0);
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _popAddressBloc),
                BlocProvider.value(value: _userDetailsBloc),
                BlocProvider.value(value: _homeSectionBloc),
                BlocProvider.value(value: _orderBloc),
                BlocProvider.value(value: _bottomNavBloc),
                BlocProvider.value(value: _suggestedProductsBloc),
                BlocProvider.value(value: _recepieHomeBloc),
              ],
              child: Padding(
                padding: EdgeInsets.only(top: measure.statusBarHeight),
                child: PageView(
                  controller: _bottomNavBloc.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  // onPageChanged: (newPage) {
                  //   if (newPage == 4) {
                  //     _pageController.animateToPage(
                  //       3,
                  //       duration: const Duration(milliseconds: 10),
                  //       curve: Curves.easeInOut,
                  //     );
                  //     Navigator.of(context).pushNamed(referralHomeRoute);
                  //   }
                  //   setState(() {
                  //     this._cIndex = newPage;
                  //   });
                  // },
                  children: <Widget>[
                    HomeScreen(),
                    RecepieHomeScreen(),
                    CartScreen(),
                    MyOrdersScreen(),
                    MyOrdersScreen(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder(
            cubit: _bottomNavBloc,
            builder: (context, state) => BottomNavigationBar(
              currentIndex: state,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                if (index == 4) {
                  Navigator.of(context).pushNamed(referralHomeRoute);
                  return;
                }
                _bottomNavBloc.add(index);
              },
              fixedColor: AppTheme.primaryColor,
              iconSize: 18 * measure.fontRatio,
              unselectedFontSize: 6 * measure.fontRatio,
              selectedFontSize: 8 * measure.fontRatio,
              unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    freshOkIconSvg,
                    color: state == 0 ? AppTheme.primaryColor : Colors.grey,
                    semanticsLabel: 'A red up arrow',
                    height: 20 * measure.fontRatio,
                  ),
                  title: Text('HOME', style: TextStyle(fontFamily: 'Open Sans')),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood, size: 20 * measure.fontRatio),
                  title: Text('RECIPES', style: TextStyle(fontFamily: 'Open Sans')),
                ),
                BottomNavigationBarItem(
                  icon: BlocProvider.value(
                    value: _cartBloc,
                    child: BadgeIcon(),
                  ),
                  title: Text('CART', style: TextStyle(fontFamily: 'Open Sans')),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.description, size: 20 * measure.fontRatio),
                  title: Text('ORDERS', style: TextStyle(fontFamily: 'Open Sans')),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.share, size: 20 * measure.fontRatio),
                  title: Text('REFER & EARN', style: TextStyle(fontFamily: 'Open Sans')),
                )
              ],
            ),
          ),
        ),
        BlocBuilder(
          cubit: _popAddressBloc,
          builder: (context, state) {
            if (state == false) {
              _editAddressBloc.add(
                EditAddressInitEvent(_userDetailsBloc.userDetails),
              );
            }
            return Positioned(
              bottom: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 150),
                opacity: state ? 1 : 0,
                child: Container(
                  width: measure.width,
                  height: state ? measure.screenHeight : 0,
                  child: Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _popAddressBloc.add(PopAddressEvent.hide);
                            },
                            child: Container(
                              height: measure.screenHeight - 370 - measure.keyboardHeight,
                              width: measure.width,
                              color: Colors.transparent,
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 150),
                            height: state ? 370 : 0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 1,
                                  offset: Offset(0, -1),
                                  color: Color(0x29000000),
                                )
                              ],
                            ),
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: _editAddressBloc),
                                BlocProvider.value(value: _homeSectionBloc),
                                BlocProvider.value(value: _recepieHomeBloc),
                                BlocProvider.value(value: _popAddressBloc),
                              ],
                              child: EditAddressWidget(),
                            ),
                          ),
                          SizedBox(height: measure.keyboardHeight)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      width: 40,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(Icons.shopping_cart, size: 20 * measure.fontRatio),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.cart.cart.length > 0) {
                int count = 0;
                state.cart.cart.forEach((k, v) {
                  if (v > 0) {
                    count++;
                  }
                });
                if (count > 0)
                  return Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        color: AppTheme.cartRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: RegularText(
                        text: count.toString(),
                        color: Colors.white,
                        fontSize: 7,
                      ),
                    ),
                  );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
