import 'package:minor_proj/util/routes/routes_names.dart';
import 'package:minor_proj/user persona/current_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.setUser();
    final userType = userProvider.user?.userType ?? 'Unknown';
    if (kDebugMode) {
      print('usertype:$userType');
    }
    final name = userProvider.user?.name ?? 'Loading';
    final email = userProvider.user?.email ?? 'Loading';
    final phone = userProvider.user?.number ?? 'Loading';
    final room = userProvider.user?.room ?? 'Loading';

    final themeChange = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/user_girl.jpg',
              ),
              fit: BoxFit.contain,
              opacity: 0.3,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 2.0, 0, 0),
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 28.0,
                          fontFamily: "Sen",
                          fontWeight: FontWeight.w500,
                          height: 1,
                          color: Color.fromRGBO(1, 78, 68, 1)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 2.0, 0, 0),
                    child: Text(
                      "$room",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Sen",
                        color: Color.fromARGB(255, 78, 77, 77),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 106, 131, 76),
                    ),
                    title: Text(email,
                        style: const TextStyle(
                            fontFamily: "Sen",
                            fontSize: 18,
                            color: Colors.black)),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 106, 131, 76),
                    ),
                    title: Text(phone,
                        style: const TextStyle(
                            fontFamily: "Sen",
                            fontSize: 18,
                            color: Colors.black)),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 106, 131, 76),
                    ),
                    title: const Text("Edit details",
                        style: TextStyle(
                            fontFamily: "Sen",
                            fontSize: 18,
                            color: Colors.black)),
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.editScreen);
                    },
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                      title: const Text(
                        "Dark Mode",
                        style: TextStyle(color: Colors.black),
                      ),
                      value: themeChange.darkTheme,
                      onChanged: (bool? value) {
                        themeChange.darkTheme = value!;
                        Fluttertoast.showToast(
                            msg:
                                'Theme changed to ${value ? 'Dark mode' : 'Light mode'}',
                            toastLength: Toast.LENGTH_SHORT);
                      }),
                  // const SizedBox(height: 135.0),
                  SizedBox(
                    height: size.height * 0.179,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
