import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ortamapp/services/auth_service.dart';
import 'package:turkish/turkish.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';
import 'package:google_fonts/google_fonts.dart';

List selectedColors = [Colors.red, Colors.yellow,Colors.blue, Colors.green];

class StickyColors {
  static final List colors = [
    const Color(0xffefefef),
    const Color(0xffefefef),
    const Color(0xffefefef),
    const Color(0xffefefef),
    const Color(0xffefefef),
    const Color(0xffefefef),
    const Color(0xffefefef),
    const Color(0xffefefef),
    const Color(0xffefefef),
    const Color(0xffefefef),
  ];
}

class Badge {
  static final List models = [
    const Icon(Iconsax.medal_star5, color: Colors.lightBlue,size: 50.0, ),
    const Icon(Iconsax.medal_star5, color: Colors.amber,size: 50.0, ),
    const Icon(Iconsax.medal_star5, color: Colors.blueGrey,size: 50.0, ),
     Icon(Iconsax.medal_star5, color: StickyColors.colors[3],size: 50.0, ),
     Icon(Iconsax.medal_star5, color: StickyColors.colors[4],size: 50.0, ),
     Icon(Iconsax.medal_star5, color: StickyColors.colors[5],size: 50.0, ),
     Icon(Iconsax.medal_star5, color: StickyColors.colors[6],size: 50.0, ),
     Icon(Iconsax.medal_star5, color: StickyColors.colors[7],size: 50.0, ),
     Icon(Iconsax.medal_star5, color: StickyColors.colors[8],size: 50.0, ),
     Icon(Iconsax.medal_star5, color: StickyColors.colors[9],size: 50.0, ),
  ];
}

class LeaderBoardPage extends StatefulWidget {
  final String userName;
  final String email;
  LeaderBoardPage({required this.userName, required this.email});

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  AuthService authService = AuthService();
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  void getGroups() async {
    List<Group> groupList = await DatabaseService().getGroups();
    setState(() {
      groups = groupList;
    });
  }

  @override
  Widget build(BuildContext context) {
    Group? maxMembersGroup;

    if (groups.isNotEmpty) {
      groups.sort((a, b) => b.members.length.compareTo(a.members.length));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Liderlik Sıralaması',style: TextStyle(color: Colors.black45)),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Colors.blueGrey.shade50,
      ),
      body:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            color: Colors.white,
            child: Container(
              height: 210.0,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/leaderboard-1.jpg'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey.shade50,
              ),
            ),
          ),
          if (maxMembersGroup != null)
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding:EdgeInsets.all(20),
              //listede kaç grup gözükecek?
              itemCount: groups.length < 10 ? groups.length : 10,
              itemBuilder: (context, index) {
                if (groups[index].groupId != maxMembersGroup?.groupId) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    color: StickyColors.colors[index % StickyColors.colors.length],
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white60,
                          child: Text(groups[index].groupName.substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.black87)),
                        ),
                        //trailing: Text('Sıra: ${index}'),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: StickyColors.colors[index % StickyColors.colors.length],
                          child: Badge.models[index % Badge.models.length],

                        ),
                        title: Text(groups[index].groupName.toUpperCaseTr(),
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('Üye Sayısı: ${groups[index].members.length}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                userName: widget.userName,
                                groupId: groups[index].groupId,
                                groupName: groups[index].groupName,
                              ),
                            ),
                          );
                        },
                      ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class Group {
  final String groupId;
  final String groupName;
  final List<String> members;

  Group({
    required this.groupId,
    required this.groupName,
    required this.members,
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      groupId: map['groupId'],
      groupName: map['groupName'],
      members: List<String>.from(map['members']),
    );
  }
}



class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");

  Future<List<Group>> getGroups() async {
    QuerySnapshot querySnapshot = await groupCollection.get();
    List<Group> groupList = [];

    querySnapshot.docs.forEach((document) {
      Group group = Group.fromMap(document.data() as Map<String, dynamic>);
      groupList.add(group);
    });

    return groupList;
  }


}