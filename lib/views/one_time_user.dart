//import 'package:minor_proj/gsheets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_proj/util/routes/routes_names.dart';
import 'package:minor_proj/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserOneTimeDetailScreen extends StatefulWidget {
  const UserOneTimeDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserOneTimeDetailScreen> createState() =>
      _UserOneTimeDetailScreenState();
}

class _UserOneTimeDetailScreenState extends State<UserOneTimeDetailScreen> {
  bool loading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  void _checkUserExists() async {
    final userId = auth.currentUser!.uid;
    final userDocRef = firestore.collection('users').doc(userId);

    try {
      final docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
        // User exists in Firestore
        final userData = docSnapshot.data();
        if (kDebugMode) {
          print('User data: $userData');
        }
        Navigator.pushNamed(context, RoutesName.post, arguments: 0);
      } else {
        // User not found, handle appropriately
        Utils.toastMessage('User not found in Firestore!');
      }
    } catch (error) {
      // Handle errors during Firestore access
      Utils.toastMessage('Failed to check user details: $error');
    } finally {
      setState(() {
        loading = false;
      });
    }
  } 
  // void _checkEmailExists() async {
  //   Gsheets().storingDetails(context).then((value) {
  //     if (kDebugMode) {
  //       print('Stored');
  //     }
  //     Navigator.pushNamed(context, RoutesName.post, arguments: 0);

  // }).onError((error, stackTrace) {
  //   Utils.toastMessage('Something went wrong!');
  //   setState(() {
  //     loading = false;
  //   });
  //
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //_checkEmailExists();
    _checkUserExists();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text('Fetching your details'),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
