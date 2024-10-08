// import 'package:flutter/material.dart';

import 'package:fashion/Modules/Auth/address.dart';
import 'package:fashion/Modules/Auth/forgot_password.dart';
import 'package:fashion/Modules/Auth/sign_in.dart';
import 'package:fashion/Modules/Auth/sign_up.dart';
import 'package:fashion/Modules/Auth/user_detail.dart';
import 'package:fashion/Modules/Home/Widget/profile_widget.dart';
import 'package:fashion/Modules/Home/cart.dart';
import 'package:fashion/Modules/Home/checkout.dart';
import 'package:fashion/Modules/Home/coupon.dart';
import 'package:fashion/Modules/Home/home.dart';
import 'package:fashion/Modules/Home/navbar.dart';
import 'package:fashion/Modules/Home/productdetails.dart';
import 'package:fashion/Modules/Home/profile.dart';
import 'package:fashion/Modules/Home/search.dart';
import 'package:fashion/Modules/Home/wishlist.dart';
import 'package:fashion/Modules/Splash/splash_screen.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:get/get.dart';

const Transition transition = Transition.cupertino;

class AppPages {
  ///
  /// Define Initial Screen Route
  ///
  static const initial = AppRoutes.splashScreen;

  ///
  /// Static list of routes with Page name, Route name & Transition
  ///
  static final routes = [
    GetPage(
        name: AppRoutes.splashScreen,
        page: () => SplashScreen(),
        transition: transition),
    GetPage(
        name: AppRoutes.signUpScreen,
        page: () => Signup(),
        transition: transition),
    GetPage(
        name: AppRoutes.signInScreen,
        page: () => SignIn(),
        transition: transition),
    GetPage(
        name: AppRoutes.forgotPassScreen,
        page: () => ForgotPassword(),
        transition: transition),
    GetPage(
        name: AppRoutes.userDetailScreen,
        page: () => UserDetail(),
        transition: transition),
    GetPage(
        name: AppRoutes.addressScreen,
        page: () => Address(),
        transition: transition),
    GetPage(
        name: AppRoutes.navbarScreen,
        page: () => const Navbar(),
        transition: transition),
    GetPage(
        name: AppRoutes.profileScreen,
        page: () => Profile(),
        transition: transition),
    GetPage(
        name: AppRoutes.profilewidgetScreen,
        page: () => const ProfileWidget(),
        transition: transition),
    GetPage(
        name: AppRoutes.searchScreen,
        page: () => Search(),
        transition: transition),
    GetPage(
        name: AppRoutes.homeScreen, page: () => Home(), transition: transition),
    GetPage(
        name: AppRoutes.cartScreen,
        page: () => const Cart(),
        transition: transition),
    GetPage(
        name: AppRoutes.wishlistScreen,
        page: () => Wishlist(),
        transition: transition),
    GetPage(
        name: AppRoutes.couponScreen,
        page: () => Coupon(),
        transition: transition),
    GetPage(
        name: AppRoutes.productDetailsScreen,
        page: () => Productdetails(),
        transition: transition),
    GetPage(
        name: AppRoutes.checkoutScreen,
        page: () => const Checkout(),
        transition: transition),
  ];
}
