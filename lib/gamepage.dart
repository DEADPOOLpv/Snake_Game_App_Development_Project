import 'package:SnakeGame/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SnakeGame/black_pixel.dart';
import 'package:SnakeGame/snake_pixel.dart';
import 'package:SnakeGame/food_pixel.dart';
import 'dart:async';
import 'dart:math';

class MyGameStart extends StatelessWidget
{
  const MyGameStart ({Key? key}) : super (key : key);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const GamePage(),
    theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
class GamePage extends StatefulWidget
{
  const GamePage ({Key? key}) : super(key : key);

  @override
  State<GamePage>  createState() => _GamePageState();
}

enum SnakeDirection {UP, DOWN, LEFT, RIGHT}

class _GamePageState extends State<GamePage>
{
  //grid dimensions
  int rowsize = 10;
  int totalnumberofsquares = 100;

  // to check if the game has started
  bool gamehasstarted = false;

  final _nameController = TextEditingController();

  // user score
  int currentscore = 0;

  //snake position
  List<int> snakepos = [0, 1, 2,];

  //snake initially to the right
  var currentdirection = SnakeDirection.RIGHT;

  //food position
  int foodpos = Random().nextInt(100);

  /*//highscore list
  List<String> highscore_DocIds = [];
  late final Future? letsGetDocIds;

  @override
  void initState()
  {
    letsGetDocIds = getDocId();
    super.initState();
  }

  Future getDocId() async
  {
    await FirebaseFirestore.instance.collection('highscores')
        .orderBy('Score',descending: true)
        .limit(5)
        .get()
        .then((value) => value.docs.forEach((element)
    {
      highscore_DocIds.add(element.reference.id);
    }));
  }
*/
  //start game
  void startgame()
  {
    gamehasstarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer)
    {
      setState(()
      {
        //keep the snake moving
        movesnake();

        // check if the game is over
        if (gameover())
        {
          timer.cancel();

          //display message
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context)
            {
              return AlertDialog(
                title: const Text('GAME OVER',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                actions: [MaterialButton(
                    onPressed: ()
                    {
                      Navigator.pop(context);
                      newgame();
                      },
                  child: const Text('New Game'),color: Colors.amberAccent,
                    )
                ],
                /*content: Column(
                  children: [
                    Text('Your Score: ' + currentscore.toString()),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Name'),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: ()
                    {
                      Navigator.pop(context);
                      newgame();
                      },
                    child: const Text('Submit'),
                    color: Colors.amberAccent,
                  )
                ],*/
              );
            },
          );
        }
      });
    });
  }
/*
  void submitscore()
  {
    // access to the database
    var database = FirebaseFirestore.instance;

    //adding the current score, name and date to the database
    database.collection('highscores').add({
      "Name": _nameController.text,
      "Score": currentscore,
    });
  }
*/
  void newgame()
  {
    setState(()
    {
      snakepos = [0,1,2,];
      while (snakepos.contains(foodpos))
      {
        foodpos = Random().nextInt(totalnumberofsquares);
      }
      currentdirection = SnakeDirection.RIGHT;
      gamehasstarted = false;
      currentscore = 0;
    });
  }

  void eatfood()
  {
    currentscore++;
    // to check if foodpos not equal to snakepos
    while (snakepos.contains(foodpos))
    {
      foodpos = Random().nextInt(totalnumberofsquares);
    }
  }

  void movesnake()
  {
    switch (currentdirection)
    {
      case SnakeDirection.RIGHT:
        {
          //if snake is at the right wall re-adjust
          //adding a new head
          if (snakepos.last % rowsize == 9)
          {
            snakepos.add(snakepos.last + 1 - rowsize);
          }
          else
          {
          snakepos.add(snakepos.last + 1);
          }
        }
        break;
      case SnakeDirection.LEFT:
        {
          //adding a new head
          //if snake is at the right wall re-adjust
          if (snakepos.last % rowsize == 0)
          {
            snakepos.add(snakepos.last - 1 + rowsize);
          }
          else
          {
            snakepos.add(snakepos.last - 1);
          }
        }
        break;
      case SnakeDirection.UP:
        {
          //adding a new head
          if(snakepos.last < rowsize)
          {
            snakepos.add(snakepos.last - rowsize + totalnumberofsquares);
          }
          else{
          snakepos.add(snakepos.last - rowsize);
          }
        }
        break;
      case SnakeDirection.DOWN:
        {
          //adding a new head
          if (snakepos.last + rowsize > totalnumberofsquares)
          {
            snakepos.add(snakepos.last + rowsize - totalnumberofsquares);
          }
          else
          {
          snakepos.add(snakepos.last + rowsize);
          }
        }
        break;
      default:
    }

    //snake eats the food
    if (snakepos.last == foodpos)
    {
      eatfood();
    }
    else
    {
      //remove tail
      snakepos.removeAt(0);
    }
  }

  //gameover
  bool gameover()
  {
    //the game is over when the snake eats itself
    // the occur when there is a duplicate position in the snakepas list

    // this list is the body of the snake no head
    List<int> bodysnake = snakepos.sublist(0, snakepos.length -1);

    if (bodysnake.contains(snakepos.last))
    {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          //scores
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //user current score
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Current Score'),
                      Text(
                        currentscore.toString(),
                        style: const TextStyle(fontSize: 36),
                      ),
                    ],
                  ),
                ),

                //high score
                /*Expanded(
                  child: gamehasstarted?
                  Container():
                  FutureBuilder(
                    future: letsGetDocIds,
                    builder: (context, snapshot)
                    {
                      return ListView.builder(
                        itemCount: highscore_DocIds.length,
                        itemBuilder: ((context, index)
                        {
                          return HighScores(documentId: highscore_DocIds[index]);
                        }),
                      );
                    },
                  ),
                )*/
              ],
            ),
          ),

          //game grid
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate:(details)
              {
                if (details.delta.dy < 0 && currentdirection != SnakeDirection.DOWN)
                {
                  currentdirection = SnakeDirection.UP;
                }
                else if (details.delta.dy > 0 && currentdirection != SnakeDirection.UP)
                {
                  currentdirection = SnakeDirection.DOWN;
                }
              },
              onHorizontalDragUpdate:(details)
              {
                if (details.delta.dx > 0 && currentdirection != SnakeDirection.LEFT)
                {
                  currentdirection = SnakeDirection.RIGHT;
                }
                else if(details.delta.dx < 0 && currentdirection != SnakeDirection.RIGHT)
                {
                  currentdirection = SnakeDirection.LEFT;
                }
              },
              child: GridView.builder(
              itemCount: totalnumberofsquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowsize),
                itemBuilder: (context, index)
                {
                  if (snakepos.contains(index))
                  {
                    return const SnakePixel();
                  }
                  else if(foodpos == index)
                  {
                    return const FoodPixel();
                  }
                  else
                  {
                    return const BlankPixel();
                  }
                }
                ),
          ),
                ),
          //play button
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  MaterialButton(
                    color: gamehasstarted? Colors.grey : Colors.red,
                    onPressed: gamehasstarted? () {}:
                    startgame,
                    child: const Text('PLAY')),
                ]
            ),
            ),
        ],
      ),
    );
  }
}