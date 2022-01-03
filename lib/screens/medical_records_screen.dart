import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class MedicalRecordScreen extends StatefulWidget {
  static const routeName = '/medical_records';

  @override
  _MedicalRecordScreenState createState() {
    return _MedicalRecordScreenState();
  }
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  @override
  void initState() {
  super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }




  String privateKey =
      '0e75aade5bd385616574bd6252b0d810f3f03f013dc43cbe15dc2e21e6ff4f14';




  Future<void> getMessage(String password,String publicKeyString  ) async {
    Credentials credentials;
    EthereumAddress publicAddress;
    credentials = EthPrivateKey.fromHex(privateKey);
    publicAddress = await credentials.extractAddress();
    print("Public Address:- " +publicAddress.toString());
    //
    // publicAddress =  EthereumAddress.fromHex(publicKey);

    if(publicAddress.toString() == publicKeyString.toLowerCase()) {
      Uint8List messageHash = hexToBytes(password);
      Uint8List privateKeyInt = EthPrivateKey.fromHex(privateKey).privateKey ;

      MsgSignature _msgSignature = sign(messageHash, privateKeyInt);


      MsgSignature _msgSignature2 = MsgSignature(_msgSignature.r, _msgSignature.s, _msgSignature.v);

      Uint8List publicKey = privateKeyBytesToPublic(privateKeyInt);


      print(isValidSignature(messageHash,_msgSignature2,publicKey).toString());


    }


  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: ZStack([
          ]
      ),
    ));
  }
}