
import 'package:bic_android_web_support/databases/boxes.dart';
import 'package:bic_android_web_support/databases/hive_database.dart';

import '../providers/wallet.dart';
import '../screens/transfer_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import '../helpers/http_exception.dart'
    as exception;

class WalletView extends StatefulWidget {
  static const routeName = '/view-wallet';

  @override
  _WalletViewState createState() {
    return _WalletViewState();
  }
}

class _WalletViewState extends State<WalletView> {
  final String screenName = "view_wallet.dart";

  CarouselController buttonCarouselController = CarouselController();

  late Credentials credentials;
  late EthereumAddress myAddress;
  late String balanceOfAccount;

  List<String> options = <String>['Select Account'];
  String dropdownValue = 'Select Account';
  String dropDownCurrentValue = 'Select Account';
  late String scannedAddress;

  @override
  void initState() {
    balanceOfAccount = "null";


    setState(() {
      options = <String>['Select Account'];

    });
    getWalletFromDatabase();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    setState(() {
      options = <String>['Select Account'];
    });
    getWalletFromDatabase();
    super.didChangeDependencies();
  }

  Future<void> getWalletFromDatabase() async {
    final box = Boxes.getWallets();
    var dbResponse = box.values.toList().cast<WalletHive>();
    // print(dbResponse.toString());
    dbResponse.forEach((element) {
      print(screenName+" "+element.walletAddress.toString());
      if (options.contains(element.walletAddress)) {
      } else {
        options.add(element.walletAddress);
        setState(() {
          options;
        });
      }
    });
  }

  Future<void> getAccountBalance(String walletAddress) async {


    var balance = await Provider.of<WalletModel>(context, listen: false)
        .getAccountBalance(EthereumAddress.fromHex(walletAddress));
    setState(() {
      balanceOfAccount = balance.getInEther.toString();
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    getWalletFromDatabase();
    print(screenName + " " + options.toString());
    print(screenName + " " + balanceOfAccount.toString());
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(

                      height: 10,
                      child:  ListTile(
                        leading: const Icon(Icons.delete_outlined),
                        title: const Text('Delete Account',style: TextStyle(fontSize: 18),),
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor:Theme.of(context).colorScheme.primary ,

                      ),
                      onTap: () async {
                        // var dbResponse =
                        //     await Provider.of<MyDatabase>(context, listen: false)
                        //         .deleteWallet(WalletTableData(walletAddress: dropDownCurrentValue));
                        // getWalletFromDatabase();
                        // Navigator.of(context).pop();
                      },
                    ),
                    PopupMenuItem(

                      height: 10,
                      child:  ListTile(
                        leading: const Icon(Icons.logout_outlined),
                        title: const Text('Log Out',style: TextStyle(fontSize: 18),),
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor:Theme.of(context).colorScheme.primary ,

                      ),
                      onTap: () async {
                        // var dbResponse =
                        // await Provider.of<MyDatabase>(context, listen: false)
                        //     .deleteWallet(WalletTableData(walletAddress: dropDownCurrentValue));
                        // getWalletFromDatabase();
                        // Navigator.of(context).pop();
                      },
                    ),

                  ],
                ),
              ),
            ]),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).colorScheme.primary,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ZStack([
                    Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        // const Image(image: AssetImage('assets/ethereum.png')),
                        // (context.percentHeight * 10).heightBox,
                        // "\$ Ethers 1".text.xl4.white.bold.center.makeCentered().py16(),
                        // Image(
                        //     image: new AssetImage("assets/icons/ethereum.png"),
                        //     height: 100,
                        //     width: MediaQuery.of(context).size.width,
                        //     fit: BoxFit.cover,
                        //     // scale: 0.8
                        //
                        //     // fit: BoxFit.fitHeight,
                        //     ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CarouselSlider.builder(
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/ethereum.png'),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    balanceOfAccount == "null"
                                        ? "0 ETH"
                                        : "$balanceOfAccount ETH",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              carouselController: buttonCarouselController,
                              options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                viewportFraction: 0.9,
                                aspectRatio: 2.0,
                                initialPage: 2,
                              ),
                            ),
                            DropdownButton<String>(
                                focusColor:
                                    Theme.of(context).colorScheme.secondary,
                                dropdownColor:
                                    Theme.of(context).colorScheme.primary,
                                value: dropdownValue,
                                selectedItemBuilder: (BuildContext context) {
                                  return options.map((String value) {
                                    if (value == "Select Account") {
                                      return Text(
                                        "Select Account",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      );
                                    } else {
                                      return Text(
                                        dropdownValue
                                                .toString()
                                                .substring(0, 5) +
                                            "..." +
                                            dropdownValue
                                                .toString()
                                                .lastChars(5),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      );
                                    }
                                  }).toList();
                                },
                                items: options.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: value == "Select Account"
                                        ? const Text("Select Account")
                                        : Text(
                                            value.toString().substring(0, 5) +
                                                "..." +
                                                value.toString().lastChars(5)),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  buttonCarouselController.animateToPage(
                                      options.indexOf(newValue!),
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                  setState(() {
                                    dropdownValue = newValue;
                                    dropDownCurrentValue = newValue;
                                  });
                                  getAccountBalance(newValue);
                                  print(newValue);
                                },
                                style: Theme.of(context).textTheme.headline5,
                                hint: const Text("Select Account")),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child:  Card(
                            clipBehavior: Clip.hardEdge,
                              color: Theme.of(context).colorScheme.primaryVariant,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText(dropDownCurrentValue),
                              )),


                          ),

                        const SizedBox(
                          height: 50,
                        ),
                        HStack(
                          [
                            FloatingActionButton.extended(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransferScreen(
                                      address: dropDownCurrentValue,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.call_made_outlined),
                              label: const Text('Send'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                const snackBar = SnackBar(
                                    content: Text('Balance Refreshed'));
                                await getAccountBalance(dropDownCurrentValue);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: Icon(Icons.refresh,
                                  color: Theme.of(context).colorScheme.primary),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(14),
                                primary:
                                    Theme.of(context).colorScheme.secondary,
                                onPrimary: Colors.black,
                              ),
                            ),
                            FloatingActionButton.extended(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    title: Text(
                                      "Show the QR Code",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    content: Container(
                                      width: 200,
                                      height: 240,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            QrImage(
                                              data: dropDownCurrentValue ==
                                                      "Select Account"
                                                  ? ""
                                                  : "ethereum:" +
                                                      dropDownCurrentValue,
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                            Text(dropDownCurrentValue)
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("okay"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.qr_code_scanner),
                              label: const Text('Receive'),
                            ),
                          ],
                          alignment: MainAxisAlignment.spaceAround,
                          axisSize: MainAxisSize.max,
                        )
                      ],
                    ),
                  ]),
                  10.heightBox,
                  // SingleChildScrollView(
                  //   child: StreamBuilder(
                  //     stream: _client.pendingTransactions(),
                  //     builder:
                  //         (BuildContext context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         if (snapshot.data != null) {
                  //           return SizedBox(
                  //
                  //             child: SingleChildScrollView(
                  //               child: ExpansionTile(
                  //                         backgroundColor:  Theme.of(context).colorScheme.secondary,
                  //                         leading: Padding(
                  //                           padding: const EdgeInsets.all(8.0),
                  //                           child: Icon(Icons.download_done,color:  Theme.of(context).colorScheme.primary,),
                  //                         ),
                  //                         title: const Text(
                  //                           'Pending',
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                         children: <Widget>[
                  //                           Padding(
                  //                             padding: const EdgeInsets.all(15.0),
                  //                             child: Container(
                  //                               child: Column(
                  //                                 mainAxisAlignment: MainAxisAlignment.start,
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Padding(
                  //                                     padding: const EdgeInsets.only(bottom: 5),
                  //                                     child: Text(
                  //                                       'To: ${snapshot.data}',
                  //                                       style: TextStyle(color: Theme.of(context).colorScheme.primary ),
                  //                                     ),
                  //                                   ),
                  //
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //
                  //                         ],
                  //
                  //                       ),
                  //                     ),
                  //             );
                  //
                  //         }
                  //       }
                  //       return Center(
                  //         child: Text('No Pending Transactions'),
                  //       );
                  //
                  //     },
                  //
                  //   ),
                  // ),

                  // SingleChildScrollView(
                  //   child: FutureBuilder(
                  //     future: DBProviderTransactions.db.getTransaction,
                  //     builder:
                  //         (BuildContext context, AsyncSnapshot<List> snapshot) {
                  //       if (snapshot.hasData) {
                  //         if (snapshot.data != null) {
                  //           return SizedBox(
                  //
                  //             child: SingleChildScrollView(
                  //               child: ListView.builder(
                  //                   shrinkWrap: true,
                  //                   physics: NeverScrollableScrollPhysics(),
                  //                   itemCount: snapshot.data!.length,
                  //                   itemBuilder: (BuildContext context, int position) {
                  //
                  //                     return  Card(
                  //                       color: Theme.of(context).colorScheme.secondary,
                  //                       elevation: 0.0,
                  //                       child: ExpansionTile(
                  //                         backgroundColor:  Theme.of(context).colorScheme.secondary,
                  //                         leading: Padding(
                  //                           padding: const EdgeInsets.all(8.0),
                  //                           child: Icon(Icons.download_done,color:  Theme.of(context).colorScheme.primary,),
                  //                         ),
                  //                         title: const Text(
                  //                           'Successful',
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                         children: <Widget>[
                  //                           Padding(
                  //                             padding: const EdgeInsets.all(15.0),
                  //                             child: Container(
                  //                               child: Column(
                  //                                 mainAxisAlignment: MainAxisAlignment.start,
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Padding(
                  //                                     padding: const EdgeInsets.only(bottom: 5),
                  //                                     child: Text(
                  //                                       'To: ${snapshot.data![position]['toAddress']}',
                  //                                       style: TextStyle(color: Theme.of(context).colorScheme.primary ),
                  //                                     ),
                  //                                   ),
                  //                                   Padding(
                  //                                     padding: const EdgeInsets.only(bottom: 5),
                  //                                     child: Text(
                  //                                       'from: ${snapshot.data![position]['fromAddress']}',
                  //                                       style: TextStyle(color: Theme.of(context).colorScheme.primary ),
                  //                                     ),
                  //                                   ),
                  //                                   Padding(
                  //                                     padding: const EdgeInsets.only(bottom: 5),
                  //                                     child: Text(
                  //                                       'Block Number: ${snapshot.data![position]['blockNumber']}',
                  //                                       style: TextStyle(color: Theme.of(context).colorScheme.primary ),
                  //                                     ),
                  //                                   ),
                  //                                   Padding(
                  //                                     padding: const EdgeInsets.only(bottom: 5),
                  //                                     child: Text(
                  //                                       'Transaction Hash: ${snapshot.data![position]['transactionHash']}',
                  //                                       style: TextStyle(color: Theme.of(context).colorScheme.primary ),
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //
                  //                         ],
                  //                         subtitle: Text(
                  //                           'To: ${snapshot.data![position]['toAddress']}',
                  //                           maxLines: 1,
                  //                           overflow: TextOverflow.fade,
                  //                           softWrap: false,
                  //                         ),
                  //                         trailing: Text('${snapshot.data![position]['value']} ETH',style: TextStyle(
                  //                           fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary
                  //                         ),),
                  //                       ),
                  //                   );}),
                  //             ),
                  //           );
                  //         }
                  //       }
                  //         return Center(
                  //           child: Text('Noch keine Aufgaben erstellt'),
                  //         );
                  //
                  //     },
                  //
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
