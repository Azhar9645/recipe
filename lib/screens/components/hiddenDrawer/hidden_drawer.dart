import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {

  List<ScreenHiddenDrawer>_pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
       screens: [
        // AboutScreen(),
        // SettingsScreen(),
        // HelpScreen(),
        // LogoutScreen(),
      ], backgroundColorMenu: Color(0xFFC1C1C1));
  }
}
