import 'package:SnakeGame/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'gamepage.dart';

Future main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyGame());
}

class MyGame extends StatelessWidget
{
  const MyGame({Key? key}) : super (key : key);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: AuthService().handleAuthState()
    );
  }
}

class DisplayPage extends StatelessWidget{
  const DisplayPage ({Key? key}) : super (key : key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.purpleAccent,
            centerTitle: true,
            title : const Text('Snake Game',style: TextStyle(color: Colors.yellowAccent, fontSize: 30))),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/app_snek.jpg'),
                  fit: BoxFit.cover)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children : [
                const Text('High Score \n DEADPOOLpv 40', style: TextStyle(fontSize: 25,color:Colors.deepOrange)),
                TextButton(style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                            (state) => Colors.greenAccent)),
                  child: const Text('PLAY', style: TextStyle(
                      color: Colors.deepOrange, fontSize: 20),),
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyGameStart()),
                  );
                  },
                )
              ]
          ),
        )
    );
  }
}