import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet';

  @override
  _WalletScreenState createState() {
    return _WalletScreenState();
  }
}

class _WalletScreenState extends State<WalletScreen> {
  late EtherAmount bal;
  late BigInt balance;
  late Client httpClient;
  late Web3Client ethClient;
  late String rpcUrl;

  @override
  void initState() {
    super.initState();
    initialSetup();
  }

  Future<void> initialSetup() async {
    httpClient = Client();
    if (Platform.isAndroid) {
      // Android-specific code
      rpcUrl = 'http://10.0.2.2:7545';
    } else if (Platform.isIOS) {
      // iOS-specific code
      rpcUrl = 'http://127.0.0.1:7545';
    }
    ethClient = Web3Client(rpcUrl, httpClient);

    await getCredentials();
  }

  late Credentials credentials;
  late EthereumAddress myAddress;

  String privateKey =
      '0e75aade5bd385616574bd6252b0d810f3f03f013dc43cbe15dc2e21e6ff4f14';

  Future<void> getCredentials() async {
    credentials = await EthPrivateKey.fromHex(privateKey);
    myAddress = await credentials.extractAddress();

    print(await ethClient.getBalance(myAddress));
    bal = await ethClient.getBalance(myAddress);
    setState(() {
      balance = bal.getInEther;
    });
    print(balance);
  }

  Future<void> refreshBalance() async {
    bal = await ethClient.getBalance(myAddress);
    setState(() {
      balance = bal.getInEther;
    });



  }

  Future<DeployedContract> getDeployedContract() async {
    String abi;
    EthereumAddress contractAddress;

    String abiString =
        await rootBundle.loadString('assets/abis/HospitalToken.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "HospitalToken"), contractAddress);
    return contract;
  }

  late ContractFunction balanceOf, coinName, coinSymbol;

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance() async {
    List<dynamic> result = await query("balanceOf", []);

    print(result[0].toString());
  }

  Future<void> getCoinName() async {
    List<dynamic> result = await query("totalSupply", []);

    print(result[0].toString());
  }

  Future<void> getCoinSymbol() async {
    List<dynamic> result = await query("totalSupply", []);

    print(result[0].toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(

          children: [
            ZStack([

              Column(
                children: [


                    const SizedBox(
                      height: 80,
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
                        Container(
                          width: 100,
                          height: 100,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary,
                            image: const DecorationImage(
                                image: AssetImage('assets/icons/ethereum.png'),
                                fit: BoxFit.contain
                            ),
                          ),
                        ),

                        Text("0 ETH", style: Theme.of(context).textTheme.headline2,)
                      ],
                    ),
                  const SizedBox(
                    height: 80,
                  ),
                    HStack(
                      [
                        FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            refreshBalance();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            // Respond to button press
                          },
                          icon: const Icon(Icons.call_made_outlined),
                          label: const Text('Send'),
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            // Respond to button press
                          },
                          icon: const Icon(Icons.call_received_outlined),
                          label: const Text('Recieve'),
                        ),
                      ],
                      alignment: MainAxisAlignment.spaceAround,
                      axisSize: MainAxisSize.max,
                    )

                ],
              ),
            ]),
            10.heightBox,
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: ListView(
                  children: const [
                    Card(
                      elevation: 0.0,
                      child: ListTile(
                        leading: Icon(Icons.download_done),
                        title: Text(
                          'Received',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'From: 0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        trailing: Text('+ 0,0012 ETH'),
                      ),
                    ),
                    Card(
                      elevation: 0.0,
                      child: ListTile(
                        leading: Icon(Icons.download_done),
                        title: Text(
                          'Received',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        trailing: Text('+ 2 ETH'),
                      ),
                    ),
                    Card(
                      elevation: 0.0,
                      child: ListTile(
                        leading: Icon(Icons.download_done),
                        title: Text(
                          'Sent',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '0xE1ab66A6f9157b  02C32DE2682B0Fea298eA0b3eE',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        trailing: Text('- 0,003 ETH'),
                      ),
                    ),
                    Card(
                      elevation: 0.0,
                      child: ListTile(
                        leading: Icon(Icons.download_done),
                        title: Text(
                          'Recieved',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        trailing: Text('+ 0,0220 ETH'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
