import 'dart:convert';

import '../providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:web3dart/credentials.dart';

class TransferScreen extends StatefulWidget {
  static const routeName = '/transfer-screen';

  final String address;

  const TransferScreen({required this.address});

  @override
  _TransferScreenState createState() {
    return _TransferScreenState();
  }
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  late QRViewController controller;

  late String dropDownCurrentValue;
  late String scannedAddress;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color:Theme.of(context).colorScheme.secondary,

              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Center(
                  child: Column(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            "Transfer Ether",
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30,top: 30),
                          child: Text(
                            "From: "+widget.address,
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Text((result != null)
                          ? "Ethereum Address: " + result.code.toString()
                          : "Scan for Address"),
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () {
                          // do something
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              title: Text(
                                "Show the QR Code",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              content: Container(
                                width: 300,
                                height: 500,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 300,
                                      height: 400,
                                      child: QRView(
                                        key: qrKey,
                                        onQRViewCreated: _onQRViewCreated,
                                      ),
                                    ),
                                    Text((result != null)
                                        ? "Ethereum Address: " + result.code.toString()
                                        : "Scan for Address"),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      scannedAddress = result.code.toString();
                                    });
                                  },
                                  child: Text("GET"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {},
                                  child: Text("okay"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Center(
                        child: FormBuilder(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    child: FormBuilderTextField(
                                      maxLines: 1,
                                      name: 'address',
                                      decoration: const InputDecoration(
                                          labelText: 'Receiver Address',
                                        prefixIcon:
                                            Icon(Icons.account_balance_wallet_outlined),
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                      ),

                                      // valueTransformer: (text) => num.tryParse(text),
                                      validator: FormBuilderValidators.compose(
                                          [FormBuilderValidators.required(context)]),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    child: FormBuilderTextField(
                                      maxLines: 1,
                                      name: 'amount',

                                      decoration: const InputDecoration(
                                        labelText: 'Amount',
                                        prefixIcon: Icon(Icons.paid_outlined),
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                      ),

                                      // valueTransformer: (text) => num.tryParse(text),
                                      validator: FormBuilderValidators.compose(
                                          [FormBuilderValidators.required(context)]),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    child: FormBuilderTextField(
                                      maxLines: 1,
                                      name: 'password',

                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: Icon(Icons.paid_outlined),
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Color(0xFF6200EE)),
                                        ),
                                      ),

                                      // valueTransformer: (text) => num.tryParse(text),
                                      validator: FormBuilderValidators.compose(
                                          [FormBuilderValidators.required(context)]),
                                    )),
                                ElevatedButton(
                                  onPressed: () async {
                                    Credentials credentialsNew;
                                    EthereumAddress myAddress;
                                    _formKey.currentState?.save();
                                    if (_formKey.currentState?.validate() != null) {
                                      String amount = _formKey
                                          .currentState?.value["amount"];
                                      String receiverAddress = _formKey
                                          .currentState?.value["address"];
                                      String password = _formKey
                                          .currentState?.value["password"];
                                      // var dbResponse =
                                      // await DBProviderWallet.db.getWalletByWalletAddress(widget.address);
                                      // print(dbResponse);

                                      if (true) {

                                        Wallet newWallet = Wallet.fromJson(" ", password);
                                        credentialsNew = newWallet.privateKey;
                                        myAddress = await credentialsNew.extractAddress();
                                        print(myAddress);
                                       var txStatus = await Provider.of<WalletModel>(context, listen: false)
                                            .transferEther(credentialsNew, myAddress.hex ,receiverAddress,amount);
                                        if (txStatus) {
                                          Navigator.pop(context);
                                        }
                                      }

                                    }
                                  },
                                  child: const Text("Transfer"),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
