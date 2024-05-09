import 'package:minor_proj/resources/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'resources/colors.dart';
import 'util/routes/routes_names.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
                 children: [
                  const SizedBox(
                  height: 5,
                ),
                Image.asset('assets/images/kiit_logo.png',
                height: h * 0.2,  
                width: w* 0.7,
                ),
                  
                Image.asset('assets/images/homle_light_bg.png',
                // height: h * 0.5,
                // width: w* 0.2,
                ), 
                const SizedBox(
                  height: 2,
                ),
                Image.asset(
                  'assets/images/phone_girl.jpg',
                  width: w,
                  height: h * 0.34,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    const Text("Hostel Management",
                        style: TextStyle(
                          fontFamily: 'Inter',
                            color: primary,
                            fontSize: 30,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text("made easy",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                        msg: 'Get Started',
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.signUp);
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ) 
              ],
            ),
          ),
        ),
      );
    }));
  }
}
