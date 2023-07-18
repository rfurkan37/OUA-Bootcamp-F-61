import 'package:iconsax/iconsax.dart';
import 'package:ortamapp/pages/location.dart';
import 'package:ortamapp/pages/weather.dart';
import 'package:ortamapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'group_pairing_page.dart';


class Home extends StatefulWidget {
  String userName;
  String email;

  Home({Key? key, required this.userName, required this.email}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> images = [
  "https://raw.githubusercontent.com/leventkeles/OUA-Bootcamp-F-61/main/ProjectManagement/assets/thumbnail-3.png",
      "https://raw.githubusercontent.com/leventkeles/OUA-Bootcamp-F-61/main/ProjectManagement/assets/Untitled-2.png",
    "https://raw.githubusercontent.com/leventkeles/OUA-Bootcamp-F-61/main/ProjectManagement/assets/thumbnail-4.png",
  ];

  WeatherData weatherData = WeatherData(locationData: LocationHelper());
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                child:  ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(Iconsax.user,color: Colors.white,),
                  ),
                  title: const Text('Merhaba,', style: TextStyle(fontWeight: FontWeight.w600),),
                  subtitle: Text('${widget.userName}!',),
                  trailing: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Iconsax.setting_25,color: Colors.black87,),
                  ),

                ),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal:0, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          colorFilter:  ColorFilter.mode(Colors.deepPurple.withOpacity(0.6), BlendMode.dstATop),
                          image: AssetImage(
                              'assets/celebrate.png'),
                        ),
                        color: Colors.blue,
                      ),
                      child:  Center (
                          child: Text("ARTIK KAMPÜSÜNDEYİZ!", style: GoogleFonts.fredoka(textStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),), ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    //borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                      child: Stack(
                        children: <Widget>[
                          CarouselSlider(
                            items: images.map((imageUrl) {
                              return Image.network(
                                imageUrl,
                                //fit: BoxFit.cover,
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              autoPlayInterval: const Duration(seconds: 4),
                            ),
                          ),

                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 6,),
            FutureBuilder<void>(
              future: weatherData.locationData.getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return FutureBuilder<void>(
                    future: weatherData.getCurrentTemperature(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final weatherDisplayData =
                        weatherData.getWeatherDisplayData();
                        final roundedTemperature =
                        weatherDisplayData.currentTemperature?.round();
                        return Column(
                          children: [
                            Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                            color: Colors.white,
                            child: Container(
                            padding: const EdgeInsets.symmetric(horizontal:0, vertical: 10),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blueGrey.shade50,
                            ),
                            child:  Center (
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                                children: <Widget>[
                                  weatherDisplayData.weatherIcon,
                                   Text(
                                    '${roundedTemperature}°C',
                            style: GoogleFonts.fredoka(textStyle: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),), ),
                                  Text('${weatherDisplayData.currentDescription?.toUpperCase()}',
                            style: GoogleFonts.fredoka(textStyle: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),), ),
                                ],
                              ),
                            ),
                            ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 15,),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                color: Colors.white,
                child: Container(
                  height: 215.0,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/swipeimg.png'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueGrey.shade50,
                  ),
                ),
              ),

            ),

          ],
        ),
      ),
    );
  }
}