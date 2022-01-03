import 'dart:convert';


import '../helpers/keys.dart' as keys;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class Patient {
  final String name;
  final String personalDetails;
  final String signatureHash;
  final EthereumAddress hospitalAddress;
  final EthereumAddress walletAddress;



  Patient(
      {required this.name,
        required this.personalDetails,
        required this.signatureHash,
        required this.hospitalAddress,
        required this.walletAddress});
}


class PatientsModel with ChangeNotifier {
  late EtherAmount bal;
  late BigInt balance;
  late bool isLoading = true;
  late Web3Client _client;
  // String _abiCode;
  // Credentials _credentials;
  // EthereumAddress _contractAddress;
  // EthereumAddress _ownAddress;
  // DeployedContract _contract;
  late ContractFunction _registerPatient;
  late ContractFunction _getPatientData;
  // ContractFunction _getUserAddress;
  late ContractFunction _getSignatureHash;
  // ContractFunction _getNewRecords;
  // ContractFunction _updatePatientMedicalRecords;


  final String _rpcUrl = keys.rpcUrl;



  PatientsModel(){
    initiateSetup();
  }

  Future<void> initiateSetup() async {

    _client = Web3Client(_rpcUrl, Client());

    getDeployedContract();
  }



  Future<DeployedContract> getDeployedContract() async {
    String abi;
    EthereumAddress contractAddress;

    String abiString =
    await rootBundle.loadString('assets/abis/Patient.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "Patient"), contractAddress);
    print("Patient Contract Address:- "+contract.address.toString());
    _registerPatient = contract.function('registerPatient');
    _getSignatureHash = contract.function('getSignatureHash');
    _getPatientData = contract.function('getPatientData');

    return contract;
  }




  Future<void> registerPatient(Patient patient,Credentials credentials) async {
    isLoading = true;
    notifyListeners();


    await writeContract(_registerPatient,[patient.name,
      patient.personalDetails,
      patient.hospitalAddress,
      patient.walletAddress,
      patient.signatureHash],credentials);

  }

  Future<void> getSignatureHash(Patient patient) async {
    isLoading = true;
    notifyListeners();
    List<dynamic> result = await readContract(_getSignatureHash,
        [patient.walletAddress]);

    print(result);

  }

  Future<void> getPatientData(Patient patient) async {
    isLoading = true;
    notifyListeners();
    List<dynamic> result = await readContract(_getPatientData, [patient.walletAddress]);

    print(result);

  }

  Future<List<dynamic>> readContract(
      ContractFunction functionName,
      List<dynamic> functionArgs,
      ) async {
    final contract = await getDeployedContract();
    var queryResult = await _client.call(
      contract: contract,
      function: functionName,
      params: functionArgs,
    );

    return queryResult;
  }

  Future<void> writeContract(
      ContractFunction functionName,
      List<dynamic> functionArgs,
      Credentials credentials
      ) async {
    final contract = await getDeployedContract();
    await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract:  contract,
        function: functionName,
        parameters: functionArgs,
      ),
    );


  }

}