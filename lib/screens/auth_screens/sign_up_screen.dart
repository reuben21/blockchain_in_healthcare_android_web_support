import 'dart:math';

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


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormBuilderState>();


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
                      const SizedBox(height: 35,),
                      FormBuilderTextField(
                        maxLines: 1,
                        name: 'name',
                        decoration: const InputDecoration(

                          prefixIcon: Icon(Icons.badge),
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            color: Color(0xFF6200EE),
                          ),
                          helperText: 'Helper text',

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 20),
                        ]),
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 15,),
                      FormBuilderTextField(
                        maxLines: 1,
                        name: 'emailId',
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          labelText: 'Email ID',
                          labelStyle: TextStyle(
                            color: kSecondaryColor,
                          ),
                          helperText: 'Enter email Id',

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 20),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15,),

                      FormBuilderTextField(
                        maxLines: 1,
                        name: 'PIN',
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          labelText: 'PIN',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: Color(0xFF6200EE),
                          ),
                          helperText: 'Enter a 6 Digit PIN',

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),


                          FormBuilderValidators.maxLength(context, 6)
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15,),
                      FormBuilderTextField(
                        maxLines: 1,
                        name: 'hospitalAddress',
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.local_hospital,
                          ),
                          labelText: 'Hospital Address',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: Color(0xFF6200EE),
                          ),
                          helperText: 'Enter Hex Hospital Address',

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),

                        ]),

                      ),
                      const SizedBox(height: 15,),
                      FormBuilderTextField(
                        maxLines: 1,
                        name: 'privateAddress',
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_balance_wallet,
                          ),
                          labelText: 'Your Private Address',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: Color(0xFF6200EE),
                          ),
                          helperText: 'Enter Hex Private Address',

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),

                        ]),

                      ),
                      const SizedBox(height: 15,),

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
              MaterialButton(
                minWidth: 50.0,
                color: Theme
                    .of(context)
                    .accentColor,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: kSecondaryColor),
                ),
                onPressed: () async {
                  _formKey.currentState?.save();
                  if (_formKey.currentState?.validate() != null) {

                  } else {
                    print("validation failed");
                  }
                },
              ),
              MaterialButton(
                minWidth: 50.0,
                color: Theme
                    .of(context)
                    .colorScheme.secondary,
                child: const Text(
                  "Login",
                  style: TextStyle(color: kSecondaryColor),
                ),
                onPressed: () async {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen()),);
                },
              ),

              SizedBox(width: 20),

            ],
          )
        ],
      ),
    ));
  }
}