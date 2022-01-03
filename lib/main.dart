// import 'dart:async';



import 'dart:io';

import 'package:bic_android_web_support/databases/hive_database.dart';
import 'package:bic_android_web_support/screens/auth_screens/login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../providers/ipfs.dart';
import '../providers/patient.dart';
import '../providers/wallet.dart';
import '../screens/Tabs/tabs_screen.dart';
import '../screens/create_wallet.dart';
import '../screens/medical_records_screen.dart';
import '../screens/prescription_screen.dart';
import 'screens/auth_screens/sign_up_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/transfer_screen.dart';
import '../screens/view_wallet.dart';
import '../screens/wallet.dart';
import '../screens/wallet_login.dart';
import '../theme.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore_for_file: prefer_const_constructors
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(WalletHiveAdapter());
  await Hive.openBox<WalletHive>('WalletHive');
  
  runApp(MyApp());


}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (ctx) => PatientsModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => WalletModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => IPFSModel(),
        ),
      ],
      child: Consumer<WalletModel>(
        builder: (ctx, auth, _) => MaterialApp(
          supportedLocales: const [
            Locale('en'),
            Locale('it'),
            Locale('fr'),
            Locale('es'),
          ],
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,

          ],
          debugShowCheckedModeBanner: false,
          title: 'Blockchain in Flutter',
          theme: ThemeData(
            primaryColor: Color(0xff732eca),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color(0xff732eca),
              secondary: Color(0xFFf5f7ec),
              primaryVariant: Color(0xa35e10b3),
            ),
            backgroundColor: Color(0xFFf5f7ec),
            bottomAppBarColor: Color(0xFFf5f7ec),
            textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                  color: Color(0xff732eca),
                  fontSize: 18,
                  fontFamily: 'Handlee'),
              bodyText2: TextStyle(
                color: Color(0xFFf5f7ec),
                fontFamily: 'Handlee',
              ),

              headline6: TextStyle(
                color: kSecondaryColor[100],
                fontSize: 15,
                fontFamily: 'PlayfairDisplay',
              ),
              headline5: GoogleFonts.lato(
                color: Color(0xFFf5f7ec),
                fontSize: 18,
                backgroundColor: Color(0xff732eca),
              ),
              headline4: GoogleFonts.lato(
                  color: Color(0xff732eca),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              headline3: GoogleFonts.lato(
                  color: Color(0xff732eca),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              headline2: GoogleFonts.lato(
                  color: Color(0xFFf5f7ec),
                  fontSize: 40,
                  fontWeight: FontWeight.w500),
              headline1: GoogleFonts.lato(
                  color: Color(0xff732eca),
                  fontSize: 40,
                  fontWeight: FontWeight.w500),
            ),
          ),
          // home: WalletScreen(),
          routes: {
            // '/': (ctx) => Ipfs_screen(),
            '/': (ctx) => SignUpScreen(),
            // '/': (ctx) => WalletView(),
            // '/': (ctx) => Ipfs_screen(),
            PrescriptionScreen.routeName: (ctx) => PrescriptionScreen(),
            MedicalRecordScreen.routeName: (ctx) => MedicalRecordScreen(),
            WalletScreen.routeName: (ctx) => WalletScreen(),
            WalletView.routeName: (ctx) => WalletView(),
            WalletLogin.routeName: (ctx) => WalletLogin(),
            TransferScreen.routeName: (ctx) => TransferScreen(address: '',),
            TabsScreen.routeName: (ctx) => TabsScreen()
          },
        ),
      ),
    );
  }
}

