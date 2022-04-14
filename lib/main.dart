import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:localport_alter/pages/SplashScreen/LoadingPage.dart';
import 'package:localport_alter/services/ApiServices/localport_authentication_services.dart';
import 'package:localport_alter/services/ApiServices/localport_balance_fetch_service.dart';
import 'package:localport_alter/services/ApiServices/localport_demand_service.dart';
import 'package:localport_alter/services/ApiServices/localport_homepage_service.dart';
import 'package:localport_alter/services/ApiServices/localport_invoice_download_service.dart';
import 'package:localport_alter/services/ApiServices/localport_invoice_month_service.dart';
import 'package:localport_alter/services/ApiServices/localport_order_detail_service.dart';
import 'package:localport_alter/services/ApiServices/localport_order_history_services.dart';
import 'package:localport_alter/services/ApiServices/localport_order_place_service.dart';
import 'package:localport_alter/services/ApiServices/localport_transaction_service.dart';
import 'package:localport_alter/services/ApiServices/localport_user_verification_service.dart';
import 'package:localport_alter/services/ApiServices/localport_money_add_service.dart';
import 'package:localport_alter/services/ApiServices/vendor_registration_service.dart';
import 'package:localport_alter/services/add_money_page_service.dart';
import 'package:localport_alter/services/auth/code_resend_timer_service.dart';
import 'package:localport_alter/services/auth/signin_with_phonenumber.dart';
import 'package:localport_alter/services/deliveryType_neworderpage_service.dart';
import 'package:localport_alter/services/invoice/invoice_page_service.dart';
import 'package:localport_alter/services/location_locality_service.dart';
import 'package:localport_alter/services/new_order_address_service.dart';
import 'package:localport_alter/services/new_orderpage_round_trip_service.dart';
import 'package:localport_alter/services/not_vendor_animation_service.dart';
import 'package:localport_alter/services/order_history_page_service.dart';
import 'package:localport_alter/services/order_placed_service.dart';
import 'package:localport_alter/services/package_content_text_servic.dart';
import 'package:localport_alter/services/package_weight_text_service.dart';
import 'package:localport_alter/services/places_search_service.dart';
import 'package:localport_alter/services/receiver_contact_service.dart';
import 'package:localport_alter/services/splash_screen_service.dart';
import 'package:localport_alter/services/vendor_information_service.dart';
import 'package:provider/provider.dart';
import 'services/profile_page_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VendorInformationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SigninWithPhoneNumber(),
        ),
        ChangeNotifierProvider(
          create: (_) => VendorRegistrationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SplashScreenService(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderHistoryPageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalportOrderDetailsServce(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotVendorAnimationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => localportAuthenticationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => localportUserVerificationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeliveryTypeOrderPage(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewOrderAddressService(),
        ),
        ChangeNotifierProvider(
          create: (_) => PackageContentTextService(),
        ),
        ChangeNotifierProvider(
          create: (_) => PackageWeightTextService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationLocalityService(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlacesSearchService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfilePageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => localportOrderPlaceService(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderPlacedService(),
        ),
        ChangeNotifierProvider(
          create: (_) => localportOrderHistoryServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalportHomePageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => CodeResendTimerService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddMoneyPageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalportMoneyAddService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalportBalanceFetchService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalportTransactionService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReceiverContactService(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewOrderPageRoundTripService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalportDemandService(),
        ),
        ChangeNotifierProvider(
          create: (_) => InvoicePageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalportInvoiceMonthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalportInvoiceDownloadService(),
        ),
      ],
      child: MaterialApp(
        title: 'Localport- Hyperlocal delivery services',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoadingPage(),
      ),
    );
  }
}
