import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/home_controller.dart';
import 'package:seller_finalproject/views/home_screen/home_screen.dart';
import 'package:seller_finalproject/views/orders_screen/orders_screen.dart';
import 'package:seller_finalproject/views/products_screen/products_screen.dart';
import 'package:seller_finalproject/views/profile_screen/profile_screen.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navScreen = [
      const HomeScreen(),
      const ProductsScreen(),
      const OrdersScreen(),
      const ProfileScreen()
    ];

    var bottomNavbar = [
      BottomNavigationBarItem(
          icon: Image.asset(
            icHome,
            color: fontGrey,
            width: 22,
          ),
          label: dashboard),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProducts,
            color: fontGrey,
            width: 22,
          ),
          label: products),
      BottomNavigationBarItem(
          icon: Image.asset(
            icOrders,
            color: fontGrey,
            width: 22,
          ),
          label: orders),
      BottomNavigationBarItem(
          icon: Image.asset(
            icGeneralSettings,
            color: fontGrey,
            width: 22,
          ),
          label: settings),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          controller.navIndex.value = index;
        },
        currentIndex: controller.navIndex.value,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: fontBlack,
        unselectedItemColor: fontBlack,
        items: bottomNavbar,
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreen.elementAt(controller.navIndex.value))
          ],
        ),
      ),
    );
  }
}
