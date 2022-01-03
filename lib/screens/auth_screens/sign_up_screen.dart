import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/patient.dart';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

import '../../theme.dart';

class SignUpScreen extends StatefulWidget {
  // SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormBuilderState>();

  void _submit(String name,String emailId,String password) async {
    try {
      auth.createUserWithEmailAndPassword(email:  emailId, password: password).then((value) => {

        users
            .add({
          'id':value.user?.uid,
          'full_name': name,
        })
            .then((value) => print("User Added"))
      });
    }   catch (error)  {
      _showErrorDialog(error.toString());

    }


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
    return Scaffold(body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 35,),
                      Center(child: Image.asset("assets/images/sign_up.png")),
                      const SizedBox(
                        height: 120,
                      ),
                      Text(
                        'Sign Up With Us',
                        style: titleText,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: FormBuilderTextField(

                            maxLines: 1,
                            name: 'name',
                            decoration: InputDecoration(
                              labelText:'Full Name',
                              prefixIcon:
                              Icon(Icons.person_outlined,color: Theme.of(context).primaryColor,),
                              border: const OutlineInputBorder(),
                              labelStyle: const TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6200EE)),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6200EE)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),

                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: FormBuilderTextField(

                            maxLines: 1,
                            name: 'emailId',
                            decoration: const InputDecoration(
                              labelText:'Email ID',
                              prefixIcon:
                              Icon(Icons.alternate_email_outlined),
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
                          padding: const EdgeInsets.all(15),
                          child: FormBuilderTextField(
                            obscureText: true,
                            maxLines: 1,
                            name: 'password',
                            decoration: InputDecoration(
                              labelText:'Password',
                              prefixIcon:
                              Icon(Icons.password,color: Theme.of(context).primaryColor,),
                              border: const OutlineInputBorder(),
                              labelStyle: const TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6200EE)),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6200EE)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),

                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                          )),





                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            //Center Row contents vertically,
            children: <Widget>[
              FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () async {
                  _formKey.currentState?.save();
                  if (_formKey.currentState?.validate() != null) {


                    _submit(_formKey.currentState?.value["name"],_formKey.currentState?.value["emailId"],_formKey.currentState?.value["password"]);




                  } else {
                    print("validation failed");
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => WalletLogin(),
                  //   ),
                  // );
                },
                icon: Image.asset("assets/icons/sign_in.png",color: Theme.of(context).backgroundColor,width: 32,height: 32,),
                label: const Text('Register'),
              ),






            ],
          )
        ],
      ),
    ));
  }
}