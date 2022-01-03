import 'package:bic_android_web_support/databases/hive_database.dart';
import 'package:hive/hive.dart';


class Boxes {

  static Box<WalletHive> getWallets() => Hive.box<WalletHive>('WalletHive');

}