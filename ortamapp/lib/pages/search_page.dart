import 'package:google_fonts/google_fonts.dart';
import 'package:ortamapp/helper/helper_function.dart';
import 'package:ortamapp/pages/chat_page.dart';
import 'package:ortamapp/services/database_service.dart';
import 'package:ortamapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turkish/turkish.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math';
import 'home_page.dart';

class StickyColors {
  static final List colors = [
    const Color(0xff4df0b5),
    const Color(0xff68c0ff),
    const Color(0xffff7676),
    const Color(0xffb868f6),
    const Color(0xfff2d08c),
    const Color(0xffef6eb1),
  ];
}
final _random = Random();

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  bool isLoading = false;
  QuerySnapshot? searchSnapShot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isJoined = false;
  String category = "";

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }
  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }

  getCurrentUserIdandName() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  TextEditingController searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body:
      SingleChildScrollView(
        child:
        Column(
          children: [
            Container(
              color: Colors.blueGrey.shade50,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.black45),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Grup Arama....",
                        hintStyle: TextStyle(color: Colors.black45, fontSize: 16,),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearchMethod();
                    },
                    child:
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(Icons.search_rounded,color: Colors.black45,),),
                  ),
                  Container(width: 10.0),
                  GestureDetector(
                    onTap: (){
                      nextScreenReplace(context, const HomePage());
                    },
                    child:
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(Iconsax.category,color: Colors.black45,),),


                  )
                ],
              ),
            ),
            isLoading ? Center(
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
            ) :
            groupList(),
          ],
        ),
      ),
    );
  }
  categoryListMethod(String getCategory) async {
    setState(() {
      isLoading = true;
    });
    String userEmailDomain = user!.email!.split('@')[1]; // Kullanıcının e-posta alan adını al

    await DataBaseService().searchByCategory(userEmailDomain, getCategory).then((snapshot) {
      setState(() {
        searchSnapShot = snapshot;
        isLoading = false;
      });
    });
  }
  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      String userEmailDomain = user!.email!.split('@')[1]; // Kullanıcının e-posta alan adını al
      await DataBaseService().searchByDomain(searchController.text, userEmailDomain).then((snapshot) {
        setState(() {
          searchSnapShot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }
  groupList() {
    return  searchSnapShot != null
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapShot!.docs.length,
      itemBuilder: (context, index) {
        return groupTile(
          userName,
          searchSnapShot!.docs[index]["groupId"],
          searchSnapShot!.docs[index]['groupName'].toUpperCase(),
          searchSnapShot!.docs[index]["admin"],
          searchSnapShot!.docs[index]["category"],
        );
      },
    )
        :  Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          categoryBox(),
          const SizedBox(height: 20,),
          categoryBox2(),
          const SizedBox(height: 20,),
          categoryBox3(),
        ],
      ),
    );
  }




  joinedOrNot(String userName, String groupId, String groupName, String admin) async {
    bool userJoined = await DataBaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName);
    setState(() {
      isJoined = userJoined;
    });
  }
  Widget groupTile(String userName, String groupId, String groupName, String admin, String category){
    // üyeleri kontrol eder
    joinedOrNot(userName,groupId,groupName,admin);

    return ListTile(

      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
      leading: CircleAvatar(radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(groupName.substring(0,1).toUpperCaseTr(), style: const TextStyle(color: Colors.white),),
      ),
      title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text("Admin: ${getName(admin)} | ${getName(category)}"),
      trailing: InkWell(
        onTap: ()async{
          await DataBaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
          if(isJoined){
            setState(() {
              isJoined = !isJoined;
              showSnakbar(context, Colors.green, "Başarılı bir şekilde gruba girdiniz");
            });
            Future.delayed(const Duration(milliseconds: 2000),(){
              nextScreen(context, ChatPage(userName: userName, groupId: groupId, groupName: groupName));
            });
          }
          else{
            setState(() {
              isJoined = !isJoined;
              showSnakbar(context, Colors.red, "Gruptan ayrıl $groupName");
            });
          }
        },
        child: isJoined ? Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.teal.shade600,
              border: Border.all(color: Colors.white, width: 1)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text("Katıldınız", style: TextStyle(color: Colors.white),),
        ):Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text("Şimdi Katıl", style: TextStyle(color: Colors.white),),
        ),
      ),
    );

  }

  categoryBox(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 0,
            backgroundColor:
            StickyColors.colors[_random.nextInt(6)],
            fixedSize: const Size(160, 160),
          ),
          onPressed: () {
            categoryListMethod("Bilim");
          },
          child: const Wrap(
            children: <Widget>[
              Icon(Iconsax.glass, color: Colors.white),
              SizedBox(width: 10),
              Text("Bilim",style:  TextStyle(color: Colors.white),),
            ],
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 0,
            backgroundColor:
            StickyColors.colors[_random.nextInt(6)],
            fixedSize: const Size(160, 160),
          ),
          onPressed: () {
            categoryListMethod("Eğlence");
          },
          child: const Wrap(
            children: <Widget>[
              Icon(Iconsax.glass, color: Colors.white),
              SizedBox(width: 10),
              Text("Eğlence",style:  TextStyle(color: Colors.white),),
            ],
          ),
        ),
      ],
    );

  }
  categoryBox2(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),elevation: 0,backgroundColor: StickyColors.colors[_random.nextInt(6)], fixedSize: const Size(160, 160),),
          onPressed: () {
            categoryListMethod("Gezi");
          },
          child: const Wrap(
            children: <Widget>[
              Icon(Iconsax.align_vertically, color: Colors.white,),
              SizedBox(width: 10),
              Text("Gezi",style:  TextStyle(color: Colors.white),),

            ],
          ),

        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),elevation: 0,backgroundColor: StickyColors.colors[_random.nextInt(6)], fixedSize: const Size(160, 160),),
          onPressed: () {
            categoryListMethod("Sanat");
          },
          child: const Wrap(
            children: <Widget>[
              Icon(Iconsax.brush_4, color: Colors.white,),
              SizedBox(width: 10),
              Text("Sanat",style:  TextStyle(color: Colors.white),),

            ],
          ),

        ),

      ],
    );

  }
  categoryBox3(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),elevation: 0,backgroundColor: StickyColors.colors[_random.nextInt(6)], fixedSize: const Size(160, 160),),
          onPressed: () {
            categoryListMethod("Spor");
          },
          child: const Wrap(
            children: <Widget>[
              Icon(Iconsax.flash_1, color: Colors.white,),
              SizedBox(width: 10),
              Text("Spor",style:  TextStyle(color: Colors.white),),

            ],
          ),

        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),elevation: 0,backgroundColor: StickyColors.colors[_random.nextInt(6)], fixedSize: const Size(160, 160),),
          onPressed: () {
            categoryListMethod("Teknoloji");
          },
          child: const Wrap(
            children: <Widget>[
              Icon(Iconsax.cpu, color: Colors.white,),
              SizedBox(width: 10),
              Text("Teknoloji",style:  TextStyle(color: Colors.white),),

            ],
          ),

        ),

      ],
    );

  }

}

class SearchPageStateless extends StatelessWidget {
  final String category;

  const SearchPageStateless({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title:  Text("ORTAM", style: GoogleFonts.fredoka(textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500),), ),
        leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => {
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage())), }),

      ),
      body: Center(
          child: Text("$category gruplarına göz atmalısın",
              style: TextStyle(fontSize: 50), textAlign: TextAlign.center)
      ),
    );
  }
}