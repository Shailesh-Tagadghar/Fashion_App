import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:fashion/Modules/Home/cart.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Modules/Home/home.dart';
import 'package:fashion/Modules/Home/profile.dart';
import 'package:fashion/Modules/Home/search.dart';
import 'package:fashion/Modules/Home/wishlist.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the AuthController instance from GetX
    final HomeController controller = Get.find<HomeController>();

    final List<Widget> pages = [
      Home(),
      Cart(),
      Wishlist(),
      Search(),
      Profile(),
    ];

    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      extendBody: true,
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () {
          return CrystalNavigationBar(
            indicatorColor: ColorConstants.whiteColor,
            curve: Curves.linear,
            splashColor: ColorConstants.whiteColor,
            selectedItemColor: ColorConstants.rich,
            unselectedItemColor: ColorConstants.whiteColor,
            splashBorderRadius: 100,
            marginR: EdgeInsets.only(
              left: 6.w,
              right: 6.w,
              top: 2.h,
              bottom: 2.h,
            ),
            backgroundColor: ColorConstants.transparent,
            borderRadius: 60,
            items: <CrystalNavigationBarItem>[
              CrystalNavigationBarItem(
                icon: Icons.home,
                selectedColor: ColorConstants.rich,
                unselectedColor: ColorConstants.whiteColor,
              ),
              CrystalNavigationBarItem(
                icon: Icons.shopping_bag_outlined,
                selectedColor: ColorConstants.rich,
                unselectedColor: ColorConstants.whiteColor,
              ),
              CrystalNavigationBarItem(
                icon: Icons.favorite_border,
                selectedColor: ColorConstants.rich,
                unselectedColor: ColorConstants.whiteColor,
              ),
              CrystalNavigationBarItem(
                icon: Icons.message_outlined,
                selectedColor: ColorConstants.rich,
                unselectedColor: ColorConstants.whiteColor,
              ),
              CrystalNavigationBarItem(
                icon: Icons.person_pin,
                selectedColor: ColorConstants.rich,
                unselectedColor: ColorConstants.whiteColor,
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.onItemTapped(index),
          );
        },
      ),
    );
  }
}
