import 'package:admintruspare/views/side_bar_screens/banner_upload_screen.dart';
import 'package:admintruspare/views/side_bar_screens/categories_screen.dart';
import 'package:admintruspare/views/side_bar_screens/dashboard_Screen.dart';
import 'package:admintruspare/views/side_bar_screens/orders_screen.dart';
import 'package:admintruspare/views/side_bar_screens/product_screen.dart';
import 'package:admintruspare/views/side_bar_screens/vendors_screen.dart';
import 'package:admintruspare/views/side_bar_screens/withdrawal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = DashboardScreen();

  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });
        break;
      case BannerScreen.routeName:
        setState(() {
          _selectedItem = BannerScreen();
        });
        break;
      case CategoriesScreen.routeName:
        setState(() {
          _selectedItem = CategoriesScreen();
        });
        break;
      case OrdersScreen.routeName:
        setState(() {
          _selectedItem = OrdersScreen();
        });
        break;
      case ProductScreen.routeName:
        setState(() {
          _selectedItem = ProductScreen();
        });
        break;
      case VendorsScreen.routeName:
        setState(() {
          _selectedItem = VendorsScreen();
        });
        break;
      case WithdrawalScreen.routeName:
        setState(() {
          _selectedItem = WithdrawalScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("TruSpare Admin"),
      ),
      sideBar: SideBar(
        items: [
          AdminMenuItem(
              title: 'Dashboard',
              icon: Icons.dashboard_customize_sharp,
              route: DashboardScreen.routeName),
          AdminMenuItem(
              title: 'Vendors',
              icon: Icons.people_alt_sharp,
              route: VendorsScreen.routeName),
          AdminMenuItem(
              title: 'Withdrawal',
              icon: Icons.currency_rupee,
              route: WithdrawalScreen.routeName),
          AdminMenuItem(
              title: 'Orders',
              icon: Icons.shopping_cart,
              route: OrdersScreen.routeName),
          AdminMenuItem(
              title: 'Categories',
              icon: Icons.category_sharp,
              route: CategoriesScreen.routeName),
          AdminMenuItem(
              title: 'Upload Banners',
              icon: Icons.post_add_sharp,
              route: BannerScreen.routeName),
          AdminMenuItem(
              title: 'Products',
              icon: Icons.production_quantity_limits_sharp,
              route: ProductScreen.routeName),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector((item));
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Truspare',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: _selectedItem,
    );
  }
}
