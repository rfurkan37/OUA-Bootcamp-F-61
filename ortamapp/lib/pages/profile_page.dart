import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ortamapp/pages/home_page.dart';
import 'package:ortamapp/pages/utils.dart';
import 'package:ortamapp/pages/home_page.dart';
import 'package:ortamapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/widgets.dart';
import 'auth/login_page.dart';
import 'package:ortamapp/main.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.userName, required this.email}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Profil", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white)),
      ),


      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          // background image and bottom contents
          Column(
            children: <Widget>[
              Container(
                height: 200.0,
                color: Colors.blueGrey.shade900,
                width: double.infinity,
                 child: Image.asset("assets/blur_bg.jpg", fit: BoxFit.fill,opacity: const AlwaysStoppedAnimation(.5),)
              ),
              Container(
                alignment: Alignment.center,
                child: const SizedBox(height: 100,),
              ),
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.indigoAccent,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Iconsax.gallery_export),
                  color: Colors.white,
                  onPressed: () {
                    selectImage();
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: const SizedBox(height: 20,),
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text(widget.userName, style: const TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, textStyle: const TextStyle(fontSize: 20,color: Colors.black),shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),elevation: 0, fixedSize: const Size(250,50),),
                  onPressed: () {
                  },


                ),
              ),
              Container(
                alignment: Alignment.center,
                child: const SizedBox(height: 20,),
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text(widget.email, style: const TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, textStyle: const TextStyle(fontSize: 20,color: Colors.black),shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),elevation: 0, fixedSize: const Size(250,50),),
                  onPressed: () {
                  },


                ),
              ),

            ],

          ),
          // Profile image
          Positioned(
            top: 125.0,
            child: Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                  color: Colors.blueGrey.shade50,
                image: DecorationImage(
                    image: new AssetImage("assets/login_logo.png"),
                    fit: BoxFit.cover
                )


              ),
            ),
          )
        ],
      ),


    );
  }
}

