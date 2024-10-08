
import 'package:minor_proj/resources/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minor_proj/resources/widgets/admin_complaint.dart';
import 'package:minor_proj/resources/widgets/user_complaint_container.dart';
import 'package:minor_proj/util/routes/routes_names.dart';
import 'package:minor_proj/user persona/current_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MComplainScreen extends StatefulWidget {
  const MComplainScreen({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MComplainScreen> {
  TextEditingController nameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserProvider>(context);
    userProvider.setUser();
    final userType = userProvider.user?.userType ?? 'Unknown';
    if (kDebugMode) {
      print('usertype:$userType');
    }

    return Padding(
      padding: EdgeInsets.only(top: screenHeight / 30),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: (userType == "Regular")
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Complaints Status',
                                style: TextStyle(
                                  color:Color.fromRGBO(1, 78, 68, 255),
                                  fontFamily: "Sen",
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.add, size: 30, color: Theme.of(context).colorScheme.tertiary,),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RoutesName.addComplain);
                            },
                          ),
                          const SizedBox( 
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('complaints')
                          .where('uid', isEqualTo: user!.uid.toString())
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData) {
                          return Container(
                            color: Colors.white,
                            child: const Center(
                              child: SpinKitFadingCube(
                                color: primary,
                                size: 100.0,
                              ),
                            ),
                          );
                        }

                        final announcementDocs = snapshot.data!.docs;

                        if (announcementDocs.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 70,
                                ),
                                Image.asset(
                                  'assets/images/no_complaint.jpg',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.scaleDown,
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: announcementDocs.length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            final announcement = announcementDocs[index].data()
                                as Map<String, dynamic>?;
                                final user_announce = announcementDocs[index].data()
                                as Map<String, dynamic>?;
                            final title =
                                announcement?['title'] as String? ?? "";

                            final description =
                                announcement?['description'] as String? ?? "";
                            final status =
                                announcement?['status'] as String? ?? "";
                            final timestamp = announcement?['date'];
                            final time = DateTime.parse(timestamp);
                            final name = announcement?['name'] as String? ?? "";
                            final room = announcement?['room'] as String? ?? "";
                            return ComplainContainer(
                              title: title,
                              description: description,
                              timestamp: time,
                              name: name,
                              room: room,
                              status: status,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            : (userType == "admin")
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'All Complaints Status',
                                    style: TextStyle(
                                      color: Color.fromRGBO(139, 140, 142, 1),
                                      fontFamily: "Sen",
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add, size: 30),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.addComplain);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('complaints')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData) {
                              return Container(
                                color: Colors.white,
                                child: const Center(
                                  child: SpinKitFadingCube(
                                    color: primary,
                                    size: 100.0,
                                  ),
                                ),
                              );
                            }

                            final announcementDocs = snapshot.data!.docs;

                            if (announcementDocs.isEmpty) {
                              return const Center(
                                child: Text('No complaints found.'),
                              );
                            }

                            return ListView.builder(
                              itemCount: announcementDocs.length,
                              reverse: false,
                              itemBuilder: (context, index) {
                                final announcement = announcementDocs[index]
                                    .data() as Map<String, dynamic>?;
                                final title =
                                    announcement?['title'] as String? ?? "";
                                final name =
                                    announcement?['name'] as String? ?? "";
                                final room =
                                    announcement?['room'] as String? ?? "";
                                final description =
                                    announcement?['description'] as String? ??
                                        "";
                                final status =
                                    announcement?['status'] as String? ?? "";
                                final timestamp = announcement?['date'];
                                final time = DateTime.parse(timestamp);

                                return AdminComplainContainer(
                                  title: title,
                                  description: description,
                                  timestamp: time,
                                  name: name,
                                  room: room,
                                  docId: timestamp,
                                  status: status,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Container(
                    color: Colors.white,
                    child: const Center(
                      child: SpinKitFadingCube(color: primary, size: 100.0),
                    ),
                  ),
      ),
    );
  }
}
