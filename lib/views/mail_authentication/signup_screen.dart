import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:minor_proj/resources/widgets/custom_button.dart';
import 'package:minor_proj/resources/widgets/customtextfield.dart';
import 'package:minor_proj/util/routes/routes_names.dart';
import 'package:minor_proj/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool loading = false;
  final List<String> hostelNames = [
    'Queens Castle 01',
    'Queens Castle 02',
    'Queens Castle 03',
    'Queens Castle 04',
    'Queens Castle 05',
    'Queens Castle 06',
    'Queens Castle 07',
  ];

  String? hostel;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() async {
    setState(() {
      loading = true;
    });
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );

      // Create user document in Firestore with email and hostel
      final userDocRef =
          firestore.collection('users').doc(userCredential.user!.uid);
      await userDocRef.set({
        'email': emailController.text.toString(),
        'hostel': hostel ?? "Queens Castle 01",
      });

      setState(() {
        loading = false;
      });
      Navigator.pushNamed(context, RoutesName.post,
          arguments: 0); // Adjust navigation as needed
      Utils.toastMessage('User created!');
    } on FirebaseAuthException catch (e) {
      Utils.flushBarErrorMessage(e.message!, context);
      setState(() {
        loading = false;
      });
    } catch (error) {
      Utils.flushBarErrorMessage('Something went wrong!', context);
      print(error);
      setState(() {
        loading = false;
      });
    }
  }

  bool _isSecurePassword = true;
  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSecurePassword = !_isSecurePassword;
          });
        },
        icon: _isSecurePassword
            ? Icon(Icons.visibility)
            : Icon(Icons.visibility_off));
  }

  // void _checkUserExists() async {
  //   String email = emailController.text;
  //   setState(() {
  //     loading = true;
  //   });
  //   await Gsheets()
  //       .readDatafromGSheet(email, hostel ?? "Queens Castle 01")
  //       .then((value) {
  //     setState(() {
  //       loading = false;
  //     });
  //     if (value == true) {
  //       if (kDebugMode) {
  //         print('Found');
  //       }
  //       signUp();
  //     } else {
  //       Utils.toastMessage('Please sign up with your hostel details!');
  //     }
  //   }).onError((error, stackTrace) {
  //     Utils.toastMessage('Error found, please try Again');
  //     print(error.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  //}

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'SignUp',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/images/homle_light_bg.png',
                    // width: screenWidth * 0.15,
                    // height: screenHeight * 0.15,
                    fit: BoxFit.fill,
                  ),
                  Image.asset(
                    'assets/images/phone_girl.jpg',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.2,
                    fit: BoxFit.scaleDown,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              border:
                                  Border.all(color: Colors.black, width: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  offset: const Offset(2, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: DropdownButton(
                                hint: const Text('Please choose a hostel'),
                                value: hostel,
                                onChanged: (newValue) {
                                  setState(() {
                                    hostel = newValue;
                                  });
                                },
                                items: hostelNames.map((hos) {
                                  return DropdownMenuItem(
                                    child: Text(hos),
                                    value: hos,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: TextFormField(
                                  //color: Colors.black,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIconColor: Colors.grey,
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  controller: emailController,
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              // CustomTextField(
                              //   hintText: 'Email',
                              //   color: Colors.black,
                              //   controller: _emailController,
                              //   icon: Icons.email,
                              //   keyboardType: TextInputType.emailAddress,
                              //   obscureText: false,
                              //   validator: (String? value) {
                              //     if (value!.isEmpty) {
                              //       return 'Enter email';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: TextFormField(
                                  //color: Colors.black,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIconColor: Colors.grey,
                                    suffixIconColor: Colors.grey,
                                    suffixIcon: togglePassword(),
                                    prefixIcon: Icon(Icons.password),
                                  ),
                                  controller: passwordController,

                                  obscureText: _isSecurePassword,
                                  keyboardType: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              // CustomTextField(
                              //   hintText: 'Email',
                              //   color: Colors.black,
                              //   controller: emailController,
                              //   icon: Icons.email,
                              //   keyboardType: TextInputType.emailAddress,
                              //   obscureText: false,
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return 'Enter email';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // const SizedBox(
                              //   height: 5,
                              // ),
                              // CustomTextField(
                              //   hintText: 'Password',
                              //   color: Colors.black,
                              //   controller: passwordController,
                              //   icon: Icons.password,
                              //   obscureText: true,
                              //   keyboardType: TextInputType.text,
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return 'Enter password';
                              //     }
                              //     return null;
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          msg: 'SignUp',
                          loading: loading,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              //checkEmailExists();
                              signUp();
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 12, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.login);
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
