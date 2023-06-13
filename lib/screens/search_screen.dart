import 'package:chat/helper/helper_function.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/services/database_serivices.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  QuerySnapshot? searchSnapshot;
  bool hasSearched = false;
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();
  String userName = '';
  User? user;
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName() async {
    await HelperFunction.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String val) {
    return val.substring(val.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 11, horizontal: 10)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    searchMethod();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColor.withOpacity(0.2)),
                    child: const Icon(Icons.search),
                  ),
                )
              ],
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : groupList(),
          ],
        ),
      ),
    );
  }

  searchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('Admin :${getName(admin)}'),
      onTap: () async {
        await DatabaseService(uid: user!.uid)
            .toggleGroupJoin(groupId, userName, groupName);
        if (_isJoined) {
          setState(() {
            _isJoined = !_isJoined;
          });
          Future.delayed(const Duration(seconds: 2), () {
            nextScreen(
                context,
                ChatScreen(
                    groupName: groupName,
                    userName: userName,
                    groupId: groupId));
          });
        } else {
          setState(() {
            _isJoined = !_isJoined;
          });
        }
      },
      trailing: InkWell(
        child: _isJoined
            ? const JoinButton(
                title: 'Joined',
                color: Colors.black,
              )
            : JoinButton(
                color: Theme.of(context).primaryColor,
                title: 'Join',
              ),
      ),
    );
  }
}

class JoinButton extends StatelessWidget {
  const JoinButton({
    super.key,
    required this.color,
    required this.title,
  });

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
