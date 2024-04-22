import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/home_controller.dart';
import 'package:seller_finalproject/views/home_screen/home_screen.dart';
import 'package:seller_finalproject/views/orders_screen/orders_screen.dart';
import 'package:seller_finalproject/views/products_screen/products_screen.dart';
import 'package:seller_finalproject/views/profile_screen/profile_screen.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    HomeController controller = Get.put(HomeController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) => controller.navIndex.value = index,
          currentIndex: controller.navIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryApp,
          unselectedItemColor: greyDark1,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                icHome,
                color: controller.navIndex.value == 0 ? primaryApp : greyDark1,
                width: 22,
              ),
              label: dashboard,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                icProducts,
                color: controller.navIndex.value == 1 ? primaryApp : greyDark1,
                width: 22,
              ),
              label: products,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                icOrders,
                color: controller.navIndex.value == 2 ? primaryApp : greyDark1,
                width: 22,
              ),
              label: orders,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                icGeneralSettings,
                color: controller.navIndex.value == 3 ? primaryApp : greyDark1,
                width: 22,
              ),
              label: settings,
            ),
          ],
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: IndexedStack(
              index: controller.navIndex.value,
              children: const [
                HomeScreen(),
                ProductsScreen(),
                OrdersScreen(),
                ProfileScreen()
              ],
            ))
          ],
        ),
      ),
    );
  }
}
