import '../../screens/medical_records_screen.dart';
import '../../screens/prescription_screen.dart';
import '../../screens/view_wallet.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {

  static const routeName = '/tabs-screen';


  @override
  _TabsScreenState createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {

  late List<Map<String, Object>> _pages;
  late List<Map<String, Widget>> _screens;

  @override
  void initState() {
    _pages = [
      { 'title': 'Record'},
      { 'title': 'Medicine'},
      { 'title': 'Wallet'}
    ];
    _screens = [
      {'page':MedicalRecordScreen()  },
      {'page':PrescriptionScreen() },
      {'page':WalletView() }
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_pages[_selectPageIndex]['title'].toString()),
      // ),
      body: _screens[_selectPageIndex]['page'],
      bottomNavigationBar: BottomNavyBar(
        // backgroundColor: Theme.of(context).bottomAppBarColor,
        // unselectedItemColor: Colors.white,

        showElevation: true,
        itemCornerRadius: 24,
        selectedIndex: _selectPageIndex,
        onItemSelected: _selectPage,
        items: <BottomNavyBarItem> [
          BottomNavyBarItem(activeColor:Theme.of(context).primaryColor,icon: Image.asset("assets/icons/medical_history.png",color: Theme.of(context).primaryColor,width: 32,height: 32,), title: Text('Record',style: TextStyle(color: Theme.of(context).primaryColor),)),
          BottomNavyBarItem(activeColor:Theme.of(context).primaryColor,icon: Image.asset("assets/icons/medicine.png",color: Theme.of(context).primaryColor,width: 32,height: 32), title: Text('Medicine',style: TextStyle(color: Theme.of(context).primaryColor),)),
          BottomNavyBarItem(activeColor:Theme.of(context).primaryColor,icon: Image.asset("assets/icons/wallet.png",color: Theme.of(context).primaryColor,width: 32,height: 32), title: Text('Wallet',style: TextStyle(color: Theme.of(context).primaryColor),))
        ],
      ),
    );
  }
}