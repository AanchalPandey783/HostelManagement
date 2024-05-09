import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minor_proj/resources/widgets/custom_button.dart';
import 'package:minor_proj/resources/widgets/customtextfield.dart';
import 'package:minor_proj/util/routes/routes_names.dart';
import 'package:minor_proj/util/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _hostel;

  final List<String> _hostelNames = [
    'Queens Castle 01',
    'Queens Castle 02',
    'Queens Castle 03',
    'Queens Castle 04',
    'Queens Castle 05',
    'Queens Castle 06',
    'Queens Castle 07',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
    });

    try {
      // Attempt to sign in with provided email and password
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If successful, navigate to the post screen
      Utils.toastMessage('Logged in as ${userCredential.user!.email}😊');
      Navigator.pushNamed(context, RoutesName.post, arguments: 0);
    } catch (e) {
      // If sign in fails, display an error message
      Utils.flushBarErrorMessage(e.toString(), context);
    } finally {
      // Regardless of success or failure, stop loading
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildHostelDropdown() {
    // Widget for building the dropdown button for selecting hostel
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButton<String>(
        hint: const Text('Please choose a hostel'),
        value: _hostel,
        onChanged: (String? newValue) {
          setState(() {
            _hostel = newValue;
          });
        },
        items: _hostelNames.map((String hos) {
          return DropdownMenuItem<String>(
            child: Text(hos),
            value: hos,
          );
        }).toList(),
      ),
    );
  }
bool _isSecurePassword=true;
  Widget togglePassword(){
    return IconButton(onPressed: (){
      setState(() {
        _isSecurePassword=!_isSecurePassword;
      });

    }, icon: _isSecurePassword?Icon(Icons.visibility):Icon(Icons.visibility_off));
  }
  Widget _buildForm() {
    // Widget for building the login form
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
              controller: _emailController,
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
          
          const SizedBox(height: 5),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
              controller: _passwordController,

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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press to exit the app
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Login',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: <Widget>[
                    // Logo images
                    Expanded(
                      child: Image.asset(
                        'assets/images/kiit_logo.png',
                        //width:
                        height: 10,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/images/phone_girl.jpg',
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.01,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      // Login form container
                      padding: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildHostelDropdown(), // Hostel dropdown
                          const SizedBox(height: 10),
                          _buildForm(), // Login form
                          const SizedBox(height: 30),
                          // Login button
                          CustomButton(
                            msg: 'Login',
                            loading: _loading,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _login();
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 12,
                              bottom: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Signup link
                                Text(
                                  "Don't have an account already?",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RoutesName.signUp);
                                  },
                                  child: Text(
                                    'SignUp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Footer text
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
