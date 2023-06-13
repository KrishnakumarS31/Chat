import 'package:chat/helper/helper_function.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/profile_screen.dart';
import 'package:chat/screens/search_screen.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/database_serivices.dart';
import 'package:chat/widgets/group_tile.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  String userName = '';
  String email = '';
  Stream? groups;
  bool _isLoading = false;
  String groupName = '';

  String getId(String val) {
    return val.substring(0, val.indexOf('_'));
  }

  String getName(String val) {
    return val.substring(val.indexOf('_') + 1);
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    await HelperFunction.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await HelperFunction.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchScreen());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            DrawerList(
              isSelected: true,
              title: 'Groups',
              icon: Icons.group,
              press: () {},
            ),
            DrawerList(
              isSelected: false,
              title: 'Profile',
              icon: Icons.account_circle,
              press: () {
                nextScreen(
                    context,
                    ProfileScreen(
                      email: email,
                      userName: userName,
                    ));
              },
            ),
            DrawerList(
              isSelected: false,
              title: 'Logout',
              icon: Icons.exit_to_app,
              press: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure want to logout?'),
                      actions: [
                        LogoutButton(
                          icon: Icons.cancel,
                          color: Colors.red,
                          onPress: () {
                            Navigator.pop(context);
                          },
                        ),
                        LogoutButton(
                          icon: Icons.done,
                          color: Colors.green,
                          onPress: () async {
                            await authService.signOut();
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false);
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          popUpDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : TextField(
                      onChanged: (value) {
                        groupName = value;
                      },
                      decoration: kInputDecoration,
                    ),
            ],
          ),
          actions: [
            CreateDialogBtn(
                title: 'Cancel',
                onPress: () {
                  Navigator.of(context).pop(context);
                }),
            CreateDialogBtn(
                title: 'Create',
                onPress: () async {
                  if (groupName != '') {
                    setState(() {
                      _isLoading = true;
                    });

                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                  }
                })
          ],
        );
      },
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      userName: snapshot.data['fullName'],
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      groupId: getId(snapshot.data['groups'][reverseIndex]));
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: const Icon(
              Icons.add_circle,
              size: 75,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'You\'ve not joined any group, tap on the add icon button to create a group or search from the top search icon to join the group ',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class CreateDialogBtn extends StatelessWidget {
  const CreateDialogBtn({
    super.key,
    required this.title,
    required this.onPress,
  });

  final String title;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor),
        onPressed: onPress,
        child: Text(title));
  }
}
