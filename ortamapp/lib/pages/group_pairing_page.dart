import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ortamapp/pages/home_page.dart';
import 'package:ortamapp/pages/search_page.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETİK VE AHLAK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ORTAM',),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = [
    "Bir öğrencisiniz ve bir sınıf arkadaşınız size ödevinizi vermenizi istiyor, çünkü onun yapacak vakti yokmuş.Ona ödevinizi verir misin?",
    "Seni çok komik yapan ama aynı zamanda çok saygısız yapan bir mizah anlayışı.Kabul ediyor musun?",
    "Bir uçak kazasında hayatta kalan tek kişi sizsiniz ve bir adaya düşüyorsunuz. Adada başka insanlar da var, ama onlar kabile hayatı yaşıyorlar ve size düşmanca davranıyorlar.Onlarla savaşır mısın ?",
    "Bir otelde kaldığınızda, odanızda bulduğunuz küçük şampuan şişelerini alır mısınız?",
    "Seni çok zengin yapan ama aynı zamanda çok mutsuz yapan bir piyango bileti.Kabul ediyor musun?",
    "Bir restoranda yemek yedikten sonra, hesabı ödemek için gittiğinizde, garsonun size fazla para üstü verdiğini fark ediyorsunuz.Parayı geri verir misin?",
    "Bir arkadaşınız size çok önemli bir sırrını anlatıyor ve kimseye söylememenizi istiyor. Ancak bu sır başka bir arkadaşınızı ilgilendiriyor ve ona zarar verebilir.Sırrı ona söyler misin?",
    "Seni çok mutlu yapan ama aynı zamanda çok bağımlı yapan bir ilüzyon.Kabul ediyor musun?",
    "Bir otobüste seyahat ederken, yanınızdaki koltukta uyuyan bir adamın cebinden cüzdanının düştüğünü görüyorsunuz. Cüzdanında çok para var.Cüzdanı alır mısın?",
    "Seni çok zeki yapan ama aynı zamanda çok unutkan yapan bir hap."
  ];
  List<Color> _colors = [
    Colors.deepPurple.shade200,
    Colors.teal.shade100,
    Colors.purple.shade200,
    Colors.blueGrey.shade300,
    Colors.pink.shade200,
    Colors.purple.shade100,
    Colors.red.shade200,
    Colors.deepPurple.shade300,
    Colors.pink.shade100,
    Colors.cyan.shade200,
  ];

  @override
  void initState() {
    for (int i = 0; i < _names.length; i++) {
      int score = 0;
      _swipeItems.add(SwipeItem(
          content: Content(text: _names[i], color: _colors[i]),
          likeAction: () {
            score= score+3;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("EVET ${_names[i]}"),
              duration: Duration(milliseconds: 500),

            ));
          },
          nopeAction: () {
            score= score-1;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("HAYIR ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          }));
    }


    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }
  int score =0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title:  Text(widget.title!, style: GoogleFonts.fredoka(textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500),), ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => {
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage())),
          }),
        ),
        body: Container(
            child: Stack(children: [
              Container(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  child: SwipeCards(
                    matchEngine: _matchEngine!,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            width: 510,
                            height: 450,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15.0),
                              color: _swipeItems[index].content.color,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                _swipeItems[index].content.text,
                                style: TextStyle(fontSize: 37),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onStackFinished: () {
                      if (score == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPageStateless(category: "Spor")),
                        );
                      } else if (score == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPageStateless(category: "Teknoloji")),
                        );
                      } else if (score == 4) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPageStateless(category: "Eğlence")),
                        );
                      } else if (score == 5) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPageStateless(category: "Gezi")),
                        );
                      } else if (score == 6) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPageStateless(category: "Sanat")),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPageStateless(category: "Bilim")),
                        );
                      }
                    },
                    itemChanged: (SwipeItem item, int index) {
                      print("item: ${item.content.text}, index: $index");
                    },
                    leftSwipeAllowed: true,
                    rightSwipeAllowed: true,
                    upSwipeAllowed: true,
                    fillSpace: true,
                    likeTag: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green)
                      ),
                      child: Text('EVET'),
                    ),
                    nopeTag: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red)
                      ),
                      child: Text('HAYIR'),
                    ),
                  )

              )
            ])));
  }
}
void nextScreenReplace(BuildContext context) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()));
}
class Content {final String text;
final Color color;

Content({required this.text, required this.color});
}

