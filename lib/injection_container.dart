import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/netowrk/network_info.dart';
import 'core/theme/theme.dart';
import 'core/token/token_provider.dart';
import 'data/datasources/categories/home_sections_remote_datasource.dart';
import 'data/datasources/categories/product_remote_datasource.dart';
import 'data/datasources/categories/recepie_remote_datasource.dart';
import 'data/datasources/chat/chat_remote_datasource.dart';
import 'data/datasources/firebase/firebase_registration_token_datasource.dart';
import 'data/datasources/login/basic_user_local_datasource.dart';
import 'data/datasources/login/basic_user_remote_datasource.dart';
import 'data/datasources/login/otp_handler_remote_datasource.dart';
import 'data/datasources/logout/logout_local_datasource.dart';
import 'data/datasources/misc/image_remote_datasource.dart';
import 'data/datasources/mitra/mitra_remote_datasource.dart';
import 'data/datasources/orders/cart_local_datasource.dart';
import 'data/datasources/orders/cart_remote_datasource.dart';
import 'data/datasources/orders/order_remote_datasource.dart';
import 'data/datasources/orders/payment_remote_datasource.dart';
import 'data/datasources/places/get_places_datasource.dart';
import 'data/datasources/referral/referral_remote_datasource.dart';
import 'data/datasources/registration/register_user_datasource.dart';
import 'data/datasources/user_details/user_details_local_datasource.dart';
import 'data/datasources/user_details/user_details_remote_datasource.dart';
import 'data/repositories/categories/home_section_repository_impl.dart';
import 'data/repositories/categories/product_repository_impl.dart';
import 'data/repositories/categories/recepie_repository_impl.dart';
import 'data/repositories/chat/chat_repository_impl.dart';
import 'data/repositories/firebase/firebase_registration_token_repository_impl.dart';
import 'data/repositories/login/basic_user_repository_impl.dart';
import 'data/repositories/login/otp_handler_repository_impl.dart';
import 'data/repositories/logout/logout_repository_impl.dart';
import 'data/repositories/misc/image_repository_impl.dart';
import 'data/repositories/mitra/mitra_repository_impl.dart';
import 'data/repositories/orders/cart_repository_impl.dart';
import 'data/repositories/orders/order_repository_impl.dart';
import 'data/repositories/orders/payment_repository_impl.dart';
import 'data/repositories/places/get_places_repository_impl.dart';
import 'data/repositories/referral/referral_repository_impl.dart';
import 'data/repositories/registration/register_user_repository_impl.dart';
import 'data/repositories/user_details/renew_user_details_repository_impl.dart';
import 'data/repositories/user_details/user_details_repository_impl.dart';
import 'domain/repositories/categories/home_section_repository.dart';
import 'domain/repositories/categories/product_repository.dart';
import 'domain/repositories/categories/recepie_repository.dart';
import 'domain/repositories/chat/chat_repository.dart';
import 'domain/repositories/firebase/firebase_registration_token_repository.dart';
import 'domain/repositories/login/basic_user_repository.dart';
import 'domain/repositories/login/otp_handler_repository.dart';
import 'domain/repositories/logout/logout_repository.dart';
import 'domain/repositories/misc/image_repository.dart';
import 'domain/repositories/mitra/mitra_repository.dart';
import 'domain/repositories/orders/cart_repository.dart';
import 'domain/repositories/orders/order_repository.dart';
import 'domain/repositories/orders/payment_repository.dart';
import 'domain/repositories/places/get_places_repository.dart';
import 'domain/repositories/referral/referral_repository.dart';
import 'domain/repositories/registerUser/register_user_repository.dart';
import 'domain/repositories/user_details/renew_user_details_repository.dart';
import 'domain/repositories/user_details/user_details_repository.dart';
import 'domain/usecases/categories/get_all_recepies.dart';
import 'domain/usecases/categories/get_cuisines.dart';
import 'domain/usecases/categories/get_dish_types.dart';
import 'domain/usecases/categories/get_home_sections.dart';
import 'domain/usecases/categories/get_liked_recepies.dart';
import 'domain/usecases/categories/get_my_recepies.dart';
import 'domain/usecases/categories/get_products.dart';
import 'domain/usecases/categories/get_products_based_on_search.dart';
import 'domain/usecases/categories/get_recepie_details.dart';
import 'domain/usecases/categories/get_recepie_sections.dart';
import 'domain/usecases/categories/get_recepies.dart';
import 'domain/usecases/categories/get_suggested.dart';
import 'domain/usecases/categories/like_recepie.dart';
import 'domain/usecases/categories/search_products.dart';
import 'domain/usecases/categories/search_recepies.dart';
import 'domain/usecases/chat/get_chat_messages.dart';
import 'domain/usecases/chat/send_chat_message.dart';
import 'domain/usecases/chat/send_feedback.dart';
import 'domain/usecases/login/send_otp.dart';
import 'domain/usecases/login/verify_otp.dart';
import 'domain/usecases/logout/logout_user.dart';
import 'domain/usecases/mitra/get_mitras.dart';
import 'domain/usecases/mitra/set_mitra.dart';
import 'domain/usecases/orders/cancel_order.dart';
import 'domain/usecases/orders/clear_local_cart.dart';
import 'domain/usecases/orders/get_cart_slots.dart';
import 'domain/usecases/orders/get_coupons.dart';
import 'domain/usecases/orders/get_local_cart.dart';
import 'domain/usecases/orders/get_order_details.dart';
import 'domain/usecases/orders/get_orders.dart';
import 'domain/usecases/orders/place_order.dart';
import 'domain/usecases/orders/remove_from_local_cart.dart';
import 'domain/usecases/orders/set_local_cart.dart';
import 'domain/usecases/orders/set_remote_cart.dart';
import 'domain/usecases/places/get_places.dart';
import 'domain/usecases/referral/get_freshOk_credits.dart';
import 'domain/usecases/referral/get_referrals.dart';
import 'domain/usecases/registerUser/register_user.dart';
import 'domain/usecases/services/authentication_service.dart';
import 'domain/usecases/services/dynamic_link_service.dart';
import 'domain/usecases/services/firebase_registration_service.dart';
import 'domain/usecases/services/flutter_local_notif_service.dart';
import 'domain/usecases/services/image_service.dart';
import 'domain/usecases/user_details/get_basic_user.dart';
import 'domain/usecases/user_details/get_user_details.dart';
import 'domain/usecases/user_details/renew_user_details_cache.dart';
import 'domain/usecases/user_details/update_user_details.dart';
import 'presentation/screens/bottom_nav_holder/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/drawer_bloc/drawer_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/edit_address_bloc/edit_address_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/home_section/home_section_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/order_bloc/order_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/place_bloc/place_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/pop_address_bloc/pop_address_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/pop_lock_bloc/pop_lock_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/recepie_home_bloc/recepie_home_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/referral_bloc/referral_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/suggested_products_bloc/suggested_products_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'presentation/screens/cart/cart_screen_bloc/cart_screen_bloc.dart';
import 'presentation/screens/customer_support/chat_bloc/chat_bloc.dart';
import 'presentation/screens/home_search_screen/home_search_bloc/home_search_bloc.dart';
import 'presentation/screens/order_screens/order_details/bloc/order_details_bloc.dart';
import 'presentation/screens/otp_screen/bloc/otp_screen_bloc.dart';
import 'presentation/screens/phone_screen/bloc/phone_screen_bloc.dart';
import 'presentation/screens/product_list_screen/bloc/product_list_bloc.dart';
import 'presentation/screens/profile_screens/edit_profile_bloc/edit_profile_bloc.dart';
import 'presentation/screens/profile_screens/profile_screen/profile_recepie_bloc/profile_recepie_bloc.dart';
import 'presentation/screens/recepie_screens/create_recepie_screen/create_recepie_bloc/create_recepie_bloc.dart';
import 'presentation/screens/recepie_screens/recepie_detail_screen/recepie_detail_bloc/recepie_detail_bloc.dart';
import 'presentation/screens/recepie_screens/recepie_home_screen/recepie_home_card_bloc/recepie_home_card_bloc.dart';
import 'presentation/screens/recepie_screens/recepie_list_screen/bloc/recepie_list_bloc.dart';
import 'presentation/screens/registration_screen.dart/bloc/registration_screen_bloc.dart';
import 'presentation/screens/select_city_area_screen/select_place_bloc/select_place_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  initCore();
  //!bloc
  initBloc();
  //!useCases
  initUseCases();
  //!repositories
  initRepositories();
  //!datasources
  initDatasources();
  //!External
  await initExternal();
}

void initCore() {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<TokenProvider>(
      () => TokenProviderImpl(storage: sl()));
  sl.registerLazySingleton<AppTheme>(() => AppTheme());
}

void initBloc() {
  sl.registerFactory(() => PhoneScreenBloc(sendOtp: sl()));
  sl.registerFactory(() => OtpScreenBloc(sendOtp: sl(), verifyOtp: sl()));
  sl.registerFactory(
    () => RegistrationScreenBloc(
      getPlaces: sl(),
      registerUser: sl(),
      activateReferral: sl(),
      sharedPreferences: sl(),
    ),
  );
  sl.registerFactory(
    () => UserDetailsBloc(
      getUserDetails: sl(),
      renewUserDetailsCache: sl(),
      fcmService: sl(),
      getBasicUser: sl(),
      updateUserDetails: sl(),
      imageService: sl(),
    ),
  );
  sl.registerFactory(() => PopAddressBloc());
  sl.registerFactory(
    () => HomeSectionBloc(
      getHomeSections: sl(),
      getUserDetails: sl(),
    ),
  );
  sl.registerFactory(
    () => ProductListBloc(
      getProducts: sl(),
      getProductsBasesOnSearch: sl(),
    ),
  );
  sl.registerFactory(() => SuggestedProductsBloc(sl()));
  sl.registerFactory(
    () => RecepieListBloc(
      getProducts: sl(),
      getRecepies: sl(),
      likeRecepie: sl(),
    ),
  );
  sl.registerFactory(() => DrawerBloc(sl()));
  sl.registerFactory(() => OrderBloc(sl()));
  sl.registerFactory(() => BottomNavBloc());
  sl.registerFactory(() => OrderDetailsBloc(
        cancelOrder: sl(),
        getOrderDetails: sl(),
      ));
  sl.registerFactory(() => PlaceBloc(sl()));
  sl.registerFactory(
    () => MitraBloc(
      getMitras: sl(),
      setMitra: sl(),
    ),
  );
  sl.registerFactory(() => ReferralBloc(sl()));
  sl.registerFactory(
    () => ChatBloc(
      getChatMessages: sl(),
      tokenProvider: sl(),
      sendChatMessage: sl(),
    ),
  );
  sl.registerFactory(
    () => CartBloc(
      getLocalCart: sl(),
      setLocalCart: sl(),
      removeFromLocalCart: sl(),
      clearLocalCart: sl(),
    ),
  );
  sl.registerFactory(() => EditProfileBloc());
  sl.registerFactory(
    () => CartScreenBloc(
      getCoupons: sl(),
      setRemoteCart: sl(),
      getCartSlots: sl(),
      freshOkCredits: sl(),
      placeOrder: sl(),
      notifService: sl(),
      repository: sl(),
      razorpay: sl(),
    ),
  );
  sl.registerFactory(
    () => ProfileRecepieBloc(
      getLikedRecepies: sl(),
      getMyRecepies: sl(),
      likeRecepie: sl(),
    ),
  );
  sl.registerFactory(() => RecepieDetailBloc(sl(), sl()));
  sl.registerFactory(() => RecepieHomeBloc(sl()));
  sl.registerFactory(
    () => CreateRecepieBloc(
      getCuisines: sl(),
      getDishTypes: sl(),
    ),
  );
  sl.registerFactory(() => RecepieHomeCardBloc(sl()));
  sl.registerFactory(() => SelectPlaceBloc());
  sl.registerFactory(() => PopLockBloc());
  sl.registerFactory(
    () => HomeSearchBloc(
      searchRecepies: sl(),
      searchProducts: sl(),
    ),
  );
}

void initUseCases() {
  sl.registerLazySingleton(
    () => AuthenticationService(
      repository: sl(),
      tokenProvider: sl(),
    ),
  );
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetPlaces(sl()));
  sl.registerLazySingleton(() => GetUserDetails(sl()));
  sl.registerLazySingleton(() => RenewUserDetailsCache(sl()));
  sl.registerLazySingleton(() => UpdateUserDetails(sl()));
  sl.registerLazySingleton(() => ActivateReferral(sl()));
  sl.registerLazySingleton(() => FirebaseRegistrationService(
        firebaseMessaging: sl(),
        repository: sl(),
      ));
  sl.registerLazySingleton(() => FlutterLocalNotifService(sl()));
  sl.registerLazySingleton(() => GetHomeSections(repository: sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductsBasesOnSearch(sl()));
  sl.registerLazySingleton(() => GetSuggested(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetRecepieSections(sl()));
  sl.registerLazySingleton(() => GetRecepies(sl()));
  sl.registerLazySingleton(() => LikeRecepie(sl()));
  sl.registerLazySingleton(() => GetAllRecepies(sl()));
  sl.registerLazySingleton(() => SearchRecepies(sl()));
  sl.registerLazySingleton(() => GetMyRecepies(sl()));
  sl.registerLazySingleton(() => GetLikedRecepies(sl()));
  sl.registerLazySingleton(() => GetRecepieDetails(sl()));
  sl.registerLazySingleton(() => GetDishTypes(sl()));
  sl.registerLazySingleton(() => GetCuisines(sl()));
  sl.registerLazySingleton(() => GetBasicUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => GetOrderDetails(sl()));
  sl.registerLazySingleton(() => CancelOrder(sl()));
  sl.registerLazySingleton(() => GetMitras(sl()));
  sl.registerLazySingleton(() => SetMitra(sl()));
  sl.registerLazySingleton(() => GetReferrals(sl()));
  sl.registerLazySingleton(() => DynamicLinkService(sl()));
  sl.registerLazySingleton(() => GetChatMessages(sl()));
  sl.registerLazySingleton(() => SendChatMessage(sl()));
  sl.registerLazySingleton(() => GetLocalCart(sl()));
  sl.registerLazySingleton(() => SetLocalCart(sl()));
  sl.registerLazySingleton(() => RemoveFromLocalCart(sl()));
  sl.registerLazySingleton(() => ClearLocalCart(sl()));
  sl.registerLazySingleton(() => SetRemoteCart(sl()));
  sl.registerLazySingleton(() => GetCartSlots(sl()));
  sl.registerLazySingleton(() => GetCoupons(sl()));
  sl.registerLazySingleton(() => GetFreshOkCredits(sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  sl.registerLazySingleton(() => EditAddressBloc());
  sl.registerLazySingleton(() => ImageService(sl()));
  sl.registerLazySingleton(() => SendFeedback(sl()));
  // sl.registerLazySingleton(
  //   () => HandleOnlinePayment(
  //     razorpay: sl(),
  //     repository: sl(),
  //   ),
  // );
}

void initRepositories() {
  //*login
  sl.registerLazySingleton<BasicUserRepository>(
    () => BasicUserRepositoryImpl(
      localDatasource: sl(),
      networkInfo: sl(),
      remoteDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<OtpHandlerRepository>(
    () => OtpHandlerRepositoryImpl(
      localDatasource: sl(),
      networkInfo: sl(),
      remoteDatasource: sl(),
    ),
  );

  //*logout
  sl.registerLazySingleton<LogoutRepository>(() => LogoutRepositoryImpl(sl()));

  //*registration
  sl.registerLazySingleton<RegisterUserRepository>(
    () => RegisterUserRepositoryImpl(
      remoteDatasource: sl(),
      userDetailsLocalDatasource: sl(),
      basicUserLocalDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  //*places
  sl.registerLazySingleton<GetPlacesRepository>(
    () => GetPlacesRepositoryImpl(
      networkInfo: sl(),
      datasource: sl(),
    ),
  );

  //*user_details
  sl.registerLazySingleton<UserDetailsRepository>(
    () => UserDetailsRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<RenewUserDetailsRepository>(
    () => RenewUserDetailsRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  //*firebase
  sl.registerLazySingleton<FirebaseRegistrationTokenRepository>(
    () => FirebaseRegistrationTokenRepositoryImpl(
      datasource: sl(),
      networkInfo: sl(),
    ),
  );

  //*categories
  sl.registerLazySingleton<HomeSectionRepository>(
    () => HomeSectionRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      datasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<RecepieRepository>(
    () => RecepieRepositoryImpl(
      datasource: sl(),
      networkInfo: sl(),
    ),
  );

  //*orders
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      localDatasource: sl(),
      networkInfo: sl(),
      remoteDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  //*mitras
  sl.registerLazySingleton<MitraRepository>(
    () => MitraRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  //*referral
  sl.registerLazySingleton<ReferralRepository>(
    () => ReferralRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  //*chat
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  //*misc
  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
}

void initDatasources() {
  //*Login
  sl.registerLazySingleton<BasicUserLocalDatasource>(
      () => BasicUserLocalDatasourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<BasicUserRemoteDatasource>(
    () => BasicUserRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );
  sl.registerLazySingleton<OtpHandlerRemoteDatasource>(
    () => OtpHandlerRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*logout
  sl.registerLazySingleton<LogoutLocalDatasource>(
    () => LogoutLocalDatasourceImpl(
      flutterSecureStorage: sl(),
      sharedPreferences: sl(),
    ),
  );

  //*registration
  sl.registerLazySingleton<RegisterUserDatasource>(
    () => RegisterUserDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*user_details
  sl.registerLazySingleton<UserDetailsLocalDatasource>(
      () => UserDetailsLocalDatasourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<UserDetailsRemoteDatasource>(
    () => UserDetailsRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*places
  sl.registerLazySingleton<GetPlacesDatasource>(
    () => GetPlacesDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*firebase
  sl.registerLazySingleton<FirebaseRegistrationTokenDatasource>(
    () => FirebaseRegistrationTokenDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*categories
  sl.registerLazySingleton<HomeSectionRemoteDatasource>(
    () => HomeSectionRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );
  sl.registerLazySingleton<RecepieRemoteDatasource>(
    () => RecepieRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*orders
  sl.registerLazySingleton<OrderRemoteDatasource>(
    () => OrderRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );
  sl.registerLazySingleton<CartLocalDatasource>(
      () => CartLocalDatasourceImpl(sl()));
  sl.registerLazySingleton<CartRemoteDatasource>(
    () => CartRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );
  sl.registerLazySingleton<PaymentRemoteDatasource>(
    () => PaymentRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*mitras
  sl.registerLazySingleton<MitraRemoteDatasource>(
    () => MitraRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*referral
  sl.registerLazySingleton<ReferralRemoteDatasource>(
    () => ReferralRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*chat
  sl.registerLazySingleton<ChatRemoteDatasource>(
    () => ChatRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
    ),
  );

  //*misc
  sl.registerLazySingleton<ImageRemoteDatasource>(
    () => ImageRemoteDatasourceImpl(
      client: sl(),
      tokenProvider: sl(),
      flutterImageCompress: sl(),
    ),
  );
}

Future<void> initExternal() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton(() => FirebaseMessaging());

  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  sl.registerLazySingleton(() => Razorpay());

  sl.registerLazySingleton(() => FlutterImageCompress());
}
