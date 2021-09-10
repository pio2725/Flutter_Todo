import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  startAuthentication() {
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formKey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try {
      if (isLoginPage) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 50),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Incorrect Username";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Username",
                          hintText: "Enter Username"),
                    ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Incorrect Email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Email",
                        hintText: "Enter Email"),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Incorrect password";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Password",
                        hintText: "Enter password"),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 70,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () {
                        startAuthentication();
                      },
                      child: isLoginPage
                          ? Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? Text("Not a Member?")
                          : Text("Already a Member?"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
